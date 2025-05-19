**SwiftCare Clinic — Technical Specification (Rails 8 + Hotwire, SQLite-3)**
*(hand-off document for the engineering team)*

---

### 1 . Purpose

Build a single-tenant, fully functional behavioral-health EMR platform that:

* Mirrors real-world **patient, staff, provider, billing, and reporting** workflows.
* Is **extensible** for lessons in AI engineering, data pipelines, RPA, and telephony.
* Meets baseline **HIPAA** expectations (secure transport, access controls, audit trail).

This codebase is intentionally "AI-ready" but ships **only the core system** so that learners add AI agents themselves.

---

### 2 . Technology Stack

| Layer              | Choice                                                                        | Rationale                                                                                                         |
| ------------------ | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Web framework      | **Ruby on Rails 8.0**                                                         | Latest LTS; Hotwire & Solid Queue are first-class defaults ([Ruby on Rails Guides][1], [Ruby on Rails Guides][2]) |
| Real-time UI       | **Hotwire** (Turbo Drive, Turbo Frames, Turbo Streams) + **Stimulus JS**      | SPA-level interactivity without a JS build step; ships with Rails 8 ([Medium][3])                                 |
| DB (dev/demo)      | **SQLite 3**                                                                  | Zero-config for workshops; switch to Postgres via `database.yml` when needed.                                     |
| Background jobs    | **Active Job + Solid Queue**                                                  | Database-backed job runner bundled with Rails 8 ([Ruby on Rails Guides][2])                                       |
| Auth & RBAC        | Devise, Pundit                                                                |                                                                                                                   |
| File & rich-text   | Active Storage, Action Text (Trix editor)                                     |                                                                                                                   |
| WebSockets         | Action Cable                                                                  |                                                                                                                   |
| Telephony (SMS / Voice reminders) | **Twilio Programmable SMS, Voice** (BAA-eligible) ([Paubox][4]) |                                                                                                                   |
| Payments           | **Stripe Checkout** (no PHI in metadata; Stripe won't sign BAA) ([Paubox][5]) |                                                                                                                   |
| Container & deploy | Docker + Kamal 2 (ships with Rails 8) ([InfoQ][6])                            |                                                                                                                   |

---

### 3 . Core Functional Scope

| Domain             | Key capabilities in MVP |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Patient portal** | Sign-up / login, appointment self-scheduling, intake questionnaires, visit summaries, invoices + pay-now, view problems/allergies/medications/lab results. |
| **Staff ops**      | Calendar view for all providers, create/edit/reschedule appointments, SMS or call reminders, insurance eligibility checks (manual/batch), insurance and authorization maintenance, patient record edits, check-in, provider schedule & location management, user provisioning. |
| **Provider UX**    | Personal day-sheet, Action Text SOAP note, ICD-10 selector, problem list & allergy/medication management, vitals entry, order entry (med / lab / imaging), lab result review, internal messaging (Turbo Streams). |
| **Revenue cycle**  | Claim object (status, charges, payer, denial reason), Stripe Checkout for self-pay, payment posting, authorization tracking, denial tracking, audit log, **fee schedule & payer contract management**. |
| **Reporting**      | Turbo-live operational dashboard; CSV exports for analytics; nightly SnapshotJob seeds de-identified copies for student data-engineering practice. |

---

### 4 . Domain Model (Active Record)

```
patients
  id, full_name, dob, email, phone, gender, address_json, 
  mrn, encrypted_ssn, primary_language, preferred_contact_method,
  created_at, updated_at

patient_insurances
  id, patient_id, insurance_type(enum: primary|secondary), 
  payer_name, policy_number, group_number, 
  subscriber_name, subscriber_dob, relationship_to_subscriber,
  copay_amount_cents, coinsurance_percentage,
  coverage_start_date, coverage_end_date,
  created_at, updated_at

staff                               # STI: Provider, Admin, FrontDesk
  id, type, full_name, role, encrypted_password, 
  npi, license_number, license_state, 
  specialties_json, board_certifications_json,
  created_at, updated_at

provider_schedules
  id, provider_id, day_of_week, start_time, end_time,
  location_id, is_available, created_at, updated_at

locations
  id, name, address_json, phone, fax,
  is_active, created_at, updated_at

appointments
  id, patient_id, provider_id, location_id,
  starts_at, duration_min, visit_type(enum),
  status(enum: scheduled|canceled|no_show), 
  reason,
  created_at, updated_at

encounters
  id, patient_id, provider_id, location_id, appointment_id,
  started_at, ended_at, visit_type(enum),
  status(enum: in_progress|completed|canceled),
  created_at, updated_at

problems
  id, patient_id, icd_code, description,
  status(enum: active|resolved|inactive),
  onset_date, resolved_date,
  created_at, updated_at

allergies
  id, patient_id, allergen, reaction,
  severity(enum: mild|moderate|severe),
  onset_date, created_at, updated_at

medications
  id, patient_id, name, dosage, frequency,
  route, start_date, end_date,
  prescribed_by_id, status(enum: active|discontinued),
  created_at, updated_at

vitals
  id, encounter_id, 
  blood_pressure_systolic, blood_pressure_diastolic,
  heart_rate, temperature, weight, height,
  oxygen_saturation, pain_scale,
  recorded_at, created_at, updated_at

lab_results
  id, encounter_id, test_name, test_code,
  result_value, result_unit, reference_range,
  status(enum: pending|final|amended),
  performed_at, created_at, updated_at

visit_notes
  id, encounter_id, author_id, signed_at,
  subjective, objective, assessment, plan,
  body (ActionText rich text),
  created_at, updated_at

diagnoses
  id, encounter_id, icd_code, description,
  status(enum: primary|secondary),
  created_at, updated_at

orders
  id, encounter_id, order_type(enum: medication|lab|imaging),
  status(enum: pending|completed|canceled),
  data_json, created_at, updated_at

authorizations
  id, patient_id, insurance_id, service_type,
  authorization_number, start_date, end_date,
  units_approved, status(enum: pending|approved|denied),
  created_at, updated_at

service_codes
  id, code_type(enum: CPT|HCPCS|internal), code, description, category,
  created_at, updated_at

fee_schedules
  id, name, description, is_default(boolean),
  created_at, updated_at

fee_schedule_items
  id, fee_schedule_id, service_code_id, charge_cents,
  created_at, updated_at

payers
  id, name, payer_identifier, address_json, phone,
  created_at, updated_at

payer_contracts
  id, payer_id, name, effective_date, expiration_date,
  created_at, updated_at

allowed_amounts
  id, payer_contract_id, service_code_id, allowed_cents,
  created_at, updated_at

claims
  id, encounter_id, patient_insurance_id, authorization_id,
  total_billed_cents, total_allowed_cents, total_paid_cents, total_adjustment_cents,
  payer_id, status(enum: draft|submitted|pending_payment|paid|denied|void),
  denial_code, denial_reason, submitted_at,
  created_at, updated_at

claim_line_items
  id, claim_id, service_code_id, diagnosis_pointer_json,
  billed_amount_cents, allowed_amount_cents, paid_amount_cents, adjustment_cents,
  units, modifier1, modifier2, modifier3, modifier4,
  created_at, updated_at

payments
  id, claim_id, patient_id, amount_cents,
  source(enum: stripe|insurance), external_id,
  received_at, created_at, updated_at

communication_logs
  id, patient_id, medium(enum: sms|voice),
  twilio_sid, direction, occurred_at,
  payload_json, created_at, updated_at

audit_logs
  id, user_id, action, auditable_type,
  auditable_id, diff_json, created_at

eligibility_checks
  id, patient_insurance_id, appointment_id, checked_at, checked_by_id,
  status(enum: pending|completed|error|no_response),
  coverage_status(enum: active|inactive|unknown|partial),
  edi_request_payload(text), edi_response_payload(text),
  parsed_response_json, notes(text),
  created_at, updated_at
```

*All PII at rest is on encrypted disk; optionally encrypt column-level with `attr_encrypted`.*

---

### 5 . Rails Structure & Conventions

```
app/
 ├─ models/          # 1:1 with tables above; concerns/ for mix-ins
 ├─ controllers/
 │    patients/, staff/, providers/, billing/, reports/, authorizations/
 │    patients/problems_controller.rb
 │    patients/allergies_controller.rb
 │    patients/medications_controller.rb
 │    patients/insurances_controller.rb
 │    encounters/vitals_controller.rb
 │    encounters/lab_results_controller.rb
 │    admin/locations_controller.rb
 │    admin/provider_schedules_controller.rb
 │    admin/staff_controller.rb
 │    encounters/diagnoses_controller.rb
 │    admin/service_codes_controller.rb
 │    admin/fee_schedules_controller.rb
 │    admin/fee_schedule_items_controller.rb
 │    admin/payers_controller.rb
 │    admin/payer_contracts_controller.rb
 │    admin/allowed_amounts_controller.rb
 │    webhooks/stripe_controller.rb
 │    webhooks/twilio_controller.rb
 ├─ views/
 │    appointments/_calendar.html.erb
 │    providers/visit_notes/_editor.html.erb
 │    patients/problems/_index.html.erb
 │    encounters/vitals/_form.html.erb
 │    ...
 ├─ javascript/
 │    controllers/   # Stimulus
 ├─ jobs/
 │    twilio_reminder_job.rb
 │    stripe_webhook_job.rb
 │    nightly_snapshot_job.rb
 │    lab_result_import_job.rb
 │    authorization_expiry_job.rb
 │    medication_refill_reminder_job.rb
 ├─ channels/
 │    appointment_channel.rb   # realtime lobby / waiting-room status
plugins/
 ├─ ai_examples/     # mountable Rails Engine stub for student work
```

*Hotwire guidelines:* use Turbo Frames around page regions (calendar cell, invoice panel), Turbo Streams for server-push (claim status, chat). No external build system—Import Maps manage JS modules.

---

### 6 . High-Level Routes (excerpt)

```rb
Rails.application.routes.draw do
  devise_for :patients, controllers: { registrations: "patients/registrations" }
  devise_for :staff

  resources :patients do
    resources :problems,     only: %i[index new create edit update destroy]
    resources :allergies,    only: %i[index new create edit update destroy]
    resources :medications,  only: %i[index new create edit update destroy]
    resources :insurances,   controller: "patient_insurances", only: %i[index new create edit update destroy]
  end

  resources :appointments do
    member do
      patch :check_in
    end
  end

  resources :encounters do
    member do
      patch :start
      patch :complete
    end
    resources :vitals,       only: %i[new create edit update]
    resources :lab_results,  only: %i[index show]
    resources :visit_notes,  only: %i[new create edit update show]
    resources :orders,       only: %i[index new create]
    resources :diagnoses,   only: %i[index create update destroy]
    resources :claims,       only: %i[show]
  end

  resources :authorizations, only: %i[index show create update]

  namespace :billing do
    resources :claims,    only: %i[index update]
    resources :payments,  only: %i[index create]
  end

  namespace :admin do
    resources :locations
    resources :provider_schedules
    resources :staff, except: %i[show]
    resources :service_codes
    resources :fee_schedules do
      resources :items, controller: "fee_schedule_items", as: :fee_schedule_items
    end
    resources :payers do
      resources :contracts, controller: "payer_contracts", as: :payer_contracts do
        resources :allowed_amounts
      end
    end
    resources :reports,      only: :index
    resources :audit_logs,   only: :index
  end

  # Webhooks
  post "/webhooks/stripe",  to: "webhooks/stripe#receive"
  post "/webhooks/twilio",  to: "webhooks/twilio#receive"
end
```

---

### 7 . Background & Real-Time Workflows

| Event                  | Mechanism                                                      | Flow                                                               |
| ---------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------ |
| Appointment booked     | `ActiveSupport::Notifications.instrument("appt.created", id:)` | `TwilioReminderJob` enqueued. `EligibilityCheckJob` enqueued.     |
| Insurance Eligibility  | `EligibilityCheckJob` (manual or batch via Solid Queue)        | Sends EDI 270 / API call → receives EDI 271 / API response → updates `eligibility_checks` table; UI updated for staff. |
| Vitals recorded        | `ActiveSupport::Notifications.instrument("vitals.recorded", encounter_id:)` | Broadcasts Turbo Stream to provider dashboard; may trigger alerts. |
| Lab result finalized   | `ActiveSupport::Notifications.instrument("lab_result.finalized", lab_result_id:)` | Notifies provider & patient; `LabResultImportJob` marks final.      |
| Authorization expiring | `AuthorizationExpiryJob` cron                                 | Flags soon-to-expire authorizations; emails billing team.           |
| Stripe payment success | Stripe webhook ⇒ `StripeWebhookJob`                            | Marks payment, broadcasts Turbo Stream to patient invoice list.    |
| AI extension (future)  | Plugin subscribes to `visit_note.signed`                       | Job fetches note text → summarizes → saves as `ai_summary` column. |

---

### 8 . Security & HIPAA Controls

* \*\*HTTPS enforced (`config.force_ssl`); HSTS via Nginx/Kamal).
* **Devise** session timeout + `devise-security` password rules.
* **Pundit** policies: strict per-role scope; patients can only read *their* records; separate policies for problems, allergies, medications, vitals, lab_results, and authorizations; admin role required for location & provider schedule CRUD.
* **AuditLogs** capture read & write events (use `audited` gem).
* **Solid Queue** job tables live in same encrypted DB; no Redis needed.
* Twilio integration restricted to BAA-eligible products (Programmable SMS, Voice) ([Paubox][4]).
* Stripe data limited to amount & invoice ID; no PHI passes to Stripe because it will not sign a BAA ([Paubox][5]).

