class CreatePurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_orders, id: :uuid do |t|
      t.integer :purchase_amount, null: false
      t.uuid :order_id, null: false
      t.uuid :purchase_opportunity_id, null: false

      t.timestamps

      t.index ["order_id"], name: "index_order_id_on_purchase_orders"
      t.index ["purchase_opportunity_id"], name: "index_purchase_opportunity_id_on_purchase_orders"
    end
  end
end
