module Api
  module V1
    class WindowsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        render json: {data: tenant.windows.as_json(self.window_include_descendants) }, status: :ok
      end

      def window_include_descendants
        {
            include: {
                window_restriction: {
                    include: :window_employee_restrictions
                }
            }
        }
      end

      def create
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'sysadmin'
        window = nil
        ActiveRecord::Base.transaction do
          window = tenant.windows.create!(window_params)
          restricted_employees = params[:restricted_employees]
          if restricted_employees.present? and !restricted_employees.empty?
            puts "creating employee restriction"
            window.window_restriction = WindowRestriction.create!(employee_restriction: true, window_id: window.id)
            restricted_employees.each {|employee_id|
              window.window_restriction.window_employee_restrictions.create!(employee_id: employee_id)
            }
          end
        end
        if window.present?
          render json: {data: window.as_json(self.window_include_descendants)}, status: :created
        else
          render json: { message: "Window creation failed" }, status: :internal_server_error
        end
      end

      def destroy
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'sysadmin'
        window = tenant.windows.find(params[:id])
        window.destroy!
        render json: {}, status: :ok
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        window = tenant.windows.find(params[:id])
        if window.present?
          ActiveRecord::Base.transaction do
            window.update_attributes!(window_params)
            restricted_employees = params[:restricted_employees]
            if restricted_employees.nil? and window.window_restriction.present?
              window.window_restriction.destroy!
            elsif restricted_employees.present?
              restriction = window.window_restriction.present? ? window.window_restriction : WindowRestriction.create!(employee_restriction: true, window_id: window.id)
              restriction.window_employee_restrictions.destroy_all
              restricted_employees.each {|employee_id|
                restriction.window_employee_restrictions.create!(employee_id: employee_id)
              }
            end
          end
          render json: {data: window.as_json(self.window_include_descendants)}, status: :ok
        else
          render json: {message: "Window not found"}, status: :not_found
        end
      end

      def window_params
        params.permit(:start_time, :end_time, :payment_deadline, :window_type, :require_bank_account, :require_share_depository, :commission_percentage, allowed_exercise_types: [])
      end
    end
  end
end
