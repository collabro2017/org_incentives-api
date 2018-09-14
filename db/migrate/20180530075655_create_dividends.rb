class CreateDividends < ActiveRecord::Migration[5.1]
  def change
    create_table :dividends, id: :uuid do |t|
      t.uuid :tenant_id
      t.date :dividend_date
      t.decimal :dividend_per_share

      t.timestamps
      t.index ["tenant_id"], name: "index_tenant_id_on_dividends"
    end
  end
end
