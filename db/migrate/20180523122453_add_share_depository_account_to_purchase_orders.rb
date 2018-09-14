class AddShareDepositoryAccountToPurchaseOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :purchase_orders, :share_depository_account, :text
  end
end
