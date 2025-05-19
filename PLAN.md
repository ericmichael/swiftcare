# SwiftCare Clinic – AI Agent Development Roadmap (Inside-Out)

> Goal: Deliver the **MVP** described in `concept.md` through incremental, test-driven phases.  Each phase MUST pass the full test-suite & CI before the agent proceeds.

---

## Phase 1 — Project Bootstrap
- [x] `rails new swiftcare --database=sqlite3 --css=tailwind --skip-javascript`
- [x] Hotwire available by default in Rails 8
- [x] Configure **Minitest**, SimpleCov and Faker (StandardRB in place of RuboCop)
- [x] Initialize Git repo & CI running `bundle exec rails test && standard`
- [x] Green CI badge and empty home page

## Phase 2 — Core Schema & Models

### Phase 2.1 – Database Migrations
The initial schema is present. Each table below corresponds to a migration in
`db/migrate/20250519053331_create_core_schema.rb`.

#### Tables
- [x] patients
- [x] patient_insurances
- [x] staffs
- [x] provider_schedules
- [x] locations
- [x] appointments
- [x] encounters
- [x] problems
- [x] allergies
- [x] medications
- [x] vitals
- [x] lab_results
- [x] visit_notes
- [x] diagnoses
- [x] orders
- [x] authorizations
- [x] service_codes
- [x] fee_schedules
- [x] fee_schedule_items
- [x] payers
- [x] payer_contracts
- [x] allowed_amounts
- [x] claims
- [x] claim_line_items
- [x] payments
- [x] communication_logs
- [x] audit_logs
- [x] eligibility_checks

### Phase 2.2 – Model Basics
Every table has a matching model. Below is the status of validations, enums and
scopes for each model.

- [x] **Appointment** – enums `visit_type`, `status`; validates `starts_at` &
  `visit_type`.
- [x] **Patient** – `full_name` validation; includes `SoftDeletable` and
  `HasAddress` concerns.
- [x] **ProviderSchedule** – enum `day_of_week`; validates `day_of_week`.
- [x] **FeeSchedule** – validates `name`.
- [x] **Location** – includes `HasAddress`; validates `name`.
- [x] **PatientInsurance** – enum `insurance_type`; validates presence.
- [x] **ServiceCode** – enum `code_type`; validates `code`.
- [x] **Staff** – validates `full_name`.
- [x] **Allergy** – needs presence validation.
- [x] **AllowedAmount** – lacks validations.
- [x] **AuditLog** – lacks validations.
- [x] **Authorization** – needs validations.
- [x] **Claim** – needs validations.
- [x] **ClaimLineItem** – needs validations.
- [x] **CommunicationLog** – needs validations and direction enum.
- [x] **Diagnosis** – needs validations.
- [x] **EligibilityCheck** – needs validations.
- [x] **Encounter** – needs validations (dates/status).
- [x] **FeeScheduleItem** – needs validations.
- [x] **LabResult** – needs validations.
- [x] **Medication** – needs validations.
- [x] **Order** – needs validations.
- [x] **Payer** – add validations.
- [x] **PayerContract** – add validations.
- [x] **Payment** – add validations.
- [x] **Problem** – add validations.
- [x] **VisitNote** – add validations.
- [x] **Vital** – add validations.

### Phase 2.3 – Model Concerns
Reusable modules shared across models.

- [x] **SoftDeletable** – provides `active` scope and `soft_delete` method
- [x] **HasAddress** – adds `store_accessor` for address JSON fields
- [x] JSON serialization concern for structured fields

### Phase 2.4 – Model Tests
Existing tests cover only a few models. Expand until overall coverage exceeds
95 % with specs for every model.

