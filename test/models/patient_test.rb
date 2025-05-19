require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "valid factory" do
    patient = Patient.new(full_name: "John Doe")
    assert patient.valid?
  end

  test "soft delete sets deleted_at" do
    patient = Patient.create!(full_name: "Temp")
    assert_nil patient.deleted_at
    patient.soft_delete
    assert_not_nil patient.deleted_at
  end
end
