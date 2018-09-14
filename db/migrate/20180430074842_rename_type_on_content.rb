class RenameTypeOnContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :contents, :type, :template_type
  end
end
