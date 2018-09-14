require "spec_helper"
require 'jwt'

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'when the token is invalid'
  before do
    token = 'invalid_token'
    header "Authorization", "Bearer #{token}"
    get "/api/v1/exercise_order"
  end
  it 'responds with a 401 status when given a invalid token' do
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::ExerciseOrderController, :type => :api do
  context 'PUT when the token is valid'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    tenant_id = json['data']['id']
    create_entity tenant_id
    entity_id = json['data']['id']
    create_employee tenant_id, entity_id
    employee_id = json['data']['id']
    order_id = create_exercise_order tenant_id, employee_id
    update_exercise_order tenant_id, order_id, { :status => "CANCELLED" }
  end

  it 'responds with status code 200 when updating status' do
    expect(last_response.status).to eq 200
  end

  it 'responds with status changed to CANCELLED' do
    data = json['data']
    expect(data['status']).to eq 'CANCELLED'
  end
end