- [x] **Appointment** – model tests
- [x] **Patient** – model tests
- [ ] **ProviderSchedule** – test `day_of_week` enum and validations
- [ ] **FeeSchedule** – test `name` validation
- [ ] **Location** – test address accessors and `name` validation
- [ ] **PatientInsurance** – test `insurance_type` enum
- [ ] **ServiceCode** – test `code` validation and `code_type` enum
- [ ] **Staff** – test `full_name` validation
- [ ] **Allergy** – test presence validation
- [ ] **AllowedAmount** – test validations
- [ ] **AuditLog** – test validations
- [ ] **Authorization** – test validations
- [ ] **Claim** – test validations
- [ ] **ClaimLineItem** – test validations
- [ ] **CommunicationLog** – test `direction` enum and validations
- [ ] **Diagnosis** – test validations
- [ ] **EligibilityCheck** – test validations
- [ ] **Encounter** – test status and date validations
- [ ] **FeeScheduleItem** – test validations
- [ ] **LabResult** – test validations
- [ ] **Medication** – test validations
- [ ] **Order** – test validations
- [ ] **Payer** – test validations
- [ ] **PayerContract** – test validations
- [ ] **Payment** – test validations
- [ ] **Problem** – test validations
- [ ] **VisitNote** – test validations
- [ ] **Vital** – test validations

### Phase 2.5 – Seeds
Database seeds currently create a clinic, a provider and sample patients with
appointments. Expand to cover every model with representative records.

- [x] **Location** – default clinic
- [x] **Staff** – provider and admin accounts
- [x] **Patient** – sample patients
- [x] **PatientInsurance** – primary insurance for each patient
- [x] **Appointment** – appointments linking patients and provider
- [x] **ProviderSchedule** – provider availability for the clinic
- [x] **FeeSchedule** – default schedule
- [x] **ServiceCode** – base procedure codes
- [x] **FeeScheduleItem** – charges for service codes
- [x] **Allergy** – example allergies
- [x] **AllowedAmount** – allowed amounts for contracts
- [x] **AuditLog** – audit log entries
- [x] **Authorization** – preauthorization records
- [x] **Claim** – sample claim
- [x] **ClaimLineItem** – line items for claim
- [x] **CommunicationLog** – SMS/voice logs
- [x] **Diagnosis** – sample diagnosis
- [x] **EligibilityCheck** – example eligibility check
- [x] **Encounter** – encounter for each appointment
- [x] **LabResult** – sample lab results
- [x] **Medication** – medication entries
- [x] **Order** – sample orders
- [x] **Payer** – sample payer
- [x] **PayerContract** – payer contract record
- [x] **Payment** – payment record
- [x] **Problem** – sample problem list
- [x] **VisitNote** – visit notes
- [x] **Vital** – baseline vital signs

### Phase 2.6 – ER Diagram
Generate an ER diagram artifact.

- [ ] Draw ER diagram (`docs/ERD.md` placeholder)

**Deliverables:** migrations and tests pass (`rails db:migrate && rails test`).

## Phase 3 — Authentication & Authorization Layer
### Phase 3.1 – Devise Setup
- [ ] Add `devise` gem and run installer
- [ ] Generate `Patient` and `Staff` Devise models
- [ ] Configure `Staff` STI for Provider/Admin/FrontDesk

### Phase 3.2 – Devise Security
- [ ] Include `devise-security` gem
- [ ] Enforce password expiry, history and complexity rules

### Phase 3.3 – Authorization via Pundit
- [ ] Create `ApplicationPolicy` base class
- [ ] Define policies and scopes for each model

### Phase 3.4 – Authentication & Policy Tests
- [ ] Request tests for login, signup and session timeout
- [ ] Policy tests for all roles and resources

**Deliverables:** passing specs; README section outlining available roles

## Phase 4 — Domain Controllers, Routes & Integration Tests
1. Scaffold RESTful controllers under proper namespaces (see Section 6 routes).
2. Wire routes exactly as in spec; ensure JSON + HTML formats.
3. Apply Pundit `authorize` & `policy_scope` in controllers.
4. Implement service objects for complex actions (e.g., `Appointments::Checker`).
5. Add **request/integration tests** for all happy/edge cases.
6. Deliverables: green test-suite; API schema (rswag or apipie).

