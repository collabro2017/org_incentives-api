module EmployeeHelper
  def create_employee_body entity_id
    {
        "firstName": "Aleksander",
        "lastName": "Hindenes 2",
        "email": "aleksander.hindenes+4@gmail.com",
        "residence": "no",
        "insider": true,
        "entity_id": entity_id
    }
  end
  def create_employee tenant_id, entity_id
    post "/api/v1/employees?tenantId=#{tenant_id}", create_employee_body(entity_id)
  end

  def delete_employee tenant_id, employee_id
    delete "/api/v1/employees/#{employee_id}?tenantId=#{tenant_id}"
  end
end