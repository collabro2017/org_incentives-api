module IncentiveProgramsHelper
  def create_incentive_program_body
    {
        :name => "Incentive Program",
        :startDate => "01-01-2016",
        :endDate => "01-01-2020",
        :capacity => 1000000000,
        :incentive_sub_programs => [{
            :name => "Sub Program",
            :instrumentTypeId => "option",
            :settlementTypeId => "equity",
            :performance => false,
            incentive_sub_program_template: {
                vesting_event_templates: [
                    {
                        :grant_date => "01-01-2016",
                        :expiry_date => "01-01-2020",
                        :quantityPercentage => "0.27",
                        :strike => "1.34",
                        :vestedDate => "01-01-2017"
                    }
                ]
            }
        }]
    }
  end
  def create_incentive_program tenant_id
    post "/api/v1/incentive_programs?tenantId=#{tenant_id}", create_incentive_program_body
  end

  def update_incentive_program(tenant_id, incentive_program_id, update_body)
    put "/api/v1/incentive_programs/#{incentive_program_id}?tenantId=#{tenant_id}", update_body
  end

  def delete_incentive_program(tenant_id, incentive_program_id)
    delete "/api/v1/incentive_programs/#{incentive_program_id}?tenantId=#{tenant_id}"
  end

  def delete_sub_program(tenant_id, sub_program_id)
    delete "/api/v1/sub_programs/#{sub_program_id}?tenantId=#{tenant_id}"
  end
end