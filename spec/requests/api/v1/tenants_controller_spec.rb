require "spec_helper"
require 'jwt'

def fetch_access_token
  uri = URI("#{Rails.application.secrets.auth0_management_api_origin}/oauth/token")
  res = Net::HTTP.post(uri, {
      "grant_type" => "client_credentials",
      "client_id" => Rails.application.secrets.auth0_management_api_client_id,
      "client_secret" => Rails.application.secrets.auth0_management_api_client_secret,
      "audience" => Rails.application.secrets.auth0_management_api_audience
  }.to_json, { 'Content-Type' =>'application/json'})

  body = JSON.parse(res.body)
  body['access_token']
end

describe Api::V1::TenantsController, :type => :api do
  context 'get when the token is invalid'
  before do
    header "Authorization", "Bearer invalid_token"
    get "/api/v1/tenants"
  end
  it 'responds with a 401 status when given an invalid token' do
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'get when the token is valid'
  before do
    header "Authorization", "Bearer #{admin_token}"
    get "/api/v1/tenants"
  end

  it 'responds with a 200 status when given a valid token' do
    expect(last_response.status).to eq 200
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'create tenant'
  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
  end

  it 'responds with a 201 status when a tenant is created' do
    expect(last_response.status).to eq 201
  end

  it 'responds with the created tenant ' do
    body = JSON.parse(last_response.body)
    data = body['data']
    expect(data['name']).to eq "Tenant"
    expect(data['id']).to eq default_tenant_id
    expect(data['bank_account_number']).to eq '123456789123'
    expect(data['bic_number']).to eq '123456789'
    expect(data['iban_number']).to eq '123456789'
    expect(data['logo_url']).to eq "https://www.logo.url/logo.png"
    expect(data['feature']['exercise']).to eq true
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'create tenant without tenant id'
  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(nil)
  end

  it 'responds with a 201 status when a tenant is created' do
    expect(last_response.status).to eq 201
  end

  it 'responds with the created tenant ' do
    body = JSON.parse(last_response.body)
    data = body['data']
    expect(data['name']).to eq "Tenant"
    expect(data['id']).not_to eq default_tenant_id
    expect(data['logo_url']).to eq "https://www.logo.url/logo.png"
    expect(data['feature']['exercise']).to eq true
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'create tenant without including feature object'

  it 'responds with the default feature object' do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body_without_feature(nil)

    data = json['data']
    expect(data['feature']).to_not be_nil
    expect(data['feature']['exercise']).to eq false
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'delete tenant'

  it 'deletes tenant from the database' do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    expect(Tenant.count).to eq 1
    delete "/api/v1/tenants/#{default_tenant_id}"
    expect(last_response.status).to eq 200
    expect(Tenant.count).to eq 0
  end

  it 'deletes tenant and dependent entities from the database' do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    create_entity default_tenant_id

    expect(Tenant.count).to eq 1
    expect(Entity.count).to eq 1

    delete "/api/v1/tenants/#{default_tenant_id}"

    expect(Tenant.count).to eq 0
    expect(Entity.count).to eq 0
  end
end

describe Api::V1::TenantsController, :type => :api do
  context 'update tenant'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    put "/api/v1/tenants/#{default_tenant_id}", {
        :name => 'Et annet navn',
        :bic_number => '333333333',
        :iban_number => '444444444',
        :bank_account_number => '999999999',
        :logo_url => 'https://www.logo.url/en_annen_logo.png'
    }
  end

  it 'updates the tenant in the database' do
    expect(last_response.status).to eq 200
    tenant = Tenant.first!
    expect(tenant.name).to eq 'Et annet navn'
    expect(tenant.bic_number).to eq '333333333'
    expect(tenant.iban_number).to eq '444444444'
    expect(tenant.bank_account_number).to eq '999999999'
    expect(tenant.logo_url).to eq 'https://www.logo.url/en_annen_logo.png'
  end

  it 'updates tenant and responds with the updated tenant' do
    data = json['data']
    expect(data['name']).to eq 'Et annet navn'
    expect(data['bic_number']).to eq '333333333'
    expect(data['iban_number']).to eq '444444444'
    expect(data['bank_account_number']).to eq '999999999'
    expect(data['logo_url']).to eq 'https://www.logo.url/en_annen_logo.png'
  end
end



describe Api::V1::TenantsController, :type => :api do
  context 'update config for tenant'

  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
  end

  it 'first update creates a new config object' do
    put "/api/v1/tenants/#{default_tenant_id}/update_config", {
        :texts => {
            "abc.test": "En tekst"
        }
    }

    expect(last_response.status).to eq 201

    db_tenant = Tenant.find(default_tenant_id)
    expect(db_tenant.config).not_to be_nil
    expect(db_tenant.config.texts).not_to be_nil
    expect(db_tenant.config.texts["abc.test"]).to eq "En tekst"
  end

  it 'second update will update the existing config' do
    put "/api/v1/tenants/#{default_tenant_id}/update_config", {
        :texts => {
            "abc.test": "En tekst"
        }
    }

    expect(last_response.status).to eq 201

    put "/api/v1/tenants/#{default_tenant_id}/update_config", {
        :texts => {
            "abc.test" => "En annen tekst"
        }
    }

    expect(last_response.status).to eq 200

    db_tenant = Tenant.find(default_tenant_id)
    expect(db_tenant.config).not_to be_nil
    expect(db_tenant.config.texts).not_to be_nil
    expect(db_tenant.config.texts["abc.test"]).to eq "En annen tekst"
  end

end

# Put for updating tenant should update both tenant and feature object (if present)
# Normal delete
# Deep delete


