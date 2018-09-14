class AddNameAndDesctiptionToContentV2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :contents, :string, :string
    add_column :contents, :description, :string
  end
end
