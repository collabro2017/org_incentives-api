class AddVpsAccountToExerciseOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :exercise_orders, :vps_account, :string
  end
end
