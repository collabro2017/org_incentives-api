class AddPaymentAddressToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :payment_address, :string
  end
end
