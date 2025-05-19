class ProviderSchedule < ApplicationRecord
  belongs_to :provider, class_name: "Staff"
  belongs_to :location

  enum :day_of_week, {sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

  validates :day_of_week, presence: true
end
