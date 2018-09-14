module Api
  module V1
    class ConfigsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: { tenant: config_for_tenant(tenant), default: default_config } }
      end

      def texts_for_tenant(tenant)
        if tenant.config.present? && tenant.config.texts.present?
          tenant.config.texts
        else
          {}
        end
      end

      def config_for_tenant(tenant)
        if tenant.config.present?
          tenant.config
        else
          nil
        end
      end

      def default_config
        Config.find('71184113-81aa-47c7-b435-d04896853c1d')
      end


    end
  end
end
