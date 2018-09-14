class Award < ApplicationRecord
  validates_presence_of :quantity, :employee_id, :incentive_sub_program_id
  belongs_to :incentive_sub_program
  belongs_to :employee
  has_many :vesting_events, dependent: :destroy
end
