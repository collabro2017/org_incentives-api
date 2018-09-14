class CreateStockPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_prices, id: :uuid do |t|
      t.date "date", null: false
      t.decimal "price", null: false
      t.boolean "manual", null: false
      t.timestamps
      t.uuid "tenant_id", null: false
      t.index ["tenant_id"], name: "index_tenant_id_on_stock_prices"
    end
  end
end
