class ConvertVestingEventIdToUuid < ActiveRecord::Migration[5.1]
  def change
    change_column :exercise_order_lines, :vesting_event_id, "uuid USING vesting_event_id::uuid"
  end
end
