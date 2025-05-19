class EligibilityCheck < ApplicationRecord
  belongs_to :patient_insurance
  belongs_to :appointment, optional: true
  belongs_to :checked_by, class_name: 'Staff', optional: true

  enum status: { pending: 0, completed: 1, error: 2, no_response: 3 }
  enum coverage_status: { active: 0, inactive: 1, unknown: 2, partial: 3 }
end
