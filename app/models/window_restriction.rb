class WindowRestriction < ApplicationRecord
  has_many :window_employee_restrictions, dependent: :destroy
  has_many :employees, through: :window_employee_restrictions
end
