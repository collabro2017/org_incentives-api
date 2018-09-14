class MoveExerciseWindowsToWindowsTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :windows, :type, :window_type
    ExerciseWindow.find_each do |ew|
      Window.create!(
          window_type: "EXERCISE",
          start_time: ew.startTime,
          end_time: ew.endTime,
          payment_deadline: ew.payment_deadline,
          tenant_id: ew.tenant_id,
          created_at: ew.created_at,
          updated_at: ew.updated_at
      )
    end
  end
end
