class EmployeeDocument < ApplicationRecord
  validates :document_id, uniqueness: { scope: :employee_id }
  belongs_to :document
end
