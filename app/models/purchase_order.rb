class PurchaseOrder < ApplicationRecord
  belongs_to :order
  belongs_to :purchase_opportunity
end
