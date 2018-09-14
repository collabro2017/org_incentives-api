class IncentiveProgram < ApplicationRecord
  validates_presence_of :name, :startDate, :endDate
  has_many :incentive_sub_programs, dependent: :destroy
  belongs_to :tenant

  def include_everything_json
    self.as_json(
        include: {
            incentive_sub_programs: {
                include: [
                    { :purchase_config => { include: :purchase_opportunities } },
                    { :incentive_sub_program_template => { include: :vesting_event_templates } },
                    {
                        :awards => {
                            include: {
                                vesting_events: {
                                    include: :transactions,
                                    methods: [:exercised_quantity, :fair_value, :termination_quantity]
                                }
                            }
                        }
                    },
                ]
            }
        },
        :except => [:tenant_id]
    )
  end
end
