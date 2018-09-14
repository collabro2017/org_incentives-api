class AddPurchaseOrderToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :purchase_order_id, :uuid, index: true
  end
end