---

### 9 . Development Timeline (12 Weeks)

| Sprint | Highlights |
| ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 ‡ 2  | Project bootstrap: `rails new swiftcare --database=sqlite3 --css=tailwind --skip-javascript` (Hotwire auto-enabled). Devise auth. |
| 3 ‡ 4  | Patient & staff portals; appointment CRUD + Turbo calendar; multi-location & provider schedule base. |
| 5 ‡ 6  | SMS reminder system; intake questionnaires; Action Text SOAP note. |
| 7 ‡ 8  | Problem/allergy/medication lists; vitals capture; diagnosis & order forms. |
| 9 ‡ 10 | Claims & payments; authorization & insurance UX; Solid Queue jobs. |
| 11     | Lab import + lab-result workflow; real-time dashboards with Turbo Streams; provider schedule UI. |
| 12     | Export & data-snapshot jobs; audits and admin reports; seed script with realistic fake data (Faker + FactoryBot); CI (RSpec + System tests). |

*(One full-time engineer or two student pairs can finish on schedule.)*

---

### 10 . Extension Interface for Students

* **Rails Engine template** (`rails plugin new ai_lab --mountable`).
* **Event hooks** via `ActiveSupport::Notifications`; documented list in `docs/events.md`.
* **Service accounts**: an `AI_Agent` staff record with token-based HTTP auth for internal APIs.
* **Sample plugin stubs**: speech-to-text summarizer, auto-coder, analytics chatbot—left empty for coursework.

