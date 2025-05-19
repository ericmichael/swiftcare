class Location < ApplicationRecord
  include HasAddress

  has_many :provider_schedules, dependent: :destroy
  has_many :appointments, dependent: :nullify
  has_many :encounters, dependent: :nullify

  validates :name, presence: true
end
