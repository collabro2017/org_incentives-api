class RemoveTenantIdFromPurchaseConfigs < ActiveRecord::Migration[5.1]
  def change
    remove_index :purchase_config, :tenant_id
    remove_column :purchase_config, :tenant_id
  end
end
