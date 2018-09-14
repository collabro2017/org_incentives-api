module Api
  module V1
    class AwardsController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        if params[:sub_program_id].nil?
          user_id = TokenService.new(@token).user_id
          user_awards = AwardsService.new(tenant, user_id).user_awards
          render json: {data: user_awards.as_json(include: [
              vesting_events: {
                  include: :transactions, methods: [:exercised_quantity, :fair_value, :termination_quantity]
              },
              incentive_sub_program: {
                  include: :incentive_program
              }
          ])}, status: :ok
        else
          sub_program = tenant.incentive_sub_programs.find(params[:sub_program_id])
          render json: {data: sub_program.awards.as_json(include: [:vesting_events, :employee])}, status: :ok
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}, status: :not_found
      end

      def create
        tenant = Tenant.find(@tenant)
        sub_program = tenant.incentive_sub_programs.find(params[:incentive_sub_program_id])
        #params[:vesting_events_attributes] = params.delete(:vesting_events) if params.has_key? :vesting_events

        award = nil
        ActiveRecord::Base.transaction do
          award = sub_program.awards.create!(award_params)
          vesting_params[:vesting_events].each {|v|
            vesting_event = award.vesting_events.create!(
                grant_date: v[:grant_date],
                vestedDate: v[:vestedDate],
                expiry_date: v[:expiry_date],
                quantity: v[:quantity],
                purchase_price: v[:purchase_price],
                is_dividend: v[:is_dividend].present? ? v[:is_dividend] : false,
                strike: v[:strike]
            )
            grant_transaction = vesting_event.transactions.create!(
                transaction_type: "GRANT",
                transaction_date: v[:grant_date],
                grant_date: v[:grant_date],
                vested_date: v[:vestedDate],
                expiry_date: v[:expiry_date],
                quantity: v[:quantity],
                purchase_price: v[:purchase_price],
                strike: v[:strike]
            )
            grant_transaction.fair_value = v[:fair_value]
            grant_transaction.save!
          }
          award.save!
        end

        render json: {data: award.as_json(include: {
            vesting_events: {
                include: :transactions, methods: [:exercised_quantity, :fair_value, :termination_quantity]
            }
        })}, status: :ok
      end

      def update
        tenant = Tenant.find(@tenant)
        award = tenant.awards.find(params[:id])
        if award.nil?
          render json: {message: "Award with id '#{params[:id]}' not found"}, status: 404
        end
        ActiveRecord::Base.transaction do
          if award.update_attributes award_params
            if vesting_params[:vesting_events].present?
              award.vesting_events.destroy_all
              vesting_params[:vesting_events].each {|v|
                vesting_event = award.vesting_events.create!(
                    grant_date: v[:grant_date],
                    vestedDate: v[:vestedDate],
                    expiry_date: v[:expiry_date],
                    quantity: v[:quantity],
                    purchase_price: v[:purchase_price],
                    is_dividend: v[:is_dividend].present? ? v[:is_dividend] : false,
                    strike: v[:strike]
                )
                grant_transaction = vesting_event.transactions.create!(
                    transaction_type: "GRANT",
                    transaction_date: v[:grant_date],
                    grant_date: v[:grant_date],
                    vested_date: v[:vestedDate],
                    expiry_date: v[:expiry_date],
                    quantity: v[:quantity],
                    purchase_price: v[:purchase_price],
                    strike: v[:strike]
                )
                grant_transaction.fair_value = v[:fair_value]
                grant_transaction.save!
              }
            end

            render json: {data: award.as_json(include: {
                vesting_events: {
                    include: :transactions, methods: [:exercised_quantity, :fair_value, :termination_quantity]
                }
            })}, status: 200
          else
            render json: {}, status: 422
          end
        end
      end

      def destroy
        tenant = Tenant.find(@tenant)
        award = tenant.awards.find(params[:id])
        award.destroy!
        render json: {}, status: 200
      end

      def all_awards
        user = UserService.new(@token, @tenant)
        tenant = Tenant.find(@tenant)

        if user.is_admin
          render json: {data: tenant.awards.as_json(
              :include => {
                  :vesting_events => { :include => :transactions, methods: [:exercised_quantity, :fair_value, :termination_quantity] },
                  :incentive_sub_program => { :include => :incentive_program} ,
                  :employee => {:include => :entity}
              }
          )}, status: 200
        else
          render json: {}, status: 401
        end
      end

      def award_params
        params.permit(:quantity, :employee_id, :incentive_sub_program_id)
      end

      def vesting_params
        params.permit(:vesting_events => [:quantity, :vestedDate, :strike, :grant_date, :expiry_date, :purchase_price, :is_dividend, :fair_value])
      end
    end
  end
end
