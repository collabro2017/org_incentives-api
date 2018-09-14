require 'net/http'

module Api
  module V1
    class FeaturesController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        feature = tenant.feature
        if feature.nil?
          render json: { error: "Not features found for tenant id #{@tenant}" }, status: :not_found
        else
          render json: {data: feature}, status: :ok
        end
      end

      def create
        tenant = Tenant.find(@tenant)

        if tenant.feature.nil?
          tenant.feature = Feature.new(features_params)
          if tenant.feature.save!
            render json: {features: tenant.feature}, status: :created
          else
            render json: {error: true}, status: :unprocessable_entity
          end
        else
          render json: {error: "Tenant #{@tenant} already has a feature object"}, status: :bad_request
        end
      end

      def features_params
        params.permit(:exercise, :documents, :purchase)
      end
    end
  end
end