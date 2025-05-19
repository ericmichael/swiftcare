require 'faker'

# Basic clinic setup
location = Location.create!(name: 'Main Clinic', street: '123 Main', city: 'Town', state: 'NY', zip: '10001')
provider = Staff.create!(full_name: 'Dr. Smith', role: 'provider')
admin    = Staff.create!(full_name: 'Jane Admin', role: 'admin')

# Provider availability
%i[monday tuesday wednesday thursday friday].each do |day|
  ProviderSchedule.create!(provider: provider, location: location,
                           day_of_week: day, start_time: '09:00', end_time: '17:00')
end

# Billing setup
fee_schedule = FeeSchedule.create!(name: 'Standard')
service_code1 = ServiceCode.create!(code_type: :CPT, code: '99213', description: 'Office visit')
service_code2 = ServiceCode.create!(code_type: :CPT, code: '90834', description: 'Therapy 45 min')

[service_code1, service_code2].each do |sc|
  FeeScheduleItem.create!(fee_schedule: fee_schedule, service_code: sc, charge_cents: rand(8000..15000))
end

payer = Payer.create!(name: 'Acme Insurance', payer_identifier: 'ACME123')
contract = PayerContract.create!(payer: payer, name: '2025 Contract', effective_date: Date.today.beginning_of_year)

[service_code1, service_code2].each do |sc|
  AllowedAmount.create!(payer_contract: contract, service_code: sc, allowed_cents: rand(5000..12000))
end

# Sample patients and related records
5.times do
  patient = Patient.create!(full_name: Faker::Name.name)
  insurance = PatientInsurance.create!(patient: patient, insurance_type: :primary, payer_name: payer.name)
  Allergy.create!(patient: patient, allergen: 'Peanuts', severity: :severe)
  Problem.create!(patient: patient, icd_code: 'F41.1')
  Medication.create!(patient: patient, name: 'Sertraline', status: :active)

  appointment = Appointment.create!(patient: patient, provider: provider, location: location,
                                    starts_at: Faker::Time.forward(days: 5, period: :morning),
                                    visit_type: :office)

  # Pre-visit eligibility check
  EligibilityCheck.create!(patient_insurance: insurance, appointment: appointment, checked_at: Time.current,
                           checked_by: admin, status: :completed, coverage_status: :active)

  # Encounter and related clinical data
  encounter = Encounter.create!(patient: patient, provider: provider, location: location, appointment: appointment,
                                started_at: appointment.starts_at, ended_at: appointment.starts_at + 30.minutes,
                                visit_type: :office, status: :completed)

  Vital.create!(encounter: encounter, recorded_at: encounter.started_at,
                blood_pressure_systolic: 120, blood_pressure_diastolic: 80)
  VisitNote.create!(encounter: encounter, author: provider, body: 'Patient seen and evaluated.')
  Diagnosis.create!(encounter: encounter, icd_code: 'F41.1', status: :primary)
  Order.create!(encounter: encounter, order_type: :lab, status: :completed, data_json: { test: 'CBC' })
  LabResult.create!(encounter: encounter, test_name: 'CBC', status: :final, performed_at: encounter.started_at)

  auth = Authorization.create!(patient: patient, insurance: insurance, service_type: 'Therapy', status: :approved)
  claim = Claim.create!(encounter: encounter, patient_insurance: insurance, authorization: auth,
                        payer: payer, total_billed_cents: 10000, status: :draft)
  ClaimLineItem.create!(claim: claim, service_code: service_code1, billed_amount_cents: 10000)
  Payment.create!(claim: claim, amount_cents: 5000, source: :insurance, received_at: Time.current)

  CommunicationLog.create!(patient: patient, medium: :sms, direction: :outbound,
                           occurred_at: Time.current, twilio_sid: 'SM123')
  AuditLog.create!(user: admin, action: 'seed', auditable: patient)
end
