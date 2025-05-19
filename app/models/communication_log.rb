class CommunicationLog < ApplicationRecord
  include JsonSerializable

  belongs_to :patient, optional: true

  enum :medium, {sms: 0, voice: 1}
  enum :direction, {inbound: "inbound", outbound: "outbound"}

  json_fields :payload_json

  validates :medium, presence: true
  validates :direction, presence: true
  validates :occurred_at, presence: true
end
