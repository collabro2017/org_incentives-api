module Api
  module V1
    class IncentiveProgramsController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        programsJson = tenant.incentive_programs.all.map { | p | p.include_everything_json }
        render json: { data: programsJson }, status: :ok
      end
      def create
        tenant = Tenant.find(@tenant)
        p = tenant.incentive_programs.create!(program_params)
        sub_program_params[:incentive_sub_programs].each { | sub_program |
          puts sub_program
          puts sub_program[:performance]
          sub_program_template = sub_program[:incentive_sub_program_template]
          sub_p = p.incentive_sub_programs.create!(
              name: sub_program[:name],
              instrumentTypeId: sub_program[:instrumentTypeId],
              performance: sub_program[:performance],
              settlementTypeId: sub_program[:settlementTypeId]
          )
          sub_p.incentive_sub_program_template = IncentiveSubProgramTemplate.create()
          sub_program_template[:vesting_event_templates].each { |v|
            sub_p.incentive_sub_program_template.vesting_event_templates.new(v)
          }
          sub_p.incentive_sub_program_template.save!
        }

        if p.save
          render json: { data: p.include_everything_json }, status: :created
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      def update
        tenant = Tenant.find(@tenant)
        program = tenant.incentive_programs.find(params[:id])

        if program.nil?
          render json: {message: "Program with id '#{params[:id]}' not found"}, status: 404
        end

        program.update_attributes! program_params
        render json: {data: program}, status: 200
      end

      def destroy
        tenant = Tenant.find(@tenant)
        program = tenant.incentive_programs.find(params[:id])
        program.destroy!
        render json: {}, status: 200
      end

      def program_params
        params.permit(:name, :startDate, :endDate, :capacity)
      end

      def sub_program_params
        params.permit(incentive_sub_programs: [ :name, :instrumentTypeId, :settlementTypeId, :performance, incentive_sub_program_template: [vesting_event_templates: [:grant_date, :expiry_date, :quantityPercentage, :strike, :vestedDate, :purchase_price]] ])
      end
    end
  end
end