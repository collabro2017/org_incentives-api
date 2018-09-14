class AddPurchaseToFeature < ActiveRecord::Migration[5.1]
  def change
    add_column :features, :purchase, :boolean
  end
end
