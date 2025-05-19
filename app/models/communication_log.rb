class CommunicationLog < ApplicationRecord
  belongs_to :patient, optional: true

  enum medium: { sms: 0, voice: 1 }
end
