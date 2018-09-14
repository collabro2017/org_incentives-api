require "spec_helper"
require 'jwt'

describe Api::V1::ExerciseWindowsController, :type => :api do
  context 'when the token is invalid'
  before do
    token = 'invalid_token'
    header "Authorization", "Bearer #{token}"
    get "/api/v1/exercise_windows"
  end
  it 'responds with a 401 status when given a invalid token' do
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::ExerciseWindowsController, :type => :api do
  context 'create when the token is valid'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    @tenant_id = json['data']['id']
    create_exercise_window_with_api @tenant_id
  end

  it 'responds with status code 201 when updating status' do
    expect(last_response.status).to eq 201
  end

  it 'responds with the created exercise window' do
    data = json['data']
    expect(data['startTime']).to eq '2016-01-01T00:00:00.000Z'
    expect(data['endTime']).to eq '2018-01-01T00:00:00.000Z'
  end

  it 'exercise window is stored to the database' do
    w = ExerciseWindow.first!
    expect(w.startTime).to eq '2016-01-01T00:00:00.000Z'
    expect(w.endTime).to eq '2018-01-01T00:00:00.000Z'
  end
end

describe Api::V1::ExerciseWindowsController, :type => :api do
  context 'delete when the token is valid'
  before do
    header "Authorization", "Bearer #{admin_token}"
    create_tenant
    tenant_id = json['data']['id']

    create_exercise_window_with_api tenant_id
    exercise_window_id = json['data']['id']

    delete_exercise_window_with_api tenant_id, exercise_window_id
  end

  it 'responds with status code 200 when deleted' do
    expect(last_response.status).to eq 200
  end

  it 'deletes the exercise window from the database' do
    expect(ExerciseWindow.count).to eq 0
  end
end
