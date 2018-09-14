class AddAcceptedAtToEmployeeDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :employee_documents, :accepted_at, :datetime
  end
end
