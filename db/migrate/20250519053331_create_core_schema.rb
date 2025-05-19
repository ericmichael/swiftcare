class CreateCoreSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :full_name, null: false
      t.date :dob
      t.string :email
      t.string :phone
      t.string :gender
      t.json :address_json
      t.string :mrn
      t.string :encrypted_ssn
      t.string :primary_language
      t.string :preferred_contact_method
      t.timestamps
    end

    create_table :patient_insurances do |t|
      t.references :patient, null: false, foreign_key: true
      t.integer :insurance_type, null: false
      t.string :payer_name
      t.string :policy_number
      t.string :group_number
      t.string :subscriber_name
      t.date :subscriber_dob
      t.string :relationship_to_subscriber
      t.integer :copay_amount_cents
      t.integer :coinsurance_percentage
      t.date :coverage_start_date
      t.date :coverage_end_date
      t.timestamps
    end

    create_table :staffs do |t|
      t.string :type
      t.string :full_name, null: false
      t.string :role
      t.string :encrypted_password
      t.string :npi
      t.string :license_number
      t.string :license_state
      t.json :specialties_json
      t.json :board_certifications_json
      t.timestamps
    end

    create_table :provider_schedules do |t|
      t.references :provider, null: false, foreign_key: {to_table: :staffs}
      t.integer :day_of_week, null: false
      t.time :start_time
      t.time :end_time
      t.references :location, null: false, foreign_key: true
      t.boolean :is_available, default: true
      t.timestamps
    end

    create_table :locations do |t|
      t.string :name, null: false
      t.json :address_json
      t.string :phone
      t.string :fax
      t.boolean :is_active, default: true
      t.timestamps
    end

    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: {to_table: :staffs}
      t.references :location, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.integer :duration_min
      t.integer :visit_type
      t.integer :status, default: 0
      t.string :reason
      t.timestamps
    end

    create_table :encounters do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: {to_table: :staffs}
      t.references :location, null: false, foreign_key: true
      t.references :appointment, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :visit_type
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :problems do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :icd_code
      t.text :description
      t.integer :status, default: 0
      t.date :onset_date
      t.date :resolved_date
      t.timestamps
    end

    create_table :allergies do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :allergen
      t.string :reaction
      t.integer :severity, default: 0
      t.date :onset_date
      t.timestamps
    end

    create_table :medications do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :name
      t.string :dosage
      t.string :frequency
      t.string :route
      t.date :start_date
      t.date :end_date
      t.references :prescribed_by, foreign_key: {to_table: :staffs}
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :vitals do |t|
      t.references :encounter, null: false, foreign_key: true
      t.integer :blood_pressure_systolic
      t.integer :blood_pressure_diastolic
      t.integer :heart_rate
      t.decimal :temperature, precision: 4, scale: 1
      t.decimal :weight, precision: 5, scale: 2
      t.decimal :height, precision: 5, scale: 2
      t.integer :oxygen_saturation
      t.integer :pain_scale
      t.datetime :recorded_at
      t.timestamps
    end

    create_table :lab_results do |t|
      t.references :encounter, null: false, foreign_key: true
      t.string :test_name
      t.string :test_code
      t.string :result_value
      t.string :result_unit
      t.string :reference_range
      t.integer :status, default: 0
      t.datetime :performed_at
      t.timestamps
    end

    create_table :visit_notes do |t|
      t.references :encounter, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: {to_table: :staffs}
      t.datetime :signed_at
      t.text :subjective
      t.text :objective
      t.text :assessment
      t.text :plan
      t.timestamps
    end

    create_table :diagnoses do |t|
      t.references :encounter, null: false, foreign_key: true
      t.string :icd_code
      t.string :description
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :orders do |t|
      t.references :encounter, null: false, foreign_key: true
      t.integer :order_type, null: false
      t.integer :status, default: 0
      t.json :data_json
      t.timestamps
    end

    create_table :authorizations do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :insurance, null: false, foreign_key: {to_table: :patient_insurances}
      t.string :service_type
      t.string :authorization_number
      t.date :start_date
      t.date :end_date
      t.integer :units_approved
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :service_codes do |t|
      t.integer :code_type, null: false
      t.string :code
      t.string :description
      t.string :category
      t.timestamps
    end

    create_table :fee_schedules do |t|
      t.string :name
      t.text :description
      t.boolean :is_default, default: false
      t.timestamps
    end

    create_table :fee_schedule_items do |t|
      t.references :fee_schedule, null: false, foreign_key: true
      t.references :service_code, null: false, foreign_key: true
      t.integer :charge_cents
      t.timestamps
    end

    create_table :payers do |t|
      t.string :name
      t.string :payer_identifier
      t.json :address_json
      t.string :phone
      t.timestamps
    end

    create_table :payer_contracts do |t|
      t.references :payer, null: false, foreign_key: true
      t.string :name
      t.date :effective_date
      t.date :expiration_date
      t.timestamps
    end

    create_table :allowed_amounts do |t|
      t.references :payer_contract, null: false, foreign_key: true
      t.references :service_code, null: false, foreign_key: true
      t.integer :allowed_cents
      t.timestamps
    end

    create_table :claims do |t|
      t.references :encounter, null: false, foreign_key: true
      t.references :patient_insurance, null: false, foreign_key: true
      t.references :authorization, foreign_key: true
      t.integer :total_billed_cents
      t.integer :total_allowed_cents
      t.integer :total_paid_cents
      t.integer :total_adjustment_cents
      t.references :payer, foreign_key: true
      t.integer :status, default: 0
      t.string :denial_code
      t.string :denial_reason
      t.datetime :submitted_at
      t.timestamps
    end

    create_table :claim_line_items do |t|
      t.references :claim, null: false, foreign_key: true
      t.references :service_code, null: false, foreign_key: true
      t.json :diagnosis_pointer_json
      t.integer :billed_amount_cents
      t.integer :allowed_amount_cents
      t.integer :paid_amount_cents
      t.integer :adjustment_cents
      t.integer :units
      t.string :modifier1
      t.string :modifier2
      t.string :modifier3
      t.string :modifier4
      t.timestamps
    end

    create_table :payments do |t|
      t.references :claim, foreign_key: true
      t.references :patient, foreign_key: true
      t.integer :amount_cents
      t.integer :source, null: false
      t.string :external_id
      t.datetime :received_at
      t.timestamps
    end

    create_table :communication_logs do |t|
      t.references :patient, foreign_key: true
      t.integer :medium, null: false
      t.string :twilio_sid
      t.string :direction
      t.datetime :occurred_at
      t.json :payload_json
      t.timestamps
    end

    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: {to_table: :staffs}
      t.string :action
      t.string :auditable_type
      t.bigint :auditable_id
      t.json :diff_json
      t.timestamps
    end

    create_table :eligibility_checks do |t|
      t.references :patient_insurance, null: false, foreign_key: true
      t.references :appointment, foreign_key: true
      t.datetime :checked_at
      t.references :checked_by, foreign_key: {to_table: :staffs}
      t.integer :status, default: 0
      t.integer :coverage_status, default: 0
      t.text :edi_request_payload
      t.text :edi_response_payload
      t.json :parsed_response_json
      t.text :notes
      t.timestamps
    end
  end
end
