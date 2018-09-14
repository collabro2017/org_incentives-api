class AddDocumentHeaderToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :document_header, :text
  end
end
