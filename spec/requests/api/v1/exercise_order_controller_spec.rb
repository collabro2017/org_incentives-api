require "spec_helper"
require 'jwt'

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'when the token is invalid'
  before do
    header "Authorization", "Bearer invalid_token"
    get "/api/v1/exercise_order"
  end
  it 'responds with a 401 status when given a invalid token' do
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'create an order'
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

    @vesting_events = json['data']['vesting_events']

    create_exercise_order @tenant_id, @employee_id, @vesting_events
  end

  it 'exercise order created in the database' do
    expect(ExerciseOrder.count).to eq 1
    expect(ExerciseOrderLine.count).to eq 4
  end
end

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'list orders as admin'
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

    @vesting_events = json['data']['vesting_events']

    create_exercise_order @tenant_id, @employee_id, @vesting_events

    get_exercise_order_with_api @tenant_id, false
  end

  it 'responds with 200 status code' do
    expect(last_response.status).to eq 200
  end

  it 'exercise order created in the database' do
    data = json['data']
    expect(ExerciseOrder.count).to eq 1
    expect(data.count).to eq 1
    puts(data[0])
    expect(data[0]["employee_id"]).to eq @employee_id
    expect(data[0]["exerciseType"]).to eq "EXERCISE_AND_HOLD"
    expect(data[0]["exercise_order_lines"]).not_to be_nil
    expect(data[0]["exercise_order_lines"].count).to eq 4
    expect(data[0]["exercise_order_lines"][0]["vesting_event"]).to be_nil
  end
end

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'list orders as admin and include vesting event information'
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

    @vesting_events = json['data']['vesting_events']

    create_exercise_order @tenant_id, @employee_id, @vesting_events

    get_exercise_order_with_api @tenant_id, true
  end

  it 'responds with 200 status code' do
    expect(last_response.status).to eq 200
  end

  it 'exercise order created in the database' do
    data = json['data']
    expect(ExerciseOrder.count).to eq 1
    expect(data.count).to eq 1
    puts(data[0])
    expect(data[0]["employee_id"]).to eq @employee_id
    expect(data[0]["exerciseType"]).to eq "EXERCISE_AND_HOLD"
    expect(data[0]["exercise_order_lines"]).not_to be_nil
    expect(data[0]["exercise_order_lines"].count).to eq 4
    expect(data[0]["exercise_order_lines"][0]["vesting_event"]).not_to be_nil
  end
end


# Assure that exercising increases the exercised quantity in vesting events by correct amount
# Assure that exercising reduces the quantity in vesting events by correct amount
# Delete of an order should reverse the exercised quantity and quantity in vesting event by correct amount
