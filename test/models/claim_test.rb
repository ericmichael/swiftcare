require "test_helper"

class ClaimTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
    insurance = PatientInsurance.create!(patient: patient, insurance_type: :primary)
    @claim = Claim.new(encounter: encounter, patient_insurance: insurance, status: :draft)
  end

  test "invalid without total_billed_cents" do
    assert_not @claim.valid?
  end
end
