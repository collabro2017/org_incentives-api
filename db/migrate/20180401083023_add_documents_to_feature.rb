class AddDocumentsToFeature < ActiveRecord::Migration[5.1]
  def change
    add_column :features, :documents, :boolean
  end
end
