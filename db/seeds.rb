require 'faker'

location = Location.create!(name: 'Main Clinic', street: '123 Main', city: 'Town', state: 'NY', zip: '10001')

provider = Staff.create!(full_name: 'Dr. Smith', role: 'provider')
admin    = Staff.create!(full_name: 'Jane Admin', role: 'admin')

5.times do
  patient = Patient.create!(full_name: Faker::Name.name)
  PatientInsurance.create!(patient: patient, insurance_type: :primary, payer_name: Faker::Company.name)

  Appointment.create!(patient: patient, provider: provider, location: location,
                      starts_at: Faker::Time.forward(days: 5, period: :morning),
                      visit_type: :office)
end

