module Api
  module V1
    class CountriesController < ApplicationController
      def index
        countries = Country.all
        render json: { data: countries }, status: :ok
      end
    end
  end
end