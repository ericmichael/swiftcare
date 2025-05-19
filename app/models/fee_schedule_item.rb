class FeeScheduleItem < ApplicationRecord
  belongs_to :fee_schedule
  belongs_to :service_code

  validates :charge_cents, presence: true
end
