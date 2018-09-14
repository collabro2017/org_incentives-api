class CreateExerciseOrderLines < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_order_lines, id: :uuid do |t|
      t.string :vesting_event_id
      t.integer :exercise_quantity
      t.uuid :exercise_order_id

      t.timestamps
      t.index ["exercise_order_id"], name: "index_exercise_order_id_on_exercise_order_line"
    end
  end
end
