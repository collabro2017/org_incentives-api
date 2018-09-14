module Api
  module V1
    class PurchaseConfigController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        sub_program = tenant.incentive_sub_programs.find(params[:sub_program_id])
        render json: { data: sub_program.purchase_config }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        sub_program_id = params[:sub_program_id]
        sub_program = tenant.incentive_sub_programs.find(sub_program_id)

        if sub_program.nil?
          render json: { error: "Could not find sub program with sub_program_id=#{sub_program_id}" }, status: :not_found
        elsif sub_program.purchase_config.present?
          render json: { error: "Purchase config already exists for sub_program_id=#{sub_program_id}" }, status: :bad_request
        else
          sub_program.purchase_config = PurchaseConfig.new(purchase_config_params)
          sub_program.purchase_config.save!
          render json: { data: sub_program.purchase_config }, status: :created
        end
      end

      def update
        tenant = Tenant.find(@tenant)
        purchase_config = tenant.purchase_configs.find(params[:id])
        purchase_config.update_attributes!(purchase_config_params)
        render json: { data: purchase_config }, status: :ok
      end

      def destroy
        tenant = Tenant.find(@tenant)
        purchase_config = tenant.purchase_configs.find(params[:id])
        purchase_config.destroy!
        render json: {}, status: 200
      end

      def purchase_config_params
        params.permit(:price, :window_id, :require_share_depository)
      end
    end
  end
end