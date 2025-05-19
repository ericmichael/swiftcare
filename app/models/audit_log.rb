class AuditLog < ApplicationRecord
  include JsonSerializable

  belongs_to :user, class_name: "Staff"
  belongs_to :auditable, polymorphic: true

  json_fields :diff_json

  validates :action, presence: true
  validates :auditable_type, presence: true
  validates :auditable_id, presence: true
end
