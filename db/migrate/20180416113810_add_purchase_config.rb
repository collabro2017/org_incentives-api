class AddPurchaseConfig < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_config, id: :uuid do |t|
      t.uuid :incentive_sub_program_id, null: false
      t.decimal :price
      t.timestamps
      t.uuid :tenant_id, null: false
      t.index ["tenant_id"], name: "index_tenant_id_on_purchase_config"
      t.index ["incentive_sub_program_id"], name: "index_incentive_sub_program_id_on_purchase_config"
    end
  end
end
