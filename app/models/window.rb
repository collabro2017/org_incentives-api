class Window < ApplicationRecord
  validates_presence_of :start_time, :end_time, :tenant_id
  has_one :window_restriction, dependent: :destroy
  has_many :orders

  def as_json_include_descendants
    self.as_json(include: { window_restriction: { include: :window_employee_restrictions } })
  end

  def is_employee_eligable(employee_id)
    self.window_restriction.nil? or self.window_restriction.window_employee_restrictions.exists?(employee_id: employee_id)
  end

  def sum_exercise_orders_quantities
    orders = self.orders.where(order_type: "EXERCISE")
    orders.map { |o| o.order_quantity}.sum
  end

  def sum_cashless_orders_quantities
    orders = self.orders.where(order_type: "EXERCISE")
    orders.map { |o| o.exercise_order.exerciseType == "EXERCISE_AND_HOLD" ? 0 : o.order_quantity }.sum
  end
end
