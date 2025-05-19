require "test_helper"

class AuditLogTest < ActiveSupport::TestCase
  setup do
    @user = Staff.create!(full_name: "Admin")
    @patient = Patient.create!(full_name: "P")
  end

  test "invalid without action" do
    log = AuditLog.new(user: @user, auditable: @patient)
    assert_not log.valid?
  end
end
