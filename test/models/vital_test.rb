require "test_helper"

class VitalTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    @encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
  end

  test "invalid without recorded_at" do
    vital = Vital.new(encounter: @encounter)
    assert_not vital.valid?
  end
end
