class ChangeColumnQuantityToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :awards, :quantity, :integer
  end
end
