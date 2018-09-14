module Api
  module V1
    class TenantsController < ApplicationController
      include SecuredSysadmin

      def index
        tenants = Tenant.order('name')
        #render json: { data: tenants.to_json(:include => :incentive_programs) }, status: :ok
        render json: { data: tenants }, status: :ok
      end

      def show
        tenant = Tenant.find(params[:id])
        render json: { data: tenant }, status: :ok
      end

      def create
        tenant = Tenant.new(tenant_params)
        if feature_params[:feature].nil?
          tenant.feature = Feature.new(default_feature)
        else
          tenant.feature = Feature.new(feature_params[:feature])
        end
        if tenant.save
          render json: { data: tenant }, status: :created
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      def update
        tenant = Tenant.find(params[:id])
        if tenant.update_attributes(tenant_params)
          unless feature_params[:feature].nil?
            tenant.feature.update_attributes(feature_params[:feature])
          end

          render json: { data: tenant }, status: :ok
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      def destroy
        tenant = Tenant.find(params[:id])
        tenant.destroy!
        # Todo: Destroy all users from Auth0
        render json: {}, status: :ok
      end

      def update_config
        tenant = Tenant.find(params[:id])

        if tenant.config.nil?
          tenant.config = Config.new(texts: params[:texts])
          tenant.config.save!
          render json: {data: tenant.config}, status: :created
        else
          tenant.config.update_attributes!(texts: params[:texts])
          render json: {data: tenant.config}, status: :ok
        end
      end

      def default_config
        Config.find('71184113-81aa-47c7-b435-d04896853c1d')
      end

      def update_default_config
        config = default_config
        config.update_attributes!(texts: params[:texts])
        render json: {data: config}, status: :ok
      end

      def tenant_params
        params.permit(:name, :logo_url, :bank_account_number, :id, :bic_number, :iban_number, :payment_address, :currency_code, :comment)
      end

      def default_feature
        { exercise: false, documents: false, purchase: false }
      end

      def feature_params
        params.permit(feature: [:exercise, :documents, :purchase])
      end
    end
  end
end