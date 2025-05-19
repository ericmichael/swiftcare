require "test_helper"

class ProblemTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
  end

  test "invalid without icd_code" do
    prob = Problem.new(patient: @patient)
    assert_not prob.valid?
  end
end
