class AddIndexOnTenantIdOnEmployees < ActiveRecord::Migration[5.1]
  def change
    add_index :employees, :tenant_id
  end
end
