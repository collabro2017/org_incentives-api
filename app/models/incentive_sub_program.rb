class IncentiveSubProgram < ApplicationRecord
  validates_presence_of :name, :instrumentTypeId, :settlementTypeId
  has_one :incentive_sub_program_template, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :vesting_events, through: :awards
  has_one :purchase_config, dependent: :destroy
  belongs_to :incentive_program

  def as_json(options = nil)
    super((options || {}).merge(include: { incentive_sub_program_template: { include: :vesting_event_templates } }))
  end
end
