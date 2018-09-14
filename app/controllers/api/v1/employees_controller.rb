require 'net/https'

class ExpiredManagementTokenError < StandardError
end


module Api
  module V1
    class EmployeesController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        render json: {data: tenant.employees.as_json(methods: :entity)}, status: :ok
      end

      def show
        employee = Employee.find(params[:id])
        render json: {data: employee}, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        employee = tenant.employees.new(employee_params)

        begin
          employee.account_id = create_or_update_user_account employee.email, @tenant, employee.firstName, employee.lastName
        rescue ExpiredManagementTokenError => e
          logger.error e.message
          render json: {message: "Unable to create user account"}, status: :bad_request
          return
        end

        tenant.save!
        render json: {data: employee}, status: :created
      end

      def destroy
        tenant = Tenant.find(@tenant)
        employee = tenant.employees.find(params[:id])
        account_id = employee.account_id
        employee.destroy!
        if delete_user_account account_id
          render json: {}, status: 200
        else
          render json: {message: "Not able to delete user account"}, status: 500
        end
      end

      def termination # Terminate the employee
        tenant = Tenant.find(@tenant)
        employee = tenant.employees.find(params[:id])
        termination_date = params[:termination_date]

        if employee.termination_date.present?
          render json: { message: "This employee is already terminated" }, status: 400
          return
        end

        ActiveRecord::Base.transaction do
          employee.termination_date = termination_date
          employee.save!

          if params[:termination_type] == "TERMINATE_ALL_NOT_FULLY_VESTED"
            employee.vesting_events.all.map { |ve|
              # Terminate all tranches that are not fully vested
              if employee.termination_date < ve.vested_date and employee.termination_date < ve.expiry_date
                ve.transactions.create!(
                    transaction_type: "TERMINATION",
                    transaction_date: termination_date,
                    termination_date: termination_date,
                    termination_quantity: ve.quantity * -1
                )
              end
            }
          elsif params[:termination_type] == "ACCELERATE_VESTING"
            new_vesting_date = Date.new(employee.termination_date) - 1
            params[:accelerate_quantities].each { |aq|
              tranche_id = aq[:tranche_id]
              accelerate_quantity = aq[:accelerate_quantity]
              terminate_quantity = aq[:terminate_quantity]

              vesting_event = tenant.vesting_events.find(tranche_id)

              # To transaksjoner som dette, eller en egen dedikert for akselerert vesting ved terminering?
              vesting_event.transactions.create!(
                  transaction_type: "ADJUSTMENT_QUANTITY",
                  transaction_date: new_vesting_date,
                  vested_date: new_vesting_date,
                  quantity: -1 * terminate_quantity,
                  fair_value: vesting_event.fair_value

              )
              vesting_event.transactions.create!(
                  transaction_type: "ADJUSTMENT_VESTING_DATE",
                  transaction_date: new_vesting_date,
                  vested_date: new_vesting_date,
              )
            }
          end

        end
        render json: {}, status: 200
      end

      def create_or_update_user_account(email, tenant_id, first_name, last_name)
        access_token = fetch_access_token
        uri = URI("#{Rails.application.secrets.auth0_domain}api/v2/users")
        res = Net::HTTP.post(uri, {
            "connection" => "email",
            "email" => email,
            "user_metadata" => {
                "name": "#{first_name} #{last_name}",
                "first_name": first_name,
                "last_name": last_name
            },
            "app_metadata" => {
                "tenants": [tenant_id],
                "roles": ["user"]
            },
            "email_verified" => true,
            "verify_email" => false
        }.to_json, {
            'Content-Type' =>'application/json',
            'Authorization' => "Bearer #{access_token}"
        })

        body = JSON.parse(res.body)

        if res.code == '401'
          raise ExpiredManagementTokenError, body
        end

        if number_or_nil(res.code) >= 400
          logger.error res.body
        end

        body['user_id'].split('|').last
      end

      def fetch_access_token
        uri = URI("#{Rails.application.secrets.auth0_management_api_origin}/oauth/token")
        res = Net::HTTP.post(uri, {
            "grant_type" => "client_credentials",
            "client_id" => Rails.application.secrets.auth0_management_api_client_id,
            "client_secret" => Rails.application.secrets.auth0_management_api_client_secret,
            "audience" => Rails.application.secrets.auth0_management_api_audience
        }.to_json, {'Content-Type' => 'application/json'})

        if number_or_nil(res.code) >= 400
          logger.error res.body
        end

        body = JSON.parse(res.body)
        body['access_token']
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        employee = tenant.employees.find(params[:id])
        if employee.present?
          employee.update_attributes!(employee_params)
          render json: { data: employee }, status: :ok
        else
          render json: { message: "Employee not found" }, status: :not_found
        end
      end

      def employee_params
        params.permit(:firstName, :lastName, :email, :entity_id, :residence, :insider, :soc_sec, :internal_identification)
      end

      def delete_user_account(account_id)
        access_token = fetch_access_token
        uri = URI("#{Rails.application.secrets.auth0_domain}api/v2/users/#{ERB::Util.url_encode "email|"}#{account_id}")
        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Delete.new(uri.path, {
              'Authorization' => "Bearer #{access_token}"
          })
          http.request request # Net::HTTPResponse object
        end

        if res.code != '204'
          logger.error "Failed to delete user from Auth0, status code #{res.code}, body #{JSON.parse(res.body)}"
        end

        res.code == '204' # Status code 204 is sent when the user was deleted from Auth0
      end

      def number_or_nil(string)
        Integer(string || '')
      rescue ArgumentError
        nil
      end
    end
  end
end