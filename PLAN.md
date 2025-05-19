# SwiftCare Clinic – AI Agent Development Roadmap (Inside-Out)

> Goal: Deliver the **MVP** described in `concept.md` through incremental, test-driven phases.  Each phase MUST pass the full test-suite & CI before the agent proceeds.

---

## Phase 1 — Project Bootstrap
1. `rails new swiftcare --database=sqlite3 --css=tailwind --skip-javascript`
2. Add Hotwire (already default in Rails 8).
3. Configure **Minitest** (Rails default), SimpleCov, Faker (for seeds), RuboCop.
4. Initialize Git repo, CI (GitHub Actions) running `bundle exec rails test && rubocop`.
5. Deliverables: green CI badge, empty home page.

## Phase 2 — Core Schema & Models
1. Create migrations for **all tables** listed in Section 4 of `concept.md`.
2. Implement ActiveRecord models with:
   • associations
   • enums / value objects
   • validations (presence, formats, numericality)
3. Add model concerns for soft-delete, JSON serialization, etc.
4. Write **model tests** (≥95 % coverage) using Rails fixtures.
5. Seed realistic fake data (`db/seeds.rb`).
6. Deliverables: `rails db:migrate && rails test` passes; ER diagram artifact.

## Phase 3 — Authentication & Authorization Layer
1. Install Devise for Patient & Staff (`Staff` STI for Provider/Admin/FrontDesk).
2. Add `devise-security` rules (password expiry, history, complexity).
3. Implement Pundit policies/scopes for each model (strict *least-privilege*).
4. Write policy tests + request/integration tests for auth flows (login, signup, session timeout).
5. Deliverables: passing specs, README section on roles.

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