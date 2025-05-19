class VisitNote < ApplicationRecord
  belongs_to :encounter
  belongs_to :author, class_name: 'Staff'
  has_rich_text :body
end
