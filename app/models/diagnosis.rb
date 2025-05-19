class Diagnosis < ApplicationRecord
  belongs_to :encounter

  enum status: { primary: 0, secondary: 1 }
end
