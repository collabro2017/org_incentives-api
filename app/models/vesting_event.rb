class VestingEvent < ApplicationRecord
  validates_presence_of :award_id
  belongs_to :award
  has_many :transactions, -> { order('transaction_date ASC') }, dependent: :destroy
  has_many :dividend_vesting_events, foreign_key: "dividend_source_vesting_event_id", class_name: "VestingEvent"

  def grant_date
    self.transactions.map { |x| x.grant_date }.select { |x| x.present? }.last
  end

  def vestedDate
    self.vested_date
  end

  def vested_date
    self.transactions.map {|x| x.vested_date }.select { |x| x.present? }.last
  end

  def expiry_date
    self.transactions.map { |x| x.expiry_date }.select { |x| x.present? }.last
  end

  def strike
    self.transactions.map { |x| x.strike }.select { |x| x.present? }.last
  end

  def fair_value
    fair_values = self.transactions.map { |x| x.fair_value }.select { |x| x.present? }
    fair_values.empty? ? nil : fair_values.sum
  end

  def quantity
    self.transactions.map { |x| x.quantity }.select { |x| x.present? }.sum +
    self.transactions.map { |x| x.termination_quantity }.select { |x| x.present? }.sum
  end

  def exercised_quantity
    self.transactions.all.reduce(0) { |accu, current| accu + (current.transaction_type == "EXERCISE" ? current.quantity : 0) }
  end

  def termination_quantity
    -1 * self.transactions.all.reduce(0) { |accu, current| accu + (current.transaction_type == "TERMINATION" ? current.termination_quantity : 0) }
  end

  def exercised_quantity_hash
    {
        exercised_quantity: exercised_quantity
    }
  end

  def as_json(options = nil)
    super((options || {}).merge(include: :transactions, methods: [:exercised_quantity, :fair_value, :termination_quantity]))
  end
end
