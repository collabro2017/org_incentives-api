class AddMessageToStockPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :stock_prices, :message, :string
  end
end
