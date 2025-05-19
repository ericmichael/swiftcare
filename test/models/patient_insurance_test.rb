require "test_helper"

class PatientInsuranceTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
  end

  test "enum insurance_type" do
    assert_includes PatientInsurance.insurance_types.keys, "primary"
  end

  test "invalid without insurance_type" do
    ins = PatientInsurance.new(patient: @patient)
    assert_not ins.valid?
  end
end
