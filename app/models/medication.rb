class Medication < ApplicationRecord
  belongs_to :patient
  belongs_to :prescribed_by, class_name: 'Staff', optional: true

  enum status: { active: 0, discontinued: 1 }

  validates :name, presence: true
  validates :status, presence: true
end
