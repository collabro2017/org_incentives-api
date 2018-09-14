class RemovePurchaseConfigIdFromWindows < ActiveRecord::Migration[5.1]
  def change
    remove_column :windows, :purchase_config_id, :uuid
  end
end
