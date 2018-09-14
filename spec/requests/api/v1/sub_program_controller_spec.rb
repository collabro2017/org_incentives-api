require "spec_helper"
require 'jwt'

describe Api::V1::SubProgramsController, :type => :api do
  context 'create sub program on an existing program'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    tenant_id = json['data']['id']
    create_entity tenant_id
    entity_id = json['data']['id']
    create_employee tenant_id, entity_id
    create_incentive_program tenant_id
    program_id = json['data']['id']

    post "/api/v1/incentive_programs/#{program_id}/sub_programs?tenantId=#{tenant_id}", {
        :name => "Sub Program",
        :instrumentTypeId => "option",
        :settlementTypeId => "equity",
        :performance => false,
        incentive_sub_program_template: {
            vesting_event_templates: [
                {
                    :grant_date => "01-01-2016",
                    :expiry_date => "01-01-2020",
                    :quantityPercentage => "0.27",
                    :strike => "1.34",
                    :vestedDate => "01-01-2017"
                }
            ]
        }
    }
  end

  it 'Responds with 201 status when given a valid sub program' do
    expect(last_response.status).to eq 201
  end

  it 'Stores the sub program to the database' do
    expect(IncentiveSubProgram.count).to eq 2
  end

end

describe Api::V1::SubProgramsController, :type => :api do
  context 'update existing sub program'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    tenant_id = json['data']['id']
    create_entity tenant_id
    entity_id = json['data']['id']
    create_employee tenant_id, entity_id
    create_incentive_program tenant_id
    program_id = json['data']['id']
    sub_program_id = json['data']['incentive_sub_programs'][0]['id']

    put "/api/v1/incentive_programs/#{program_id}/sub_programs/#{sub_program_id}?tenantId=#{tenant_id}", {
        :name => "Updated Sub Program",
        :instrumentTypeId => "rsu",
        :settlementTypeId => "equity",
        :performance => true,
        incentive_sub_program_template: {
            vesting_event_templates: [
                {
                    :grant_date => "01-01-2016",
                    :expiry_date => "01-01-2020",
                    :quantityPercentage => "0.5",
                    :strike => "1.34",
                    :vestedDate => "01-01-2017"
                },
                {
                    :grant_date => "01-01-2016",
                    :expiry_date => "01-01-2020",
                    :quantityPercentage => "0.5",
                    :strike => "1.5",
                    :vestedDate => "01-01-2017"
                }
            ]
        }
    }
  end

  it 'Responds with 200 status when given a valid update body' do
    expect(last_response.status).to eq 200
  end

  it 'Responds with body containing updated parametes' do
    expect(data['name']).to eq "Updated Sub Program"
    expect(data['instrumentTypeId']).to eq "rsu"
  end

  it 'Ensure that the update is deep' do
    template = data['incentive_sub_program_template']
    expect(template).to_not be_nil
    vet = template['vesting_event_templates']

    expect(vet[0]['quantityPercentage']).to eq "0.5"
    expect(vet[0]['strike']).to eq "1.34"
    expect(vet[1]['quantityPercentage']).to eq "0.5"
    expect(vet[1]['strike']).to eq "1.5"

    expect(vet.count).to eq 2
  end

  it 'Ensure that the database is updated' do
    expect(IncentiveSubProgram.count).to eq 1
    expect(VestingEventTemplate.count).to eq 2
    sub_program = IncentiveSubProgram.first!
    expect(sub_program.name).to eq "Updated Sub Program"
    expect(sub_program.instrumentTypeId).to eq "rsu"
    expect(sub_program.incentive_sub_program_template.vesting_event_templates.count).to eq 2
  end
end

describe Api::V1::SubProgramsController, :type => :api do
  context 'delete sub program'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    @tenant_id = json['data']['id']
    create_incentive_program @tenant_id
    @sub_program_id = json['data']['incentive_sub_programs'][0]['id']
  end

  it 'Responds with 200 status' do
    delete_sub_program @tenant_id, @sub_program_id
    expect(last_response.status).to eq 200
  end

  it 'Deletes object and depending objects from database' do
    expect(IncentiveSubProgram.count).to eq 1
    expect(IncentiveSubProgramTemplate.count).to eq 1
    expect(VestingEventTemplate.count).to eq 1
    delete_sub_program @tenant_id, @sub_program_id
    expect(IncentiveSubProgram.count).to eq 0
    expect(IncentiveSubProgramTemplate.count).to eq 0
    expect(VestingEventTemplate.count).to eq 0
  end
end

