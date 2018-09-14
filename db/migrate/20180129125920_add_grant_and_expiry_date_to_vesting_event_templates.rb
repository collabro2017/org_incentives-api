class AddGrantAndExpiryDateToVestingEventTemplates < ActiveRecord::Migration[5.1]
  def self.up
    add_column :vesting_event_templates, :grant_date, :date
    add_column :vesting_event_templates, :expiry_date, :date

    IncentiveSubProgramTemplate.all.each { |template|
      template.vesting_event_templates.all.each { |ve|
        ve.update_attribute(:grant_date, template.grantDate)
        ve.update_attribute(:expiry_date, template.expiryDate)
      }
    }
  end
end
