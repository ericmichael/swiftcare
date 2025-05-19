require "test_helper"

class CommunicationLogTest < ActiveSupport::TestCase
  test "enum direction" do
    assert_includes CommunicationLog.directions.keys, "inbound"
  end

  test "invalid without occurred_at" do
    log = CommunicationLog.new(medium: :sms, direction: :inbound)
    assert_not log.valid?
  end
end
