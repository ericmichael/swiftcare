
class Patient < ApplicationRecord
  include SoftDeletable
  include HasAddress

  has_many :patient_insurances, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :encounters, dependent: :destroy
  has_many :problems, dependent: :destroy
  has_many :allergies, dependent: :destroy
  has_many :medications, dependent: :destroy
  has_many :payments, dependent: :nullify
  has_many :communication_logs, dependent: :nullify

  validates :full_name, presence: true
end
