require 'sendgrid-ruby'
include ActionView::Helpers::NumberHelper
include SendGrid


module OrderExerciseType
  EXERCISE_AND_HOLD = "EXERCISE_AND_HOLD"
  EXERCISE_AND_SELL = "EXERCISE_AND_SELL"
  EXERCISE_AND_SELL_TO_COVER = "EXERCISE_AND_SELL_TO_COVER"
end


class EmailService
  def initialize(send_grid_api_key)
    @send_grid_api_key = send_grid_api_key
  end

  def send_exercise_order_confirmation(recipient_email, template, exercise_order, tenant)
    email_content = ExerciseConfirmationEmail.new
    email_content.template = template
    email_content[:portal_url] = Rails.application.secrets.incentives_portal_origin
    email_content[:exercise_type] = {
        exercise_and_hold: exercise_order.exerciseType == OrderExerciseType::EXERCISE_AND_HOLD,
        exercise_and_sell: exercise_order.exerciseType == OrderExerciseType::EXERCISE_AND_SELL,
        exercise_and_sell_to_cover: exercise_order.exerciseType == OrderExerciseType::EXERCISE_AND_SELL_TO_COVER
    }
    email_content[:totalInstrumentsExercised] = exercise_order.totalInstrumentsExercised
    email_content[:instrumentName] = options_vs_warrants(exercise_order)
    email_content[:exercise_type_name] = exercise_type_text(exercise_order.exerciseType)

    email_content[:bank_account_number] = tenant.bank_account_number
    email_content[:has_foreign_account] = tenant.bic_number.present? && tenant.iban_number.present?

    if email_content[:has_foreign_account]
      email_content[:bic_number] = tenant.bic_number
      email_content[:iban_number] = tenant.iban_number
    end

    email_content[:has_payment_address] = tenant.payment_address.present? && !tenant.payment_address.to_s.strip.empty?

    if email_content[:has_payment_address]
      email_content[:payment_address_lines] = tenant.payment_address.split("\n").map { |address_line| { address_line: address_line } }
    end

    email_body = email_content.render

    send_grid_body = standard_email(recipient_email, email_body, "Exercise Order Confirmation")
    send_email(send_grid_body.as_json)
  end

  def spaces_on(number,delimiter=" ")
    number.to_s.tap do |s|
      :go while s.gsub!(/^([^.]*)(\d)(?=(\d{3})+)/, "\\1\\2#{delimiter}")
    end
  end


  def send_purchase_order_confirmation(recipient_email, template, tenant, totalPrice, paymentDeadline)
    purchase_email_content = PurchaseConfirmationEmail.new
    purchase_email_content.template = template
    purchase_email_content[:portal_url] = Rails.application.secrets.incentives_portal_origin
    purchase_email_content[:totalPrice] = "#{number_to_currency(totalPrice, precision: 2, separator: ",", delimiter: " ", unit: "#{tenant.currency_code} ")}"
    purchase_email_content[:paymentDeadline] = paymentDeadline.strftime("%d.%m.%y %H:%M")
    purchase_email_content[:bank_account_number] = tenant.bank_account_number
    purchase_email_content[:has_foreign_account] = tenant.bic_number.present? && tenant.iban_number.present?

    if purchase_email_content[:has_foreign_account]
      purchase_email_content[:bic_number] = tenant.bic_number
      purchase_email_content[:iban_number] = tenant.iban_number
    end

    purchase_email_content[:has_payment_address] = tenant.payment_address.present? && !tenant.payment_address.to_s.strip.empty?

    if purchase_email_content[:has_payment_address]
      purchase_email_content[:payment_address_lines] = tenant.payment_address.split("\n").map { |address_line| { address_line: address_line } }
    end

    email_body = purchase_email_content.render

    send_grid_body = standard_email(recipient_email, email_body, "Purchase Order Confirmation")
    send_email(send_grid_body.as_json)
  end

  def send_email(request_json)
    sg = SendGrid::API.new(api_key: @send_grid_api_key)
    begin
      response = sg.client.mail._("send").post(request_body: request_json)
      puts response.status_code
      puts response.body
      puts response.headers
      response
    rescue Exception => e
      puts e.message
      nil
    end
  end

  def standard_email(recipient_email, content, subject)
    {
        "personalizations": [
            {
                "to": [
                    {
                        "email": recipient_email
                    }
                ],
                "subject": subject
            }
        ],
        "from": {
            "email": "post@optioincentives.no",
            "name": "Incentives Portal"
        },
        "content": [
            {
                "type": "text/html",
                "value": content
            }
        ],
        "template_id": "d673e8cd-03a1-4dde-a677-7a1a93240550"
    }
  end

  def options_vs_warrants(exercise_order)
    'options'
  end

  def view_details_section
    "Login to the portal to view your order: #{Rails.application.secrets.incentives_portal_origin}"
  end

  def exercise_type_text(exercise_type)
    if exercise_type == OrderExerciseType::EXERCISE_AND_HOLD
      "Exercise and Hold"
    elsif exercise_type == OrderExerciseType::EXERCISE_AND_SELL
      "Exercise and Sell"
    else
      "Exercise and Sell to cover"
    end
  end
end