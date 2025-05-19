class Vital < ApplicationRecord
  belongs_to :encounter

  validates :recorded_at, presence: true
end
