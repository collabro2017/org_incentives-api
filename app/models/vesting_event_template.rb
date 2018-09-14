class VestingEventTemplate < ApplicationRecord
  validates_presence_of :incentive_sub_program_template_id, :vestedDate, :strike, :quantityPercentage, :grant_date, :expiry_date
  belongs_to :incentive_sub_program_template
end
