class RemoveIndexOnInternalIdentificationOnEmployees < ActiveRecord::Migration[5.1]
  def change
    remove_index :employees, [:tenant_id, :internal_identification]
  end
end
