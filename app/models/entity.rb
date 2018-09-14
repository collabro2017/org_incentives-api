class Entity < ApplicationRecord
  validates :name, presence: true
  validates :countryCode, presence: true
  belongs_to :tenant
end
