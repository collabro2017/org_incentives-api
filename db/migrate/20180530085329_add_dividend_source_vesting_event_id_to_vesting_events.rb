class AddDividendSourceVestingEventIdToVestingEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :vesting_events, :dividend_source_vesting_event_id, :uuid
    add_index :vesting_events, :dividend_source_vesting_event_id
  end
end
