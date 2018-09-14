class AddAllowedExerciseTypesToWindows < ActiveRecord::Migration[5.1]
  def change
    add_column :windows, :allowed_exercise_types, :text, array: true, default: %w["EXERCISE_AND_SELL", "EXERCISE_AND_SELL_TO_COVER", "EXERCISE_AND_HOLD"]
  end
end
