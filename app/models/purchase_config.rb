class PurchaseConfig < ApplicationRecord
  validates_presence_of :incentive_sub_program_id
  has_many :purchase_opportunities, dependent: :destroy
  belongs_to :incentive_sub_program
  belongs_to :window, optional: true
end
