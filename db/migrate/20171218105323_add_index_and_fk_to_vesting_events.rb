class AddIndexAndFkToVestingEvents < ActiveRecord::Migration[5.1]
  def change
    add_index :vesting_events, :award_id
  end
end
