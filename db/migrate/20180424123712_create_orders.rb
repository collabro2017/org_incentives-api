class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :order_type, null: false
      t.string :status, null: false
      t.uuid :tenant_id, null: false
      t.uuid :employee_id, null: false
      t.uuid :exercise_order_id

      t.timestamps

      t.index ["tenant_id"], name: "index_tenant_id_on_orders"
      t.index ["employee_id"], name: "index_employee_id_on_orders"
      t.index ["exercise_order_id"], name: "index_exercise_order_id_on_orders"
    end
  end
end
