class RemoveIsDividendFromTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :is_dividend
  end
end
