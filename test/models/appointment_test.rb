require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @patient = Patient.create!(full_name: "Jane")
    @provider = Staff.create!(full_name: "Dr.")
    @location = Location.create!(name: "Clinic")
  end

  test "requires starts_at" do
    appt = Appointment.new(patient: @patient, provider: @provider, location: @location)
    assert_not appt.valid?
  end
end
