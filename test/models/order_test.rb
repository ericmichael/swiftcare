require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
    @order = Order.new(encounter: encounter, status: :pending)
  end

  test "invalid without order_type" do
    assert_not @order.valid?
  end
end
