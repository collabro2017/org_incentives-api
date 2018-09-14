class RoleMissingError < StandardError
end

class UserService
  def initialize(token, tenant)
    @token = token
    @tenant = tenant
    @app_metadata = @token["#{AUTH0_NAMESPACE}app_metadata"]
  end

  def user_id
    @token[:sub].split('|').last
  end

  def require_role(role)
    raise RoleMissingError unless @app_metadata[:roles].include? role
  end

  def is_admin
    @app_metadata[:roles].include? "admin" or @app_metadata[:roles].include? "sysadmin"
  end

  def employee
    @tenant.employees.find_by! account_id: user_id
  end

  def user_awards
    @tenant.awards.where(employee_id: employee.id).find_each
  end

  def user_orders
    @tenant.exercise_orders.where(employee_id: employee.id).find_each
  end

  def user_windows
    employee_id = self.employee.id
    @tenant.windows
        .where("end_time > ?", DateTime.now)
        .find_each
        .select { |w| w.is_employee_eligable(employee_id) }
  end
end