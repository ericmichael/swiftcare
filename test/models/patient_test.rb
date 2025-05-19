require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "valid factory" do
    patient = Patient.new(full_name: "John Doe")
    assert patient.valid?
  end
end
