module Api
  module V1
    class ExerciseWindowsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: tenant.exercise_windows }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'sysadmin'
        window = tenant.exercise_windows.create!(exercise_window_params)
        render json: { data: window }, status: :created
      end

      def destroy
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'sysadmin'
        window = tenant.exercise_windows.find(params[:id])
        window.destroy!
        render json: {}, status: 200
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        window = tenant.exercise_windows.find(params[:id])
        if window.present?
          window.update_attributes!(exercise_window_params)
          render json: { data: window }, status: :ok
        else
          render json: { message: "Exercise window not found" }, status: :not_found
        end
      end

      def exercise_window_params
        params.permit(:startTime, :endTime, :payment_deadline)
      end
    end
  end
end
