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

  test "defaults to scheduled status" do
    appt = Appointment.create!(patient: @patient, provider: @provider, location: @location,
                              starts_at: Time.current, visit_type: :office)
    assert_equal "scheduled", appt.status
  end
end
