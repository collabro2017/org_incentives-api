describe EmailService do
  context 'Email service'

  before do
    @service = EmailService.new("api_key")
  end

  it 'formats currencies with 3 decimal places in email' do

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
