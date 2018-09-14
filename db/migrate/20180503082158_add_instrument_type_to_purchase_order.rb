class AddInstrumentTypeToPurchaseOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :purchase_orders, :instrument_type, :string
  end
end
