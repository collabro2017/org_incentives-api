require "spec_helper"
require 'jwt'

describe Api::V1::IncentiveProgramsController, :type => :api do
  context 'when the token is invalid'
  before do
    header "Authorization", "Bearer invalid_token"
  end

  it 'GET responds with a 401 status when given a invalid token' do
    get "/api/v1/incentive_programs"
    expect(last_response.status).to eq 401
  end

  it 'POST responds with a 401 status when given a invalid token' do
    post "/api/v1/incentive_programs"
    expect(last_response.status).to eq 401
  end

  it 'PUT responds with a 401 status when given a invalid token' do
    id = "id"
    put "/api/v1/incentive_programs/#{id}"
    expect(last_response.status).to eq 401
  end

  it 'DELETE responds with a 401 status when given a invalid token' do
    id = "id"
    delete "/api/v1/incentive_programs/#{id}"
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::IncentiveProgramsController, :type => :api do
  context 'create incentive programs'

  before do
    header "Authorization", "Bearer #{admin_token}"
  end

  it 'POST responds with 201 status when given a valid incentive program' do
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    tenant_id = json['data']['id']
    #create_entity tenant_id
    #entity_id = json['data']['id']
    #create_employee tenant_id, entity_id

    create_incentive_program tenant_id
    expect(last_response.status).to eq 201
  end

end

describe Api::V1::IncentiveProgramsController, :type => :api do
  context 'update incentive programs'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    @tenant_id = json['data']['id']
    create_incentive_program @tenant_id
    @program_id = json['data']['id']
    update_incentive_program @tenant_id, @program_id, {
        :name => "Updated Incentive Program",
        :startDate => "01-01-2021",
        :endDate => "01-01-2021",
        :capacity => 10,
    }
  end

  it 'Responds with 200' do
    expect(last_response.status).to eq 200
  end
  it 'Updates object in database' do
    program = IncentiveProgram.find(@program_id)
    expect(program.name).to eq "Updated Incentive Program"
    expect(program.startDate).to eq Date.parse("01-01-2021")
    expect(program.endDate).to eq Date.parse("01-01-2021")
    expect(program.capacity).to eq 10
  end
end


describe Api::V1::IncentiveProgramsController, :type => :api do
  context 'delete incentive programs'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    @tenant_id = json['data']['id']
    create_incentive_program @tenant_id
    @program_id = json['data']['id']
  end

  it 'Responds with 200' do
    delete_incentive_program @tenant_id, @program_id
    expect(last_response.status).to eq 200
  end
  it 'Deletes objects and dependent objects from database' do
    expect(IncentiveProgram.count).to eq 1
    expect(IncentiveSubProgram.count).to eq 1
    expect(IncentiveSubProgramTemplate.count).to eq 1
    expect(VestingEventTemplate.count).to eq 1
    delete_incentive_program @tenant_id, @program_id
    expect(IncentiveProgram.count).to eq 0
    expect(IncentiveSubProgram.count).to eq 0
    expect(IncentiveSubProgramTemplate.count).to eq 0
    expect(VestingEventTemplate.count).to eq 0
  end

end

