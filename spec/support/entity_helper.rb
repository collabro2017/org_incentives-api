module EntityHelper
  def create_entity_body
    {
        :name => 'Entity',
        :identification => '123456789',
        :countryCode => 'no'
    }
  end
  def create_entity tenant_id
    post "/api/v1/entities?tenantId=#{tenant_id}", create_entity_body
  end

  def delete_entity(tenant_id, entity_id)
    delete "/api/v1/entities/#{entity_id}?tenantId=#{tenant_id}"
  end
end