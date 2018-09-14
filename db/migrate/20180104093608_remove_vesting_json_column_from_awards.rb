class RemoveVestingJsonColumnFromAwards < ActiveRecord::Migration[5.1]
  def change
    remove_column :awards, :vesting
  end
end
