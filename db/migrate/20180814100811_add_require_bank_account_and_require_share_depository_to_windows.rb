class AddRequireBankAccountAndRequireShareDepositoryToWindows < ActiveRecord::Migration[5.1]
  def change
    add_column :windows, :require_bank_account, :boolean, null: false, default: true
    add_column :windows, :require_share_depository, :boolean, null: false, default: true
  end
end
