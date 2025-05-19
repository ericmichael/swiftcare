require "test_helper"

class ProviderScheduleTest < ActiveSupport::TestCase
  setup do
    @provider = Staff.create!(full_name: "Dr. Smith")
    @location = Location.create!(name: "Main")
  end

  test "enum day_of_week includes monday" do
    assert_includes ProviderSchedule.day_of_weeks.keys, "monday"
  end

  test "invalid without day_of_week" do
    sched = ProviderSchedule.new(provider: @provider, location: @location)
    assert_not sched.valid?
  end

  test "valid with required attributes" do
    sched = ProviderSchedule.new(provider: @provider, location: @location, day_of_week: :monday)
    assert sched.valid?
  end
end
