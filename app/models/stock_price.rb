class StockPrice < ApplicationRecord
  validates_presence_of :price, :date
  belongs_to :tenant
end
