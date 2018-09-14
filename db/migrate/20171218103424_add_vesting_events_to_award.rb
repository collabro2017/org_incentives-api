class AddVestingEventsToAward < ActiveRecord::Migration[5.1]
  def change
    add_reference :awards, :vesting_event, type: :uuid, foreign_key: true
  end
end
