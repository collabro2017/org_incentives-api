class AddBankAccountNumberToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :bank_account_number, :string
  end
end
