class RenameContents < ActiveRecord::Migration[5.1]
  def change
    rename_table :contents, :content_templates
  end
end