## Phase 5 — Views & Hotwire UX
1. Build Turbo Frames/Streams views for calendars, dashboards, lists.
2. Create Stimulus controllers for dynamic behavior (e.g., ICD-10 autocomplete).
3. Style with Tailwind; add responsive layouts.
4. Accessibility audit (e.g., using `rails-a11y` gem with Minitest helpers).
5. Deliverables: screenshots/video of critical flows.

## Phase 6 — Smoke & System Tests
1. Write Capybara system tests (Minitest) covering:
   • Patient signup & appointment booking
   • Staff scheduling & check-in
   • Provider note entry & sign-off
2. Integrate Percy/Screencap for visual diffs (optional).
3. Ensure Solid Queue tables are migrated in test env.
4. Deliverables: CI running system tests headless.

## Phase 7 — Background Jobs & Real-Time Events
1. Implement Solid Queue workers for reminder, snapshot, lab import, etc.
2. Hook `ActiveSupport::Notifications` events; broadcast Turbo Streams.
3. Write job specs; use `ActiveJob::TestHelper`.
4. Deliverables: real-time update demo via Action Cable.

## Phase 8 — Admin & Reporting Modules
1. CRUD for fee schedules, payers, contracts, allowed amounts.
2. Turbo-live operational dashboard & CSV export endpoints.
3. Authorization: admin-only access enforced via Pundit.
4. Deliverables: sample reports CSV in `tmp/`.

## Phase 9 — External Integrations
1. **Stripe Checkout**
   • Create Payment model services.
   • Webhook controller & `StripeWebhookJob`.
   • Test in Stripe sandbox; stub in test env.
2. **Twilio SMS/Voice**
   • Implement `TwilioReminderJob`.
   • Webhook receiver; verify signature.
   • Test with Twilio dev phone numbers; stub in CI.
3. Update security checklist (HIPAA controls).
4. Deliverables: end-to-end flow diagram; BAA documentation links.

## Phase 10 — Deployment & Docs
1. Dockerfile & Kamal config (staging + prod).
2. `kamal deploy` smoke test script.
3. Write `docs/onboarding.md`, `docs/events.md`, `docs/security.md`.
4. Publish coverage badge ≥90 %.
5. Deliverables: production URL, onboarding guide.

---

### Execution Notes for the AI Agent
* Follow **test-driven development**: write failing spec ⇒ code ⇒ pass.
* After each phase, open PR → wait for human review before merging.
* Use **feature flags** for unfinished sub-components.
* Keep commits atomic, conventional (`feat(model): create Patient`).
* Maintain CHANGELOG.

---

### Critical Workflows by Persona (MVP)

**Patient**
• Account sign-up / login / profile management  
• Self-schedule, reschedule, or cancel appointments; view upcoming & past visits  
• Complete intake questionnaires pre-visit  
• Receive SMS / voice reminders and perform remote check-in  
• View visit summaries, lab results, invoices and **pay-now** via Stripe

**Front-Desk Staff**
• Manage provider calendars across locations (create / edit / cancel appointments)  
• Perform patient check-in / no-show / cancellation workflows  
• Trigger & review insurance eligibility checks (270/271)  
• Monitor real-time waiting-room status board  
• Review communication logs and send outbound SMS / voice calls

**Provider**
• View personal day-sheet dashboard  
• Start / complete encounters; record vitals  
• Compose SOAP note using Action Text editor & sign-off (locks note)  
• Add diagnoses and create medication / lab / imaging orders  
• Maintain problem list, allergies, and medications during visit

**Billing Specialist**
• Generate claims from completed encounters; add / edit line items  
• Submit claims and track statuses (draft → submitted → paid / denied)  
• Post payments, adjustments, and patient balances  
• Manage fee schedules, payer contracts, and allowed amounts  
• Import ERAs (835) and reconcile; export CSV reports

**Administrator / IT**
• Provision staff accounts & assign roles / locations  
• Configure provider schedules and clinic locations  
• Review audit logs & security reports  
• Manage feature flags and system defaults  
• Oversee data-snapshot, backup, and job queue health

These workflows will drive acceptance criteria for phases 4–8 and inform system & integration tests.

---

**End of Plan** 