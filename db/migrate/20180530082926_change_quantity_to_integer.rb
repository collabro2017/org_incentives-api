class ChangeQuantityToInteger < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :quantity
    add_column :transactions, :quantity, :integer
  end
end
