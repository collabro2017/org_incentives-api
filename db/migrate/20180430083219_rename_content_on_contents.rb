class RenameContentOnContents < ActiveRecord::Migration[5.1]
  def change
    rename_column :contents, :content, :raw_content
  end
end
