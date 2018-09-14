class UpdateCreatedAtForExerciseOrdersTry3 < ActiveRecord::Migration[5.1]
  def change
    ExerciseOrder.find_each do |eo|
      eo.order.created_at = eo.created_at
      eo.order.updated_at = eo.updated_at
      eo.order.save!
    end
  end
end
