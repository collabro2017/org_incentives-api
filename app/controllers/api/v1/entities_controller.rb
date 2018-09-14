module Api
  module V1
    class EntitiesController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: tenant.entities }, status: :ok
      end

      def show
        tenant = Tenant.find(@tenant)
        entities = tenant.entities.find(params[:id])
        render json: { data: entities }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        entity = tenant.entities.create!(entity_params)

        render json: { data: entity }, status: :created
      end

      def update
        tenant = Tenant.find(@tenant)
        entity = tenant.entities.find(params[:id])
        if entity.present?
          entity.update_attributes(entity_params)
          render json: { data: entity }, status: :ok
        else
          render json: { message: "Entity not found" }, status: :not_found
        end
      end

      def destroy
        tenant = Tenant.find(@tenant)
        entity = tenant.entities.find(params[:id])
        entity.destroy!
        render json: {}, status: 200
      end

      def entity_params
        params.permit(:name, :identification, :countryCode, :soc_sec)
      end
    end
  end
end