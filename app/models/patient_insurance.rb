class PatientInsurance < ApplicationRecord
  belongs_to :patient

  enum :insurance_type, {primary: 0, secondary: 1}

  validates :insurance_type, presence: true
end
