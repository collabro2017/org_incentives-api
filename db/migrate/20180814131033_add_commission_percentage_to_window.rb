class AddCommissionPercentageToWindow < ActiveRecord::Migration[5.1]
  def change
    add_column :windows, :commission_percentage, :decimal
  end
end
