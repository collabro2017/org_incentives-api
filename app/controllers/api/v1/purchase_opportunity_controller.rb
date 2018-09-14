module Api
  module V1
    class PurchaseOpportunityController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        purchase_config = tenant.purchase_configs.find(params[:purchase_config_id])
        render json: { data: purchase_config.purchase_opportunities }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        purchase_config_id = params[:purchase_config_id]
        purchase_config = tenant.purchase_configs.find(purchase_config_id)

        if purchase_config.nil?
          render json: { error: "Could not find purchase config with purchase_config_id=#{purchase_config_id}" }, status: :not_found
        else
          opportunity = purchase_config.purchase_opportunities.create!(purchase_opportunity_params)
          render json: { data: opportunity }, status: :created
        end
      end

      def update
        tenant = Tenant.find(@tenant)
        purchase_opportunity = tenant.purchase_opportunities.find(params[:id])
        if purchase_opportunity.update_attributes(purchase_opportunity_params)
          render json: { data: purchase_opportunity }, status: :ok
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      def destroy
        tenant = Tenant.find(@tenant)
        purchase_opportunity = tenant.purchase_opportunities.find(params[:id])
        purchase_opportunity.destroy!
        render json: {}, status: :ok
      end

      def purchase_opportunity_params
        params.permit(:maximumAmount, :employee_id, :document_id)
      end
    end
  end
end