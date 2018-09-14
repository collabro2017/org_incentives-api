module Api
  module V1
    class OrdersController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        user_service = UserService.new(@token, tenant)

        if user_service.is_admin
          render json: {
              data: tenant.orders.as_json(
                  include: [
                      :employee,
                      { purchase_order: { include: { purchase_opportunity: { include: :purchase_config } } } },
                      { exercise_order: { include: { exercise_order_lines: { include: :vesting_event } } } }
                  ]
              )
          }, status: :ok
        else
          render json: {
              data: user_service.employee.orders.as_json(
                  include: [
                      { purchase_order: { include: { purchase_opportunity: { include: :purchase_config } } } },
                      { exercise_order: { include: { exercise_order_lines: { include: :vesting_event } } } }
                  ],
                  except: [:employee_id, :tenant_id]
              )
          }, status: :ok
        end

      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}, status: :not_found
      end

      def create
        tenant = Tenant.find(@tenant)
        user_id = TokenService.new(@token).user_id
        order_service = OrderService.new(tenant, user_id, params)

        if order_params[:order_type] == "PURCHASE"
          order = order_service.handle_purchase_order
          render json: { data: order.as_json(include: :purchase_order ) }, status: :created
        elsif order_params[:order_type] == "EXERCISE"
          order = order_service.handle_exercise_order
          render json: { data: order }, status: :created
        else
          render json: { message: "Order type '#{order_params[:order_type]}' not recognized" }, status: :bad_request
        end

      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        order = tenant.orders.find(params[:id])
        if order.present?
          order.update_attributes!(update_params)
          render json: { data: order }, status: :ok
        else
          render json: { message: "Order not found" }, status: :not_found
        end
      end

      def update_params
        params.permit(:status)
      end

      def exercise_order_params
        params.permit(:data => [:exerciseType, :vps_account, :bank_account, :exercise_order_lines => [:vestingEventId, :exerciseQuantity]])
      end

      def order_params
        params.permit(:order_type)
      end

      def purchase_order_params
        params.permit(:data => [:purchase_amount, :purchase_opportunity_id])
      end
    end
  end
end
