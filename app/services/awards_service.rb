class AwardsService
  def initialize(tenant, user_id)
    @tenant = tenant
    @user_id = user_id
  end

  def user_awards
    employee = @tenant.employees.find_by! account_id: @user_id
    @tenant.awards.where(employee_id: employee.id).find_each
  end
end