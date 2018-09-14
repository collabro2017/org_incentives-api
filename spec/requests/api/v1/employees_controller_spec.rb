require "spec_helper"
require 'jwt'

describe Api::V1::EmployeesController, :type => :api do
  context 'when the token is invalid'
  before do
    token = 'invalid_token'
    header "Authorization", "Bearer #{token}"
    get "/api/v1/employees"
  end
  it 'responds with a 401 status when given a invalid token' do
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::EmployeesController, :type => :api do
  context 'create when the token is valid'
  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    tenant_id = json['data']['id']
    create_entity tenant_id
    entity_id = json['data']['id']
    create_employee tenant_id, entity_id
  end
  it 'responds 201 status when given a valid employee body' do
    expect(last_response.status).to eq 201
  end
end

describe Api::V1::EmployeesController, :type => :api do
  context 'delete'
  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    @tenant_id = json['data']['id']
    create_entity @tenant_id
    entity_id = json['data']['id']
    create_employee @tenant_id, entity_id
    @employee_id = json['data']['id']
    create_incentive_program @tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
    create_award @tenant_id, @sub_program_id, @employee_id
  end

  it 'responds 200 status' do
    delete_employee @tenant_id, @employee_id
    expect(last_response.status).to eq 200
  end

  it 'employee deleted from database' do
    expect(Employee.count).to eq 1
    delete_employee @tenant_id, @employee_id
    expect(Employee.count).to eq 0
  end

  it 'employees awards deleted from database' do
    expect(Award.count).to eq 1
    delete_employee @tenant_id, @employee_id
    expect(Award.count).to eq 0
  end
end
