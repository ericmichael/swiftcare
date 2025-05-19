require "test_helper"

class EligibilityCheckTest < ActiveSupport::TestCase
  setup do
    patient = Patient.create!(full_name: "Pat")
    insurance = PatientInsurance.create!(patient: patient, insurance_type: :primary)
    @check = EligibilityCheck.new(patient_insurance: insurance, status: :pending, coverage_status: :active)
  end

  test "valid factory" do
    assert @check.valid?
  end
end
