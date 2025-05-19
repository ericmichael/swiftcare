class Allergy < ApplicationRecord
  belongs_to :patient

  enum severity: { mild: 0, moderate: 1, severe: 2 }
end
