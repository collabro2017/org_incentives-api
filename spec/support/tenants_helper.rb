module TenantsHelper
  def default_tenant_id
    '344437fa-6bbc-4744-9aa7-633e2ea61c8f'
  end

  def create_tenant_body id
    {
        :name => "Tenant",
        :id => id,
        :logo_url => "https://www.logo.url/logo.png",
        :bank_account_number => "123456789123",
        :bic_number => "123456789",
        :iban_number => "123456789",
        :feature => { "exercise": true }
    }
  end

  def create_tenant_body_without_feature id
    {
        :name => "Tenant",
        :id => id,
        :logo_url => "https://www.logo.url/logo.png"
    }
  end

  def create_tenant(id = default_tenant_id)
    post "/api/v1/tenants", create_tenant_body(id)
  end
end