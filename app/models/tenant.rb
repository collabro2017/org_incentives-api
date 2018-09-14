class Tenant < ApplicationRecord
  validates :name, presence: true
  has_one :feature, dependent: :destroy
  has_one :config, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :entities, dependent: :destroy
  has_many :exercise_orders, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :exercise_windows, dependent: :destroy
  has_many :windows, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :stock_prices, dependent: :destroy
  has_many :incentive_programs, dependent: :destroy
  has_many :incentive_sub_programs, dependent: :destroy, through: :incentive_programs
  has_many :awards, dependent: :destroy, through: :incentive_sub_programs
  has_many :purchase_configs, dependent: :destroy, through: :incentive_sub_programs
  has_many :purchase_opportunities, dependent: :destroy, through: :purchase_configs
  has_many :dividends
  has_many :vesting_events, through: :awards
  has_many :transactions, through: :vesting_events

  def as_json(options = nil)
    super((options || {}).merge(include: :feature))
  end
end
