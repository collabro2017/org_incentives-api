class CreateExerciseOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_orders, id: :uuid do |t|
      t.string :status
      t.string :exerciseType
      t.uuid :tenant_id
      t.uuid :employee_id

      t.timestamps

      t.index ["tenant_id"], name: "index_tenant_id_on_exercise_orders"
      t.index ["employee_id"], name: "index_employee_id_on_exercise_orders"
    end
  end
end
