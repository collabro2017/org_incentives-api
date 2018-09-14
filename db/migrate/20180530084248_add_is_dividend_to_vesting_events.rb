class AddIsDividendToVestingEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :vesting_events, :is_dividend, :boolean, :default => false, :null => false
  end
end
