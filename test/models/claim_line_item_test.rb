require "test_helper"

class ClaimLineItemTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    provider = Staff.create!(full_name: "Dr")
    location = Location.create!(name: "Clinic")
    encounter = Encounter.create!(patient: patient, provider: provider, location: location, started_at: Time.current, status: :in_progress)
    insurance = PatientInsurance.create!(patient: patient, insurance_type: :primary)
    claim = Claim.create!(encounter: encounter, patient_insurance: insurance, status: :draft, total_billed_cents: 1000)
    service = ServiceCode.create!(code_type: :CPT, code: "99213")
    @item = ClaimLineItem.new(claim: claim, service_code: service)
  end

  test "invalid without billed_amount_cents" do
    assert_not @item.valid?
  end

  test "valid with required attributes" do
    @item.billed_amount_cents = 500
    assert @item.valid?
  end
end
