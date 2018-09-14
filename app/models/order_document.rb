class OrderDocument < ApplicationRecord
  belongs_to :order
  belongs_to :document
end
