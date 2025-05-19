class AuditLog < ApplicationRecord
  belongs_to :user, class_name: 'Staff'
  belongs_to :auditable, polymorphic: true
end
