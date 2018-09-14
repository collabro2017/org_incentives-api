class RemovePurchaseAndExerciseOrderIdFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :purchase_order_id
    remove_index :orders, :exercise_order_id
    remove_column :orders, :exercise_order_id
  end
end
