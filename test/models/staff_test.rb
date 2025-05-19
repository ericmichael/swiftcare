require "test_helper"

class StaffTest < ActiveSupport::TestCase
  test "invalid without full_name" do
    assert_not Staff.new.valid?
  end
end
