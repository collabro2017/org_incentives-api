class Country < ApplicationRecord
  validates :countryName, presence: true
  validates :code, presence: true
end
