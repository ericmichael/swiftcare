require 'faker'

5.times do
  patient = Patient.create!(full_name: Faker::Name.name)
  PatientInsurance.create!(patient:, insurance_type: :primary, payer_name: Faker::Company.name)
end

staff = Staff.create!(full_name: 'Dr. Smith', role: 'provider')
Location.create!(name: 'Main Clinic')
