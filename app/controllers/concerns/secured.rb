# frozen_string_literal: true
class TenantIdMissingError < StandardError
end

module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :tenant
    attr_reader :token
  end

  private

  def authenticate_request!
    token_body = auth_token[0]
    @token = HashWithIndifferentAccess.new token_body
    @tenants = @token["#{AUTH0_NAMESPACE}app_metadata"][:tenants]
    puts @tenants
    if @tenants.include? '*'
      @tenant = request[:tenantId]
    elsif @tenants.size == 1
      @tenant = @tenants[0]
    else
      if @tenants.include? request[:tenantId]
        @tenant = request[:tenantId]
      else
        raise TenantIdMissingError
      end
    end

  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized

  rescue TenantIdMissingError
    render json: { errors: ['Parameter "tenantId" missing'] }, status: :unauthorized

  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    JsonWebToken.verify(http_token)
  end
end