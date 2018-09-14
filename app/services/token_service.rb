class RoleMissingError < StandardError
end

class TokenService
  def initialize(token)
    @token = token
  end

  def user_id
    @token[:sub].split('|').last
  end

  def app_metadata
    @token["#{AUTH0_NAMESPACE}app_metadata"]
  end

  def require_role(role)
    raise RoleMissingError unless app_metadata[:roles].include? role
  end
end