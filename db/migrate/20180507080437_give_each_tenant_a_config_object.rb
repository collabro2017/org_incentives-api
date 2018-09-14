class GiveEachTenantAConfigObject < ActiveRecord::Migration[5.1]
  def change
    Tenant.find_each do |tenant|
      unless tenant.config.present?
        tenant.config = Config.create!(texts: {})
      end
    end
  end
end
