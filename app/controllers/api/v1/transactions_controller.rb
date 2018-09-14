module Api
  module V1
    class TransactionsController < ApplicationController
      include SecuredAdmin

      def create
        tenant = Tenant.find(@tenant)
        tranche = tenant.vesting_events.find(params[:vesting_event_id])
        account_id = UserService.new(@token, @tenant).user_id
        transaction = tranche.transactions.new(create_transaction_params)
        transaction.account_id = account_id
        transaction.save!
        render json: { data: transaction }, status: :created
      end

      def update
        tenant = Tenant.find(@tenant)
        t = tenant.transactions.find(params[:id])
        t.update_attributes!(update_transaction_params)
        render json: { data: t }, status: :ok
      end

      def update_transaction_params
        params.permit(:fair_value)
      end

      def create_transaction_params
        params.permit(:fair_value, :vested_date, :transaction_type, :transaction_date, :strike)
      end
    end
  end
end