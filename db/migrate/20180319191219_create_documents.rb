class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents, id: :uuid do |t|
      t.string :file_name
      t.uuid :tenant_id
      t.string :bucket_link

      t.timestamps
      t.index ["tenant_id"], name: "index_tenant_id_on_documents"
    end
  end
end
