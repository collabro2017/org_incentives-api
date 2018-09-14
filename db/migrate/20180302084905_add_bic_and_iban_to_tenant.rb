class AddBicAndIbanToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :bic_number, :string
    add_column :tenants, :iban_number, :string
  end
end
