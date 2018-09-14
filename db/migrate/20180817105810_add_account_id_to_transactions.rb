class AddAccountIdToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :account_id, :text, index: true
  end
end
