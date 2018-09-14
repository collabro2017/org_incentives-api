class CreateExerciseWindows < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_windows, id: :uuid do |t|
      t.datetime "startTime", null: false
      t.datetime "endTime", null: false
      t.timestamps
      t.uuid :tenant_id
      t.index ["tenant_id"], name: "index_tenant_id_on_exercise_windows"
    end
  end
end
