require "test_helper"

class AllergyTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
  end

  test "invalid without allergen" do
    allergy = Allergy.new(patient: @patient)
    assert_not allergy.valid?
  end
end
