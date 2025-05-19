class Patient < ApplicationRecord
  has_many :patient_insurances
  has_many :appointments
  has_many :encounters
  has_many :problems
  has_many :allergies
  has_many :medications
  has_many :payments
  has_many :communication_logs

  validates :full_name, presence: true
end
