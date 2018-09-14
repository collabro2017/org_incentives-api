class AddNameAndDesctiptionToContent < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :name, :string
    add_column :contents, :string, :string
  end
end
