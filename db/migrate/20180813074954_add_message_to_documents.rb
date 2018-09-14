class AddMessageToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :message_header, :text
    add_column :documents, :message_body, :text
  end
end
