class PurchaseOpportunity < ApplicationRecord
  validates_presence_of :employee_id
  belongs_to :purchase_config
  has_one :document
end
