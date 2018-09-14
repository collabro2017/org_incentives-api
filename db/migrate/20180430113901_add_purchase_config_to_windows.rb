class AddPurchaseConfigToWindows < ActiveRecord::Migration[5.1]
  def change
    add_column :windows, :purchase_config_id, :uuid
  end
end
