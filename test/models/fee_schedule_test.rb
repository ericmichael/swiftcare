require "test_helper"

class FeeScheduleTest < ActiveSupport::TestCase
  test "requires name" do
    fs = FeeSchedule.new
    assert_not fs.valid?
  end
end
