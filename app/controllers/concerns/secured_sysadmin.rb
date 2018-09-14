# frozen_string_literal: true
class RoleMissingError < StandardError
end

module SecuredSysadmin
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    token_body = auth_token[0]
    hash = HashWithIndifferentAccess.new token_body
    unless hash["#{AUTH0_NAMESPACE}app_metadata"][:roles].include? 'sysadmin'
      raise RoleMissingError
    end
  rescue JWT::VerificationError, JWT::DecodeError
    render json: {errors: ['Not Authenticated']}, status: :unauthorized
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
