# Clinician Manual

This guide covers the Doctor and Nurse experience in Clinical Curator — how
to register, what appears in Doctor View, and how to manage patients,
schedules, and consents day-to-day.

---

## Getting Verified

Only verified practitioners can access clinical data or accept consent
requests. Verification is a one-time admin review.

### Register as a practitioner

1. From the login or signup screen, tap **Register as Practitioner**.
2. Fill in the form:
   - Full legal name
   - Medical license number
   - Clear photo of your medical license
   - Specialization (e.g. General Practice, Cardiology, Pediatrics)
   - Affiliated facility
   - Years of experience
   - Contact details
3. Submit.

### What admin review involves

- An admin compares your license photo against the license number.
- They verify specialization and facility affiliation.
- You may be contacted for additional information.

### After approval

- You receive a notification that your practitioner account is verified.
- A **Doctor View** toggle appears in your Profile.
- You can switch between Patient View and Doctor View at any time.
- If rejected, you receive the reason and can reapply with corrections.

Until verified, consent sharing is restricted and a warning banner stays
visible at the top of the app.

---

## Switching to Doctor View

1. Go to **Profile** in the bottom navigation.
2. Tap the role toggle to switch to **Doctor View**.
3. The bottom navigation and home screen flip to the clinician layout —
   Dashboard, Patients, Schedule, Services, Alerts, Profile.

---

## Dashboard

The Doctor Dashboard gives you a clinical overview:

- **Statistics** — total patients, appointments today, pending consultations,
  completed visits.
- **Today's Schedule** — a timeline of upcoming appointments.
- **Patient Queue** — patients waiting for consultation, sorted by priority.
- **Quick Tools** — shortcuts for add patient, create prescription, view
  schedule.

---

## Patient Management

Open the **Patients** tab.

- **Directory** — a searchable list of all patients who have granted you
  access.
- **Search & filter** — by name, ID, condition, or last visit date.
- **Add Patient** — register a new patient:
  - Enter their details, or scan their QR consent code.
  - The patient must grant consent before you can access their records.

### Patient detail

Tap a patient to see their full profile:

- **Vitals** — latest heart rate, blood pressure, temperature, SpO₂.
- **Lab results** — recent findings with trend indicators.
- **Medications** — active prescriptions and medication history.
- **Visit history** — every consultation logged with this patient.
- **Notes** — add or review clinical notes. All note activity is audited.

---

## Encounters & Clinical Workflows

Clinical Curator models visits as FHIR R4 encounters. Each encounter has
six tabs: Chief Complaint, Vitals, Examination, Assessment, Plan, and
Summary.

1. Start an encounter from the dashboard or from a patient's profile.
2. Move through the tabs — data saved locally is synced when you have
   connectivity.
3. Close the encounter to generate a summary. The summary is shareable with
   the patient and appears in their records.

---

## Schedule

Open the **Schedule** tab.

- **Timesheet view** — your week and day at a glance.
- **Create availability** — add a date and time range; pick in-person or
  telemedicine; set recurrence if needed.
- **Manage appointments** — view, confirm, reschedule, or cancel bookings.
  Patients are notified automatically.

---

## Consent — clinician side

Patients control access, but here is what you see:

- Incoming consent requests appear as notifications. You accept or decline.
- Outgoing requests (when you scan a patient's QR) wait for patient
  approval.
- Revocations are instant — if a patient revokes, the patient disappears
  from your directory on next refresh.

If you act on a record without an active consent, the action is blocked and
logged.

---

## Clinician Settings

Profile > **Clinician Settings** contains clinician-only controls:

- **Facilities** — manage your affiliated healthcare facilities.
- **Notifications** — new patient requests, lab alerts, appointment
  changes.
- **Audit Log** — every action you take on patient records, for compliance
  and accountability.

---

## Offline & Sync

You can work without connectivity:

- Patient records you have viewed recently are cached.
- New encounter data, notes, and schedule changes queue locally and upload
  when you reconnect.
- Server copies win on conflict for clinical records — your local draft is
  preserved as a separate entry if it collides.
- Check the sync indicator in the top bar for current status.

---

## Safety & Audit

- Every action on a patient record is written to the audit log.
- Consent state is checked on every read and write — there is no bypass.
- If you suspect unauthorized access on your account, sign out immediately
  and contact support.
