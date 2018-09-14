class IndexOnWindowIdOnOrders < ActiveRecord::Migration[5.1]
  def change
    add_index :orders, :window_id
  end
end
