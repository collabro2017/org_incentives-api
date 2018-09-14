class AddBankAccountToExerciseOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :exercise_orders, :bank_account, :text
  end
end
