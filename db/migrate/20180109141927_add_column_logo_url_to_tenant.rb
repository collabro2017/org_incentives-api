class AddColumnLogoUrlToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :logo_url, :string
  end
end
