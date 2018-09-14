require "google/cloud/storage"

#
# Resource for the employee portal users.
# The Documents here are a convenience mapping from the database relationship between EmployeeDocument and Document models.
#

module Api
  module V1
    class DocumentsController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'user'
        user_id = token.user_id
        doc_service = DocumentService.new(tenant, user_id)
        documents = doc_service.documents_for_employee

        render json: { data: documents }, status: :ok
      end

      def show
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'user'
        user_id = token.user_id
        doc_service = DocumentService.new(tenant, user_id)

        document_id = params[:id]
        employee = UserService.new(@token, tenant).employee

        if employee.employee_documents.exists?(document_id: document_id) || employee.purchase_opportunities.exists?(document_id: document_id)
          render json: { data: doc_service.info_and_download_link_for_document(document_id) }, status: :ok
        else
          render json: { error: "Could not find document with id='#{document_id}'" }, status: :not_found
        end
      end

      def update
        TokenService.new(@token).require_role 'sysadmin'
        document = Document.find(params[:id])
        document.update_attributes!(update_params)
        render json: { data: document }, status: :ok
      end

      def destroy
        token_service = TokenService.new(@token)
        token_service.require_role 'sysadmin'
        tenant = Tenant.find(@tenant)
        user_id = token_service.user_id
        doc_service = DocumentService.new(tenant, user_id)

        if doc_service.delete_document(params[:id])
          render json: {}, status: :ok
        else
          render json: { error: "Something wrong happened when trying to delete file." }, status: :internal_server_error
        end
      end

      def update_params
        params.permit(:document_header, :message_header, :message_body)
      end
    end
  end
end
