class AddGrantAndExpiryDateToVestingEvents < ActiveRecord::Migration[5.1]
  def self.up
    add_column :vesting_events, :grant_date, :date
    add_column :vesting_events, :expiry_date, :date

    Award.all.each { |award|
      award.vesting_events.all.each { |ve|
        ve.update_attribute(:grant_date, award.grantDate)
        ve.update_attribute(:expiry_date, award.expiryDate)
      }
    }
  end
end
