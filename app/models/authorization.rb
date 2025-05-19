class Authorization < ApplicationRecord
  belongs_to :patient
  belongs_to :insurance, class_name: "PatientInsurance"

  enum :status, {pending: 0, approved: 1, denied: 2}

  validates :service_type, presence: true
  validates :status, presence: true
end
