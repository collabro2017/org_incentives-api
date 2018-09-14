class AddMessageToEmployeeDocument < ActiveRecord::Migration[5.1]
  def change
    add_column :employee_documents, :message_header, :text
    add_column :employee_documents, :message_body, :text
  end
end
