class Order < ApplicationRecord
  include JsonSerializable

  belongs_to :encounter

  enum order_type: {medication: 0, lab: 1, imaging: 2}
  enum status: {pending: 0, completed: 1, canceled: 2}

  json_fields :data_json

  validates :order_type, presence: true
  validates :status, presence: true
end
