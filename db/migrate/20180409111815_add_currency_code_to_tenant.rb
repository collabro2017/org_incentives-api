class AddCurrencyCodeToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :currency_code, :string, :limit => 3, :default => "NOK"
  end
end
