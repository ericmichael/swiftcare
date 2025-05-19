class FeeSchedule < ApplicationRecord
  has_many :fee_schedule_items

  validates :name, presence: true
end
