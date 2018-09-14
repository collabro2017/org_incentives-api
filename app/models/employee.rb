class Employee < ApplicationRecord
  validates_presence_of :firstName, :lastName, :email, :residence, :tenant_id
  belongs_to :tenant
  has_many :awards, dependent: :destroy
  has_many :vesting_events, through: :awards, dependent: :destroy
  has_many :employee_documents, dependent: :destroy
  has_many :purchase_opportunities, dependent: :destroy
  has_many :window_employee_restrictions, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_documents, through: :orders
  has_many :mobility_entries, dependent: :destroy

  def entity
    self.mobility_entries.all.each { |mobility|
      from = mobility.from_date || Date.new(1970, 1, 1)
      to = mobility.to_date || Date.new(4000, 1, 1)
      puts from, to, Date.today, mobility.entity_id
      if Date.today.between?(from, to)
        puts "MATCH", mobility.entity_id
        return Entity.find(mobility.entity_id)
      end
    }

    nil
  end
end
