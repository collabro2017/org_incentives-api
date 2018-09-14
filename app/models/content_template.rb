class ContentTemplate < ApplicationRecord
  validates_presence_of :raw_content, :content_type, :template_type
end
