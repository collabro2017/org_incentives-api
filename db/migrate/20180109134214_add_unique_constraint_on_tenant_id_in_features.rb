class AddUniqueConstraintOnTenantIdInFeatures < ActiveRecord::Migration[5.1]
  def change
    add_index :features, :tenant_id, :unique => true
  end
end
