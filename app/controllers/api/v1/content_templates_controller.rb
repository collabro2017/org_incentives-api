module Api
  module V1
    class ContentTemplatesController < ApplicationController
      include SecuredAdmin

      def index
        contents = ContentTemplate.where(:tenant_id => [@tenant, nil])
        render json: { data: contents }
      end

      def create

      end

      def update
        content = ContentTemplate.find(params[:id])
        content.update_attributes!(content_params)
        render json: { data: content }
      end

      def content_params
        params.permit(:raw_content, :content_type, :template_type, :tenant_id)
      end
    end
  end
end
