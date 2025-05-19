class FeeScheduleItem < ApplicationRecord
  belongs_to :fee_schedule
  belongs_to :service_code
end
