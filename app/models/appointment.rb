class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :provider, class_name: 'Staff'
  belongs_to :location
  has_one :encounter


  validates :starts_at, presence: true
end
