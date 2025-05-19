class Location < ApplicationRecord
  has_many :provider_schedules
  has_many :appointments
  has_many :encounters

  validates :name, presence: true
end
