class AddPurchasePriceToVestingEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :vesting_event_templates, :purchase_price, :decimal
    add_column :vesting_events, :purchase_price, :decimal
  end
end
