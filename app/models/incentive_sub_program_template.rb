class IncentiveSubProgramTemplate < ApplicationRecord
  belongs_to :incentive_sub_program
  has_many :vesting_event_templates, dependent: :destroy
end
