class AddPurchaseOpportunity < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_opportunity, id: :uuid do |t|
      t.integer :maximumAmount
      t.integer :purchasedAmount, null: false, :default => 0
      t.uuid :purchase_config_id, null: false
      t.uuid :employee_id, null: false
      t.timestamps
      t.index ["purchase_config_id"], name: "index_purchase_config_id_on_purchase_opportunity"
      t.index ["employee_id"], name: "index_employee_id_on_purchase_opportunity"
    end
  end
end
