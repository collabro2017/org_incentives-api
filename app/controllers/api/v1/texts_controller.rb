module Api
  module V1
    class TextsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: texts_for_tenant(tenant) }
      end

      def create

      end

      def texts_for_tenant(tenant)
        default_texts = Config.find('71184113-81aa-47c7-b435-d04896853c1d').texts
        if tenant.config.present? && tenant.config.texts.present?
          default_texts.merge tenant.config.texts
        else
          {}
        end
      end
    end
  end
end
