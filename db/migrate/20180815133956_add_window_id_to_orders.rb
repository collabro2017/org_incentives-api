class AddWindowIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :window_id, :uuid
  end
end
