class CommunicationLog < ApplicationRecord
  belongs_to :patient, optional: true

  enum medium: { sms: 0, voice: 1 }
  enum direction: { inbound: "inbound", outbound: "outbound" }

  validates :medium, presence: true
  validates :direction, presence: true
  validates :occurred_at, presence: true
end
