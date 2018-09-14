class Document < ApplicationRecord
  validates_presence_of :file_name, :bucket_link, :tenant_id
  has_many :employee_documents, dependent: :destroy
end
