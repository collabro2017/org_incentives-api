module Api
  module V1
    class DividendsController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        render json: { data: tenant.dividends }, status: :ok
      end

      def create
        tenant = Tenant.find(@tenant)
        created_dividend = nil
        ActiveRecord::Base.transaction do
          created_dividend = tenant.dividends.create!(dividends_params)
          transactions_params[:dividend_transactions].each { |tp|
            sub_program = tenant.incentive_sub_programs.find(tp[:sub_program_id])
            dividend_per_share = dividends_params[:dividend_per_share].to_f
            if tp[:dividend_transaction_type] === "STRIKE_ADJUSTMENT"
              vesting_events = sub_program.vesting_events
              vesting_events.select { |ve| ve.vested_date.future? }.each { |ve|
                adjusted_strike = ve.strike - dividend_per_share
                ve.transactions.create!(
                    transaction_type: "ADJUSTMENT_DIVIDEND",
                    transaction_date: dividends_params[:dividend_date], strike: [adjusted_strike, 0].max)
              }
            elsif tp[:dividend_transaction_type] === "GENERATE_DIVIDEND_INSTRUMENTS"
              vesting_events = sub_program.vesting_events
              vesting_events.select { |ve| ve.vested_date.future? && !ve.is_dividend }.each { |ve|
                dividend_instrument = ve.dup
                share_price_at_dividend_date = params[:share_price_at_dividend_date]
                quantity = dividend_instrument_quantity(ve, share_price_at_dividend_date.to_f, dividend_per_share.to_f)
                dividend_instrument.quantity = quantity
                dividend_instrument.is_dividend = true
                dividend_instrument.dividend_source_vesting_event_id = ve.id
                dividend_instrument.save!
                dividend_instrument.transactions.create!(
                    transaction_type: "GRANT",
                    transaction_date: ve.grant_date,
                    grant_date: ve.grant_date,
                    vested_date: ve.vestedDate,
                    expiry_date: ve.expiry_date,
                    quantity: quantity,
                    purchase_price: ve.purchase_price,
                    strike: ve.strike
                )
              }
            else
              raise StandardError "Dividend transaction type #{tp[:dividend_transaction_type]} does not match any of the known types."
            end
          }
        end
        render json: { data: created_dividend }, status: :ok
      end

      def dividend_instrument_quantity(existing_vesting_event, share_price_at_dividend_date, dividend_per_share)
        existing_quantity = existing_vesting_event.quantity + existing_vesting_event.dividend_vesting_events.map {|x| x.quantity}.sum
        puts "Existing quantity: #{existing_quantity}"
        number_of_dividend_instruments = ((dividend_per_share / share_price_at_dividend_date)  * existing_quantity).floor
        puts "Number of dividend instruments: #{number_of_dividend_instruments}"
        number_of_dividend_instruments
      end

      def share_price_at_date

      end

      def dividends_params
        params.permit(:dividend_date, :dividend_per_share)
      end

      def transactions_params
        params.permit(dividend_transactions: [:sub_program_id, :dividend_transaction_type])
      end
    end
  end
end
