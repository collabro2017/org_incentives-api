class CreateContents < ActiveRecord::Migration[5.1]
  def change
    create_table :contents, id: :uuid do |t|
      t.string :type, null: false
      t.string :content_type, null: false
      t.string :content, null: false

      t.uuid :tenant_id

      t.timestamps

      t.index ["tenant_id"], name: "index_tenant_id_on_contents"
      t.timestamps
    end
  end
end
