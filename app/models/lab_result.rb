class LabResult < ApplicationRecord
  belongs_to :encounter

  enum :status, {pending: 0, final: 1, amended: 2}

  validates :test_name, presence: true
  validates :status, presence: true
end
