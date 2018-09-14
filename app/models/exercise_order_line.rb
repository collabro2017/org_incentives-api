class ExerciseOrderLine < ApplicationRecord
  validates_presence_of :vesting_event_id, :exercise_quantity
  belongs_to :exercise_order
  belongs_to :vesting_event
end
