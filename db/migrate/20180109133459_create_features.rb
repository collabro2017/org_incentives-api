class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features, id: :uuid do |t|
      t.boolean :excercise, null: false, default: false
      t.timestamps
      t.uuid :tenant_id, null: false
      t.index ["tenant_id"], name: "index_tenant_id_on_features"
    end
  end
end
