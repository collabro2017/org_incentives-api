class AddIndexSharePriceDate < ActiveRecord::Migration[5.1]
  def change
    add_index :stock_prices, :date
  end
end
