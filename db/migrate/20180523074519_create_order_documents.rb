class CreateOrderDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :order_documents, id: :uuid do |t|
      t.uuid :order_id, null: false
      t.uuid :document_id, null: false

      t.timestamps

      t.index ["order_id"], name: "index_order_id_on_order_documents"
      t.index ["document_id"], name: "index_document_id_on_order_documents"
    end
  end
end
