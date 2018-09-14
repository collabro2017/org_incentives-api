class AddIndexOnEmployeeDocumentsDocumentId < ActiveRecord::Migration[5.1]
  def change
    add_index :employee_documents, :document_id
  end
end