---

### 11 . Deployment Cheat-Sheet

1. `kamal init swiftcare` – configure server IPs, Docker image, DB volume.
2. Provision TLS (Let's Encrypt) and point DNS.
3. `kamal setup && kamal deploy` → production up.
4. Set ENV secrets (`TWILIO_*`, `STRIPE_*`) via ` kamal env push`.
5. Run `rails db:migrate` and `solid_queue:start` daemon on host.

---

### 12 . Deliverables

* `swiftcare/` mono-repo with Rails 8 application, seed script, Dockerfile, Kamal config.
* Controllers for new resources: problems, allergies, medications, patient_insurances, vitals, lab_results, authorizations, locations, provider_schedules.
* `docs/` folder: database ERD (draw.io), event catalog, security checklist, onboarding guide, **Clinical Charting Guide**.
* Unit, model, and system test suite achieving ≥ 90 % coverage.

---

With this specification the engineering team can scaffold, build, and deploy a feature-complete, HIPAA-aware EMR built on Rails 8 and Hotwire—ready for students to extend with AI, automation, and analytics.

[1]: https://guides.rubyonrails.org/8_0_release_notes.html?utm_source=chatgpt.com "Ruby on Rails 8.0 Release Notes"
[2]: https://guides.rubyonrails.org/active_job_basics.html?utm_source=chatgpt.com "Active Job Basics - Ruby on Rails Guides"
[3]: https://medium.com/jungletronics/from-zero-to-hotwire-rails-8-e6cd16216165?utm_source=chatgpt.com "From Zero to Hotwire — Rails 8 - Medium"
[4]: https://www.paubox.com/blog/twilio-hipaa-compliant?utm_source=chatgpt.com "Is Twilio HIPAA compliant? (2025 update) - Paubox"
[5]: https://www.paubox.com/blog/stripe-hipaa-compliant?utm_source=chatgpt.com "Is Stripe HIPAA compliant? - Paubox"
[6]: https://www.infoq.com/news/2024/12/rails-8-released/?utm_source=chatgpt.com "Ruby on Rails 8.0 Released, Introduces Kamal 2 for Improved ..."
