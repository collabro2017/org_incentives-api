module Api
  module V1
    class StockPricesController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: tenant.stock_prices.order('date DESC, created_at DESC').limit(20) }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        stock_price = tenant.stock_prices.create!(stock_prices_params)
        render json: { data: stock_price }, status: :created
      end

      def destroy
        tenant = Tenant.find(@tenant)
        stock_price = tenant.stock_prices.find(params[:id])
        stock_price.destroy!
        render json: {}, status: :ok
      end

      def stock_prices_params
        params.permit(:price, :date, :manual, :message)
      end
    end
  end
end
