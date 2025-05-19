require "test_helper"

class AuthorizationTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
    @insurance = PatientInsurance.create!(patient: @patient, insurance_type: :primary)
  end

  test "invalid without service_type" do
    auth = Authorization.new(patient: @patient, insurance: @insurance, status: :pending)
    assert_not auth.valid?
  end

  test "valid with required attributes" do
    auth = Authorization.new(patient: @patient, insurance: @insurance, status: :pending, service_type: "therapy")
    assert auth.valid?
  end
end
