class AddGrantTransactionToAllVestingEvents < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.transaction do
      VestingEvent.all.each {|vesting_event|
        vesting_event.transactions.create!(
            transaction_type: "GRANT",
            transaction_date: vesting_event.grant_date,
            grant_date: vesting_event.grant_date,
            vested_date: vesting_event.vestedDate,
            expiry_date: vesting_event.expiry_date,
            quantity: vesting_event.quantity,
            purchase_price: vesting_event.purchase_price,
            strike: vesting_event.strike
        )
      }
    end
  end
end
