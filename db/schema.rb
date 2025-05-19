# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_19_054439) do
  create_table "allergies", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "allergen"
    t.string "reaction"
    t.integer "severity", default: 0
    t.date "onset_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_allergies_on_patient_id"
  end

  create_table "allowed_amounts", force: :cascade do |t|
    t.integer "payer_contract_id", null: false
    t.integer "service_code_id", null: false
    t.integer "allowed_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_contract_id"], name: "index_allowed_amounts_on_payer_contract_id"
    t.index ["service_code_id"], name: "index_allowed_amounts_on_service_code_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "provider_id", null: false
    t.integer "location_id", null: false
    t.datetime "starts_at", null: false
    t.integer "duration_min"
    t.integer "visit_type"
    t.integer "status", default: 0
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_appointments_on_location_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["provider_id"], name: "index_appointments_on_provider_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action"
    t.string "auditable_type"
    t.bigint "auditable_id"
    t.json "diff_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "authorizations", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "insurance_id", null: false
    t.string "service_type"
    t.string "authorization_number"
    t.date "start_date"
    t.date "end_date"
    t.integer "units_approved"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insurance_id"], name: "index_authorizations_on_insurance_id"
    t.index ["patient_id"], name: "index_authorizations_on_patient_id"
  end

  create_table "claim_line_items", force: :cascade do |t|
    t.integer "claim_id", null: false
    t.integer "service_code_id", null: false
    t.json "diagnosis_pointer_json"
    t.integer "billed_amount_cents"
    t.integer "allowed_amount_cents"
    t.integer "paid_amount_cents"
    t.integer "adjustment_cents"
    t.integer "units"
    t.string "modifier1"
    t.string "modifier2"
    t.string "modifier3"
    t.string "modifier4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_claim_line_items_on_claim_id"
    t.index ["service_code_id"], name: "index_claim_line_items_on_service_code_id"
  end

  create_table "claims", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.integer "patient_insurance_id", null: false
    t.integer "authorization_id"
    t.integer "total_billed_cents"
    t.integer "total_allowed_cents"
    t.integer "total_paid_cents"
    t.integer "total_adjustment_cents"
    t.integer "payer_id"
    t.integer "status", default: 0
    t.string "denial_code"
    t.string "denial_reason"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorization_id"], name: "index_claims_on_authorization_id"
    t.index ["encounter_id"], name: "index_claims_on_encounter_id"
    t.index ["patient_insurance_id"], name: "index_claims_on_patient_insurance_id"
    t.index ["payer_id"], name: "index_claims_on_payer_id"
  end

  create_table "communication_logs", force: :cascade do |t|
    t.integer "patient_id"
    t.integer "medium", null: false
    t.string "twilio_sid"
    t.string "direction"
    t.datetime "occurred_at"
    t.json "payload_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_communication_logs_on_patient_id"
  end

  create_table "diagnoses", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.string "icd_code"
    t.string "description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "index_diagnoses_on_encounter_id"
  end

  create_table "eligibility_checks", force: :cascade do |t|
    t.integer "patient_insurance_id", null: false
    t.integer "appointment_id"
    t.datetime "checked_at"
    t.integer "checked_by_id"
    t.integer "status", default: 0
    t.integer "coverage_status", default: 0
    t.text "edi_request_payload"
    t.text "edi_response_payload"
    t.json "parsed_response_json"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_eligibility_checks_on_appointment_id"
    t.index ["checked_by_id"], name: "index_eligibility_checks_on_checked_by_id"
    t.index ["patient_insurance_id"], name: "index_eligibility_checks_on_patient_insurance_id"
  end

  create_table "encounters", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "provider_id", null: false
    t.integer "location_id", null: false
    t.integer "appointment_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "visit_type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_encounters_on_appointment_id"
    t.index ["location_id"], name: "index_encounters_on_location_id"
    t.index ["patient_id"], name: "index_encounters_on_patient_id"
    t.index ["provider_id"], name: "index_encounters_on_provider_id"
  end

  create_table "fee_schedule_items", force: :cascade do |t|
    t.integer "fee_schedule_id", null: false
    t.integer "service_code_id", null: false
    t.integer "charge_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fee_schedule_id"], name: "index_fee_schedule_items_on_fee_schedule_id"
    t.index ["service_code_id"], name: "index_fee_schedule_items_on_service_code_id"
  end

  create_table "fee_schedules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lab_results", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.string "test_name"
    t.string "test_code"
    t.string "result_value"
    t.string "result_unit"
    t.string "reference_range"
    t.integer "status", default: 0
    t.datetime "performed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "index_lab_results_on_encounter_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.json "address_json"
    t.string "phone"
    t.string "fax"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medications", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "name"
    t.string "dosage"
    t.string "frequency"
    t.string "route"
    t.date "start_date"
    t.date "end_date"
    t.integer "prescribed_by_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_medications_on_patient_id"
    t.index ["prescribed_by_id"], name: "index_medications_on_prescribed_by_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.integer "order_type", null: false
    t.integer "status", default: 0
    t.json "data_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "index_orders_on_encounter_id"
  end

  create_table "patient_insurances", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "insurance_type", null: false
    t.string "payer_name"
    t.string "policy_number"
    t.string "group_number"
    t.string "subscriber_name"
    t.date "subscriber_dob"
    t.string "relationship_to_subscriber"
    t.integer "copay_amount_cents"
    t.integer "coinsurance_percentage"
    t.date "coverage_start_date"
    t.date "coverage_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patient_insurances_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "full_name", null: false
    t.date "dob"
    t.string "email"
    t.string "phone"
    t.string "gender"
    t.json "address_json"
    t.string "mrn"
    t.string "encrypted_ssn"
    t.string "primary_language"
    t.string "preferred_contact_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_patients_on_deleted_at"
  end

  create_table "payer_contracts", force: :cascade do |t|
    t.integer "payer_id", null: false
    t.string "name"
    t.date "effective_date"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payer_id"], name: "index_payer_contracts_on_payer_id"
  end

  create_table "payers", force: :cascade do |t|
    t.string "name"
    t.string "payer_identifier"
    t.json "address_json"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "claim_id"
    t.integer "patient_id"
    t.integer "amount_cents"
    t.integer "source", null: false
    t.string "external_id"
    t.datetime "received_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_payments_on_claim_id"
    t.index ["patient_id"], name: "index_payments_on_patient_id"
  end

  create_table "problems", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "icd_code"
    t.text "description"
    t.integer "status", default: 0
    t.date "onset_date"
    t.date "resolved_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_problems_on_patient_id"
  end

  create_table "provider_schedules", force: :cascade do |t|
    t.integer "provider_id", null: false
    t.integer "day_of_week", null: false
    t.time "start_time"
    t.time "end_time"
    t.integer "location_id", null: false
    t.boolean "is_available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_provider_schedules_on_location_id"
    t.index ["provider_id"], name: "index_provider_schedules_on_provider_id"
  end

  create_table "service_codes", force: :cascade do |t|
    t.integer "code_type", null: false
    t.string "code"
    t.string "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staffs", force: :cascade do |t|
    t.string "type"
    t.string "full_name", null: false
    t.string "role"
    t.string "encrypted_password"
    t.string "npi"
    t.string "license_number"
    t.string "license_state"
    t.json "specialties_json"
    t.json "board_certifications_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visit_notes", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.integer "author_id", null: false
    t.datetime "signed_at"
    t.text "subjective"
    t.text "objective"
    t.text "assessment"
    t.text "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_visit_notes_on_author_id"
    t.index ["encounter_id"], name: "index_visit_notes_on_encounter_id"
  end

  create_table "vitals", force: :cascade do |t|
    t.integer "encounter_id", null: false
    t.integer "blood_pressure_systolic"
    t.integer "blood_pressure_diastolic"
    t.integer "heart_rate"
    t.decimal "temperature", precision: 4, scale: 1
    t.decimal "weight", precision: 5, scale: 2
    t.decimal "height", precision: 5, scale: 2
    t.integer "oxygen_saturation"
    t.integer "pain_scale"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "index_vitals_on_encounter_id"
  end

  add_foreign_key "allergies", "patients"
  add_foreign_key "allowed_amounts", "payer_contracts"
  add_foreign_key "allowed_amounts", "service_codes"
  add_foreign_key "appointments", "locations"
  add_foreign_key "appointments", "patients"
  add_foreign_key "appointments", "staffs", column: "provider_id"
  add_foreign_key "audit_logs", "staffs", column: "user_id"
  add_foreign_key "authorizations", "patient_insurances", column: "insurance_id"
  add_foreign_key "authorizations", "patients"
  add_foreign_key "claim_line_items", "claims"
  add_foreign_key "claim_line_items", "service_codes"
  add_foreign_key "claims", "authorizations"
  add_foreign_key "claims", "encounters"
  add_foreign_key "claims", "patient_insurances"
  add_foreign_key "claims", "payers"
  add_foreign_key "communication_logs", "patients"
  add_foreign_key "diagnoses", "encounters"
  add_foreign_key "eligibility_checks", "appointments"
  add_foreign_key "eligibility_checks", "patient_insurances"
  add_foreign_key "eligibility_checks", "staffs", column: "checked_by_id"
  add_foreign_key "encounters", "appointments"
  add_foreign_key "encounters", "locations"
  add_foreign_key "encounters", "patients"
  add_foreign_key "encounters", "staffs", column: "provider_id"
  add_foreign_key "fee_schedule_items", "fee_schedules"
  add_foreign_key "fee_schedule_items", "service_codes"
  add_foreign_key "lab_results", "encounters"
  add_foreign_key "medications", "patients"
  add_foreign_key "medications", "staffs", column: "prescribed_by_id"
  add_foreign_key "orders", "encounters"
  add_foreign_key "patient_insurances", "patients"
  add_foreign_key "payer_contracts", "payers"
  add_foreign_key "payments", "claims"
  add_foreign_key "payments", "patients"
  add_foreign_key "problems", "patients"
  add_foreign_key "provider_schedules", "locations"
  add_foreign_key "provider_schedules", "staffs", column: "provider_id"
  add_foreign_key "visit_notes", "encounters"
  add_foreign_key "visit_notes", "staffs", column: "author_id"
  add_foreign_key "vitals", "encounters"
end
