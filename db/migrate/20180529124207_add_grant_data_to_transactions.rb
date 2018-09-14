class AddGrantDataToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :strike, :decimal
    add_column :transactions, :grant_date, :date
    add_column :transactions, :vested_date, :date
    add_column :transactions, :expiry_date, :date
    add_column :transactions, :quantity, :date
    add_column :transactions, :purchase_price, :decimal
  end
end
