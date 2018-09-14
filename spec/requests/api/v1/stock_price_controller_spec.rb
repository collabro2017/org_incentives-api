require "spec_helper"
require 'jwt'

describe Api::V1::StockPricesController, :type => :api do
  context 'when the token is invalid'
  before do
    header "Authorization", "Bearer invalid_token"
  end
  it 'get responds with a 401 status when given a invalid token' do
    get "/api/v1/stock_prices"
    expect(last_response.status).to eq 401
  end
  it 'post responds with a 401 status when given a invalid token' do
    post "/api/v1/stock_prices"
    expect(last_response.status).to eq 401
  end
  it 'delete responds with a 401 status when given a invalid token' do
    delete "/api/v1/stock_prices/invalid_id"
    expect(last_response.status).to eq 401
  end
end

describe Api::V1::StockPricesController, :type => :api do
  context 'delete a stock price'
  before do
    header "Authorization", "Bearer #{admin_token}"
    post "/api/v1/tenants", create_tenant_body(default_tenant_id)
    @tenant_id = json['data']['id']
    @tenant = Tenant.find(@tenant_id)
    stock_price = @tenant.stock_prices.create!(price: 1.7, date: "01-01-2016", manual: false)
    @stock_price_id = stock_price.id
  end

  it 'responds with 200 status code when deleted' do
    expect(StockPrice.count).to eq 1
    delete "/api/v1/stock_prices/#{@stock_price_id}?tenantId=#{@tenant_id}"
    expect(last_response.status).to eq 200
  end

  it 'is removed from database when deleted' do
    expect(StockPrice.count).to eq 1
    delete "/api/v1/stock_prices/#{@stock_price_id}?tenantId=#{@tenant_id}"
    expect(StockPrice.count).to eq 0
  end
end

# Assure that exercising of
