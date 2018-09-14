require "spec_helper"
require 'jwt'
require 'securerandom'

describe Api::V1::AwardsController, :type => :api do
  context 'when the token is invalid'
  before do
    header "Authorization", "Bearer invalid_token"
  end

  it 'GET responds with a 401 status when given a invalid token' do
    get "/api/v1/awards"
    expect(last_response.status).to eq 401
  end

  it 'POST responds with a 401 status when given a invalid token' do
    post "/api/v1/awards"
    expect(last_response.status).to eq 401
  end

  it 'PUT responds with a 401 status when given a invalid token' do
    id = "id"
    put "/api/v1/awards/#{id}"
    expect(last_response.status).to eq 401
  end

  it 'DELETE responds with a 401 status when given a invalid token' do
    id = "id"
    delete "/api/v1/awards/#{id}"
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::AwardsController, :type => :api do
  context 'creating an award'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    tenant_id = json['data']['id']
    create_entity tenant_id
    entity_id = json['data']['id']
    create_employee tenant_id, entity_id
    @employee_id = json['data']['id']
    create_incentive_program tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
    create_award tenant_id, @sub_program_id, @employee_id
  end

  it 'responds with a 200 status when given a valid body' do
    expect(last_response.status).to eq 200
  end

  it 'body should include the created resource' do
    expect(data['id']).to_not be_nil
    expect(data['incentive_sub_program_id']).to eq @sub_program_id
    expect(data['employee_id']).to eq @employee_id
  end

  it 'should be saved to the database' do
    award_id = data['id']
    award = Award.find(award_id)
    expect(award).to_not be_nil
    expect(award.incentive_sub_program.id).to eq @sub_program_id
    expect(award.employee.id).to eq @employee_id
  end
end


describe Api::V1::AwardsController, :type => :api do
  context 'updating an award'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    @tenant_id = json['data']['id']
    create_entity @tenant_id
    entity_id = json['data']['id']
    create_employee @tenant_id, entity_id
    @employee_id = json['data']['id']
    create_incentive_program @tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
    create_award @tenant_id, @sub_program_id, @employee_id
    @award_id = data['id']
  end

  it 'PUT updates quantity' do
    update_award @tenant_id, @award_id, {
        :quantity => 1000
    }
    expect(last_response.status).to eq 200
    expect(data["quantity"]).to eq 1000
  end

  it 'PUT updates vesting events' do
    expect(VestingEvent.count).to eq 4
    update_award @tenant_id, @award_id, {
        :quantity => 1000,
        :vesting_events => [
            {
                :grant_date => "01.01.2016",
                :vestedDate => "01.01.2017",
                :expiry_date => "01.01.2020",
                :strike => 1.0,
                :quantity => 270
            },
            {
                :grant_date => "01.01.2016",
                :vestedDate => "01.01.2017",
                :expiry_date => "01.01.2020",
                :strike => 1.15,
                :quantity => 270
            },
            {
                :grant_date => "01.01.2016",
                :vestedDate => "01.01.2018",
                :expiry_date => "01.01.2020",
                :strike => 1.25,
                :quantity => 270
            },
            {
                :grant_date => "01.01.2016",
                :vestedDate => "01.01.2019",
                :expiry_date => "01.01.2020",
                :strike => 1.30,
                :quantity => 190
            }

        ]
    }
    expect(last_response.status).to eq 200
    expect(data["quantity"]).to eq 1000
    vesting_events = data["vesting_events"]
    expect(vesting_events).to_not be_nil
    expect(vesting_events[0]["quantity"]).to eq 270
    expect(vesting_events[1]["quantity"]).to eq 270
    expect(vesting_events[2]["quantity"]).to eq 270
    expect(vesting_events[3]["quantity"]).to eq 190
    expect(VestingEvent.count).to eq 4
  end
end

describe Api::V1::AwardsController, :type => :api do
  context 'deleting an award'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    @tenant_id = json['data']['id']
    create_entity @tenant_id
    entity_id = json['data']['id']
    create_employee @tenant_id, entity_id
    @employee_id = json['data']['id']
    create_incentive_program @tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
    create_award @tenant_id, @sub_program_id, @employee_id
    @award_id = data['id']
  end

  it 'Responds with status 200' do
    delete_award @tenant_id, @award_id
    expect(last_response.status).to eq 200
  end

  it 'Deletes object and depending objects from database' do
    expect(Award.count).to eq 1
    expect(VestingEvent.count).to eq 4
    delete_award @tenant_id, @award_id
    expect(Award.count).to eq 0
    expect(VestingEvent.count).to eq 0
  end
end

describe Api::V1::AwardsController, :type => :api do
  context 'list all the awards of one tenant'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    @tenant_id = json['data']['id']
    create_entity @tenant_id
    entity_id = json['data']['id']
    create_employee @tenant_id, entity_id
    @employee_id = json['data']['id']
    create_incentive_program @tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
    create_award @tenant_id, @sub_program_id, @employee_id
    @award_id = data['id']
  end

  it 'Responds with status 200' do
    get_all_awards @tenant_id
    expect(last_response.status).to eq 200
  end
end

