require "test_helper"

class DiagnosisTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
    @diagnosis = Diagnosis.new(encounter: encounter, status: :primary)
  end

  test "invalid without icd_code" do
    assert_not @diagnosis.valid?
  end
end
