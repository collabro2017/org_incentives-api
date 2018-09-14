class AddFairValueToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :fair_value, :decimal
  end
end
