module Api
  module V1
    class ExerciseOrderController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        user_service = UserService.new(@token, tenant)

        if user_service.is_admin
          if params[:include_vesting_event].present?
            render json: {data: tenant.exercise_orders.as_json(include: [:employee, exercise_order_lines: { include: :vesting_event }]) }, status: :ok
          else
            render json: {data: tenant.exercise_orders.as_json(include: [:employee, :exercise_order_lines]) }, status: :ok
          end
        else
          render json: {data: user_service.user_orders }, status: :ok
        end

      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}, status: :not_found
      end

      def create
        tenant = Tenant.find(@tenant)
        user_id = TokenService.new(@token).user_id
        user_awards = AwardsService.new(tenant, user_id).user_awards
        order_lines = params[:exercise_order_lines]
        order = nil
        employee = tenant.employees.find_by! account_id: user_id
        ActiveRecord::Base.transaction do
          # Update existing vesting events
          user_awards.each {|award|
            award.vesting_events.each {|ve|
              ve_order_lines = order_lines.select {|ol| ol[:vestingEventId] == ve.id}
              unless ve_order_lines.empty?
                order = ve_order_lines[0]
                if ve.quantity - order[:exerciseQuantity] < 0
                  raise StandardError, "Not enough options to exercise the ordered quantity"
                else
                  ve.quantity = ve.quantity - order[:exerciseQuantity]
                  ve.exercisedQuantity = ve.exercisedQuantity + order[:exerciseQuantity]
                end
                ve.save!
              end
            }
          }

          # Create the order
          exercise_order_lines = order_lines.map { |ol| ExerciseOrderLine.new(vesting_event_id: ol[:vestingEventId], exercise_quantity: ol[:exerciseQuantity]) }
          order = tenant.exercise_orders.create!({ status: "CREATED", employee_id: employee.id, exerciseType: exercise_order_params[:exerciseType], exercise_order_lines: exercise_order_lines, vps_account: exercise_order_params[:vps_account] })
        end

        unless tenant.id == 'ab72f7d8-601c-4026-ba0f-54a477d8069d' || tenant.id == '4ec935e0-829e-4318-af26-2751eb07ea9b'
          EmailService.new(Rails.application.secrets.sendgrid_api_key).send_exercise_order_confirmation(employee.email, order, tenant)
        end

        render json: { data: order }, status: :created
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        order = tenant.exercise_orders.find(params[:id])
        if order.present?
          order.update_attributes!(update_params)
          render json: { data: order }, status: :ok
        else
          render json: { message: "Exercise order not found" }, status: :not_found
        end
      end

      def update_params
        params.permit(:status)
      end

      def exercise_order_params
        params.permit(:exerciseType, :vps_account, :exercise_order_lines => [:vestingEventId, :exerciseQuantity])
      end
    end
  end
end
