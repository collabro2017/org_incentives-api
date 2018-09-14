class ExerciseOrder < ApplicationRecord
  validates_presence_of :exerciseType
  has_many :exercise_order_lines, dependent: :destroy
  belongs_to :employee
  belongs_to :order

  def as_json(options = {})
    super({ include: :exercise_order_lines }.update(options))
  end

  def totalCostOfExercise
    self.exercise_order_lines.map { |order_line| order_line.vesting_event.strike * order_line.exercise_quantity }.reduce(:+)
  end

  def totalInstrumentsExercised
    self.exercise_order_lines.map { |order_line| order_line.exercise_quantity }.reduce(:+)
  end
end
