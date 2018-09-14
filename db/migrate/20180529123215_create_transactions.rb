class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.uuid :vesting_event_id
      t.string :type
      t.date :transaction_date

      t.integer :termination_quantity
      t.date :termination_date

      t.timestamps
      t.index ["vesting_event_id"], name: "index_vesting_event_id_on_transactions"
    end
  end
end
