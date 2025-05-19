require "test_helper"

class MedicationTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
  end

  test "invalid without name" do
    med = Medication.new(patient: @patient, status: :active)
    assert_not med.valid?
  end
end
