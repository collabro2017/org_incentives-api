class CreateConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :configs, id: :uuid do |t|
      t.json :texts, :default => {}.as_json

      t.timestamps
      t.uuid :tenant_id
      t.index ["tenant_id"], name: "index_tenant_id_on_configs"
    end
  end
end
