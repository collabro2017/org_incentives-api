class AddPaymentDeadlineToExerciseWindow < ActiveRecord::Migration[5.1]
  def change
    add_column :exercise_windows, :payment_deadline, :datetime
  end
end
