module AwardsHelper
  def create_award_body sub_program_id, employee_id
    {
        :incentive_sub_program_id => sub_program_id,
        :quantity => 10000,
        :employee_id => employee_id,
        :vesting_events => [{
              :grant_date => "01.01.2016",
              :vestedDate => "01.01.2017",
              :expiry_date => "01.01.2020",
              :strike => 1.0,
              :quantity => 2700
          },
          {
              :grant_date => "01.01.2016",
              :vestedDate => "01.01.2017",
              :expiry_date => "01.01.2020",
              :strike => 1.15,
              :quantity => 2700
          },
          {
              :grant_date => "01.01.2016",
              :vestedDate => "01.01.2018",
              :expiry_date => "01.01.2020",
              :strike => 1.25,
              :quantity => 2700
          },
          {
              :grant_date => "01.01.2016",
              :vestedDate => "01.01.2019",
              :expiry_date => "01.01.2020",
              :strike => 1.30,
              :quantity => 1900
          }
        ]
    }
  end
  def create_award(tenant_id, sub_program_id, employee_id)
    post "/api/v1/awards?tenantId=#{tenant_id}", create_award_body(sub_program_id, employee_id)
  end

  def update_award(tenant_id, award_id, update_body)
    put "/api/v1/awards/#{award_id}?tenantId=#{tenant_id}", update_body
  end

  def get_all_awards(tenant_id)
    get "/api/v1/awards/all_awards?tenantId=#{tenant_id}"
  end

  def delete_award(tenant_id, award_id)
    delete "/api/v1/awards/#{award_id}?tenantId=#{tenant_id}"
  end
end