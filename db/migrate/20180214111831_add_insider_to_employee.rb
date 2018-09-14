class AddInsiderToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :insider, :boolean, :default => false
  end
end
