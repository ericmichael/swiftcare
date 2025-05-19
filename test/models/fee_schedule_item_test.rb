require "test_helper"

class FeeScheduleItemTest < ActiveSupport::TestCase
  setup do
    fs = FeeSchedule.create!(name: "Default")
    sc = ServiceCode.create!(code_type: :CPT, code: "99213")
    @item = FeeScheduleItem.new(fee_schedule: fs, service_code: sc)
  end

  test "invalid without charge_cents" do
    assert_not @item.valid?
  end
end
