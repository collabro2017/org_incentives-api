class DeleteConfigsForTenants < ActiveRecord::Migration[5.1]
  def change
    drop_table :configs_for_tenants
  end
end
