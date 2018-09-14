require "google/cloud/storage"

module Api
  module V1
    class EmployeeDocumentsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        employee = UserService.new(@token, tenant).employee
        render json: { data: employee.employee_documents }, status: :ok
      end

      def create
        TokenService.new(@token).require_role 'sysadmin'
        employee_document = EmployeeDocument.create!(employee_documents_params)
        render json: { data: employee_document.as_json(:include => :document) }, status: :ok
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        employee_document = EmployeeDocument.find(params[:id])
        employee_document.update_attributes!(update_params)
        render json: { data: employee_document.as_json(:include => :document) }, status: :ok
      end

      def destroy
        TokenService.new(@token).require_role 'sysadmin'
        employee_document = EmployeeDocument.find(params[:id])
        employee_document.destroy!
        render json: {}, status: :ok
      end

      # POST endpoint for employees to mark documents as read
      # Document Id refers to the id of the document db entry, not the employee document entry
      def read
        puts params
        document_id = params[:id]
        tenant = Tenant.find(@tenant)
        employee = UserService.new(@token, tenant).employee
        employee_document = employee.employee_documents.where(document_id: document_id).first!
        accepted_at = DateTime.now

        employee_document.is_read_and_accepted = true
        employee_document.requires_acceptance = false
        employee_document.accepted_at = accepted_at

        employee_document.save!

        render json: { accepted_at: accepted_at }, status: :ok
      end

      def employee_documents_params
        params.permit(:document_id, :employee_id, :requires_acceptance, :is_read_and_accepted, :message_header, :message_body)
      end

      def update_params
        params.permit(:requires_acceptance, :accepted_at, :message_header, :message_body)
      end
    end
  end
end
