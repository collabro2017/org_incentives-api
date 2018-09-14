class Order < ApplicationRecord
  validates_presence_of :status, :order_type
  belongs_to :employee
  belongs_to :window
  has_one :purchase_order
  has_one :exercise_order
  has_many :order_documents

  def order_quantity
    if self.order_type == "EXERCISE"
      exercise_order_lines = self.exercise_order.exercise_order_lines
      exercise_order_lines.map { |eol| eol.exercise_quantity }.sum
    else
      self.purchase_order.purchase_amount
    end
  end
end
