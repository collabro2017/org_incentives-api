class AddRequireShareDepositoryToPurchaseConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :purchase_configs, :require_share_depository, :boolean, :default => false
  end
end
