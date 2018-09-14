module Api
  module V1
    class SubProgramsController < ApplicationController
      include SecuredAdmin

      def index
        tenant = Tenant.find(@tenant)
        incentive_program = tenant.incentive_programs.find(params[:incentive_program_id])
        render json: {data: incentive_program.incentive_sub_programs}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}, status: :not_found
      end

      def create
        tenant = Tenant.find(@tenant)
        p = tenant.incentive_programs.find(params[:incentive_program_id])
        sub_program = p.incentive_sub_programs.create!(sub_program_params)
        sub_program.incentive_sub_program_template = IncentiveSubProgramTemplate.create
        sub_program_template_params_with_vesting[:incentive_sub_program_template][:vesting_event_templates].each {|v|
          sub_program.incentive_sub_program_template.vesting_event_templates.new(v)
        }
        sub_program.incentive_sub_program_template.save!
        if sub_program.save
          render json: {data: sub_program}, status: :created
        else
          render json: {}, status: :unprocessable_entity
        end
      end

      def update
        tenant = Tenant.find(@tenant)
        p = tenant.incentive_programs.find(params[:incentive_program_id])
        sub_program = p.incentive_sub_programs.find(params[:id])

        if sub_program.present?
          ActiveRecord::Base.transaction do
            sub_program.update_attributes! sub_program_params
            template = sub_program_template_params_with_vesting[:incentive_sub_program_template]
            if template.present? && template[:vesting_event_templates].present?
              vets = template[:vesting_event_templates]
              sub_program.incentive_sub_program_template.vesting_event_templates.destroy_all
              vets.each {|v|
                sub_program.incentive_sub_program_template.vesting_event_templates.create!(v)
              }
            end

            render json: { data: sub_program }, status: :ok
          end
        end
      end

      def destroy
        tenant = Tenant.find(@tenant)
        sub_program = tenant.incentive_sub_programs.find(params[:id])
        sub_program.destroy!
        render json: {}, status: 200
      end

      def sub_program_params
        params.permit(:name, :instrumentTypeId, :settlementTypeId, :performance)
      end

      def sub_program_template_params_with_vesting
        params.permit(incentive_sub_program_template: [vesting_event_templates: [:grant_date, :expiry_date, :quantityPercentage, :strike, :vestedDate, :purchase_price]])
      end

    end
  end
end
