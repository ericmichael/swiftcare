class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :provider, class_name: 'Staff'
  belongs_to :location
  has_one :encounter

  enum :visit_type, { office: 0, telehealth: 1 }
  enum :status, { scheduled: 0, canceled: 1, no_show: 2 }

  validates :starts_at, presence: true
  validates :visit_type, presence: true
end
