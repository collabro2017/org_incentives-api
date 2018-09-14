class RemoveFaultyVestingEventMigration < ActiveRecord::Migration[5.1]
  def change
    remove_reference :awards, :vesting_event, type: :uuid, foreign_key: true
  end
end
