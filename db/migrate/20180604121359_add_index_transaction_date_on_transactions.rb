class AddIndexTransactionDateOnTransactions < ActiveRecord::Migration[5.1]
  def change
    add_index :transactions, :transaction_date
  end
end
