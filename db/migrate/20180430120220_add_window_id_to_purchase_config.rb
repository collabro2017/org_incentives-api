class AddWindowIdToPurchaseConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :purchase_configs, :window_id, :uuid
  end
end
