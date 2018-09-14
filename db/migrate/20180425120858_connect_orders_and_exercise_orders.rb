class ConnectOrdersAndExerciseOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :exercise_orders, :order_id, :uuid, index: true
    ExerciseOrder.find_each do |eo|
      order = Order.new(
          status: eo.status,
          order_type: "EXERCISE",
          employee_id: eo.employee_id,
          tenant_id: eo.tenant_id,
      )
      order.exercise_order = eo
      order.save!
    end
  end
end
