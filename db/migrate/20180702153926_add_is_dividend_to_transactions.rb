class AddIsDividendToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :is_dividend, :boolean
  end
end
