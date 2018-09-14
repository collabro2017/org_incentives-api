class CreateConfigsForTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :configs_for_tenants, id: :uuid do |t|
    end
  end
end
