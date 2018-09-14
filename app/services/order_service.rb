class OrderService
  def initialize(tenant, user_id, params)
    @tenant = tenant
    @user_id = user_id
    @employee = tenant.employees.find_by! account_id: user_id
    @params = params
  end

  def handle_purchase_order
    purchase_opportunity_id = purchase_order_params[:data][:purchase_opportunity_id]
    purchase_opportunity = @tenant.purchase_opportunities.find(purchase_opportunity_id)
    purchasable_amount = purchase_opportunity.maximumAmount - purchase_opportunity.purchasedAmount
    order_amount = purchase_order_params[:data][:purchase_amount]

    raise StandardError, "Order quantity exceeds the maximum order quantity." unless order_amount <= purchasable_amount

    order = nil
    ActiveRecord::Base.transaction do
      purchase_config = purchase_opportunity.purchase_config
      sub_program = purchase_config.incentive_sub_program

      purchase_order = PurchaseOrder.new(
          purchase_amount: order_amount,
          purchase_opportunity_id: purchase_opportunity_id,
          instrument_type: sub_program.instrumentTypeId,
          share_depository_account: purchase_order_params[:data][:share_depository_account]
      )

      order = @employee.orders.create!(
          status: "CREATED",
          order_type: order_params[:order_type],
          window_id: order_params[:window_id],
          tenant_id: @tenant.id,
          purchase_order: purchase_order
      )

      order.order_documents.create!(document_id: purchase_opportunity.document_id)

      template = sub_program.incentive_sub_program_template

      award = sub_program.awards.create!(employee_id: @employee.id, quantity: order_amount)
      template.vesting_event_templates.map { |vet|
        quantity = vet.quantityPercentage * order_amount
        vesting_event = award.vesting_events.create!(
            quantity: quantity,
            vestedDate: vet.vestedDate,
            strike: vet.strike,
            grant_date: vet.grant_date,
            expiry_date: vet.expiry_date,
            purchase_price: vet.purchase_price
        )
        vesting_event.transactions.create!(
            transaction_type: "GRANT",
            transaction_date: vet.grant_date,
            grant_date: vet.grant_date,
            vested_date: vet.vestedDate,
            expiry_date: vet.expiry_date,
            quantity: quantity,
            purchase_price: vet.purchase_price,
            strike: vet.strike
        )
      }

      purchase_opportunity.purchasedAmount = purchase_opportunity.purchasedAmount + order_amount
      purchase_opportunity.save!

      unless @tenant.id == 'ab72f7d8-601c-4026-ba0f-54a477d8069d' || @tenant.id == '4ec935e0-829e-4318-af26-2751eb07ea9b'
        template = ContentTemplate.find_by(template_type: "EMAIL_PURCHASE_CONFIRMATION")
        totalPrice = purchase_config.price * order_amount
        paymentDeadline = purchase_config.window.payment_deadline
        EmailService.new(Rails.application.secrets.sendgrid_api_key).send_purchase_order_confirmation(@employee.email, template.raw_content, @tenant, totalPrice, paymentDeadline)
      end

    end
    order
  end

  def handle_exercise_order
    user_awards = AwardsService.new(@tenant, @user_id).user_awards
    order_lines = exercise_order_params[:data][:exercise_order_lines]
    order = nil
    ActiveRecord::Base.transaction do
      # Update existing vesting events
      user_awards.each {|award|
        award.vesting_events.each {|ve|
          ve_order_lines = order_lines.select {|ol| ol[:vestingEventId] == ve.id}
          unless ve_order_lines.empty?
            vesting_order = ve_order_lines[0]
            if ve.quantity - vesting_order[:exerciseQuantity] < 0
              raise StandardError, "Not enough options to exercise the ordered quantity"
            else
              ve.transactions.create!(
                  transaction_type: "EXERCISE",
                  transaction_date: Date.today,
                  quantity: -1 * vesting_order[:exerciseQuantity]
              )
            end
            ve.save!
          end
        }
      }

      # Create the order
      exercise_order_lines = order_lines.map { |ol| ExerciseOrderLine.new(vesting_event_id: ol[:vestingEventId], exercise_quantity: ol[:exerciseQuantity]) }

      exercise_order = @tenant.exercise_orders.new(
          employee_id: @employee.id,
          exerciseType: exercise_order_params[:data][:exerciseType],
          exercise_order_lines: exercise_order_lines,
          vps_account: exercise_order_params[:data][:vps_account],
          bank_account: exercise_order_params[:data][:bank_account]
      )

      order = @employee.orders.create!(
          status: "CREATED",
          order_type: order_params[:order_type],
          window_id: order_params[:window_id],
          tenant_id: @tenant.id,
          exercise_order: exercise_order
      )

      unless @tenant.id == 'ab72f7d8-601c-4026-ba0f-54a477d8069d' || @tenant.id == '4ec935e0-829e-4318-af26-2751eb07ea9b'
        template = ContentTemplate.find_by(template_type: "EMAIL_EXERCISE_CONFIRMATION")
        EmailService.new(Rails.application.secrets.sendgrid_api_key).send_exercise_order_confirmation(@employee.email, template.raw_content, exercise_order, @tenant)
      end
    end

    begin
      self.notify_slack(order)
    rescue Exception => e
      logger.error "Error while trying to post notification to Slack. Message: #{e.message}"
      nil
    end

    order
  end

  def notify_slack(order)
    stock_price = @tenant.stock_prices.order('date DESC, created_at DESC').first
    order_quantity = order.order_quantity
    exerciseType = order.exercise_order.exerciseType
    commission_factor = order.window.commission_percentage / 100
    total_quantity_for_window = order.window.sum_cashless_orders_quantities

    cashless_potential = order_quantity * stock_price.price * commission_factor / 2
    cashless_potential_window_accumulated = total_quantity_for_window * stock_price.price * commission_factor / 2

    if exerciseType == OrderExerciseType::EXERCISE_AND_HOLD
      message = "New order | Exercise and hold | Quantity: #{order_quantity}"
    elsif exerciseType == OrderExerciseType::EXERCISE_AND_SELL
      message = ":tada: CASHLESS | Exercise and sell | Quantity: #{order_quantity} | Cashless potential: *#{cashless_potential}* | Cashless potential this window: *#{cashless_potential_window_accumulated}* | Share price: #{stock_price.price}"
    else
      message = ":tada: CASHLESS | Exercise and sell to cover | Quantity: #{order_quantity} | Cashless potential: *#{cashless_potential}* | Cashless potential this window: *#{cashless_potential_window_accumulated}* | Share price: #{stock_price.price}"
    end

    uri = URI(ENV["SLACK_EXERCISE_URL"])
    res = Net::HTTP.post(uri, { "text" => message }.to_json, { 'Content-Type' =>'application/json' })
  end

  def exercise_order_params
    @params.permit(:data => [:exerciseType, :vps_account, :bank_account, :exercise_order_lines => [:vestingEventId, :exerciseQuantity]])
  end

  def order_params
    @params.permit(:order_type, :window_id)
  end

  def purchase_order_params
    @params.permit(:data => [:purchase_amount, :purchase_opportunity_id, :share_depository_account])
  end
end