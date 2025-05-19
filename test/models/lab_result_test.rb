require "test_helper"

class LabResultTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
    @result = LabResult.new(encounter: encounter, status: :pending)
  end

  test "invalid without test_name" do
    assert_not @result.valid?
  end
end
