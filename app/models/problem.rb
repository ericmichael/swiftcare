class Problem < ApplicationRecord
  belongs_to :patient

  enum status: { active: 0, resolved: 1, inactive: 2 }

  validates :icd_code, presence: true
end
