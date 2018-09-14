class AddDocumentIdToEmployeeDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :employee_documents, :document_id, :uuid, index: true
  end
end
