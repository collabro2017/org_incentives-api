class ExerciseWindow < ApplicationRecord
  validates_presence_of :startTime, :endTime, :tenant_id
end
