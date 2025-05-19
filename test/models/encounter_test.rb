require "test_helper"

class EncounterTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Pat")
    @provider = Staff.create!(full_name: "Dr")
    @location = Location.create!(name: "Clinic")
  end

  test "ended_at after started_at" do
    enc = Encounter.new(patient: @patient, provider: @provider, location: @location, started_at: Time.current, ended_at: 1.hour.ago, status: :in_progress)
    assert_not enc.valid?
  end
end
