# Feature 08 — Appointment Booking

## Overview

Implement the flexible 3-path appointment booking flow: direct doctor search, hospital-first search, and AI triage-assisted booking (placeholder). Build the complete booking wizard from search through confirmation, plus patient appointment management (view, reschedule, cancel).

### Key Design Decision: Flexible Doctor-Institution Relationship

A doctor can treat patients at **multiple institutions**. The booking flow reflects this:
- When booking with a doctor, the patient selects which institution the appointment is at
- During follow-ups, the institution can change (same doctor, different facility)
- Referrals are a **separate flow**: the referring doctor creates a `ServiceRequest` (FHIR) pointing to the recommended specialty/doctor. The patient then books with the referred doctor through the normal booking flow. The `ServiceRequest` links the referral chain.

## Dependencies

- Feature 06 (Hospital Management) — hospital data for hospital-first booking path
- Feature 07 (Clinical Workflows) — encounters linked to completed appointments

## What Already Exists

### Data Layer
- `lib/data/collections/appointment_collection.dart` — `AppointmentLocal` (TypeId 3) with fields: fhirId, patientRef, practitionerRef, practitionerName, patientName, appointmentType, status, scheduledAt, durationMinutes, specialty, notes, syncStatus
- `lib/data/collections/schedule_slot_collection.dart` — `ScheduleSlotLocal` (TypeId 4)

### Providers
- `lib/domain/providers/appointment_provider.dart` — `AppointmentNotifier` with `book()`, `cancel()`, `complete()`, list methods, upcoming/past filters
- `lib/domain/providers/schedule_provider.dart` — schedule slot management

### Existing Screens
- `lib/features/doctor_schedule/screens/schedule_timesheet_screen.dart` — doctor's schedule view with date picker, hours summary, agenda blocks
- `lib/features/doctor_schedule/screens/schedule_entry_screen.dart` — create availability slots with duration, buffer time, live preview

### Server Endpoints
- `clinical_curator_server/lib/src/endpoints/appointment_endpoint.dart` — appointment CRUD
- `clinical_curator_server/lib/src/endpoints/schedule_endpoint.dart` — schedule management

### Services Hub
- `lib/features/shared/screens/services_hub_screen.dart` — patient services grid (entry point for booking)

## What Needs to Be Built

### 1. Booking Hub Screen — `lib/features/booking/screens/booking_hub_screen.dart` (new)

Entry point with 3 booking paths:
- **"Find a Doctor"** — search by name, specialty, availability → direct booking
- **"Find a Hospital"** — search hospitals → browse their doctors → book
- **"Describe Symptoms"** — AI triage placeholder (Feature 10) → recommended specialty → find doctor

Each path is a large tappable card with icon, title, and description.

### 2. Doctor Search Screen — `lib/features/booking/screens/doctor_search_screen.dart` (new)

Search and filter practitioners:
- **Search bar:** Name search
- **Filter chips:** Specialty (Cardiology, Pediatrics, General Medicine, etc.), Gender, Availability (today, this week), Telemedicine available
- **Sort:** By name, rating, nearest location
- **Results:** Doctor cards with photo, name, specialty, qualifications, organization, next available slot, rating
- Tap card → doctor profile screen

### 3. Doctor Profile Screen — `lib/features/booking/screens/doctor_profile_screen.dart` (new)

Practitioner detail for booking:
- Profile header: photo, name, specialty, qualifications, experience
- **Institutions list:** All organizations this doctor practices at (via PractitionerRole). Patient selects which institution for this appointment.
- Available slots: calendar date picker → time slots for selected date (filtered by selected institution)
- Reviews/ratings (mock data initially)
- "Book Appointment" CTA → slot picker

### 4. Slot Picker Screen — `lib/features/booking/screens/slot_picker_screen.dart` (new)

Calendar-based slot selection:
- Calendar view (date picker) showing days with available slots
- Time slot grid for selected date (morning, afternoon, evening sections)
- Slot card: start time, duration, appointment type (in-person/telemedicine)
- Slot availability indicator (available/few remaining/full)
- Select slot → booking confirmation

Uses `SlotLocal` (TypeId 20) for granular time management:
- Slot availability calculation: `maxPatients - bookedCount`
- Real-time slot status updates

### 5. Booking Confirmation Screen — `lib/features/booking/screens/booking_confirmation_screen.dart` (new)

Review and confirm:
- Doctor info: name, specialty, organization
- Appointment details: date, time, duration, type
- Patient info: name, health ID
- Reason for visit: free text input
- Payment summary (if applicable — links to Feature 09 payment)
- "Confirm Booking" button → creates `AppointmentLocal`

### 6. Booking Success Screen — `lib/features/booking/screens/booking_success_screen.dart` (new)

Post-booking confirmation:
- Success animation/icon
- Appointment summary card
- "Add to Calendar" button
- "View My Appointments" link
- "Book Another" link

### 7. Hospital-First Booking Flow

Extends existing `hospitals_screen.dart`:
- From hospital list → tap hospital → hospital detail (Feature 06)
- From hospital detail → "Book Appointment" → filtered doctor search (only doctors at this hospital)
- Reuses doctor search/profile/slot picker screens with hospital filter pre-applied

### 7b. Referral Flow

When a doctor refers a patient:
- Referring doctor creates a `ServiceRequest` (via Feature 07 clinical workflows) with:
  - `intent: order`, `category: referral`
  - Recommended specialty and/or specific practitioner
  - Reason for referral, clinical notes
- Patient receives a notification about the referral
- Patient's "My Appointments" screen shows a "Pending Referral" card with "Book Now" action
- Tapping "Book Now" opens doctor search **pre-filtered** by the referred specialty/doctor
- Completed referral booking links back to the original `ServiceRequest`

### 7c. Follow-Up with Institution Change

- When rebooking with the same doctor, the institution picker defaults to the previous institution
- Patient can change institution if the doctor practices at multiple facilities
- Appointment record stores both `practitionerRef` and `organizationRef` to track where treatment occurs

### 8. My Appointments Screen — `lib/features/booking/screens/my_appointments_screen.dart` (new)

Patient's appointment management:
- Tabs: Upcoming, Past, Cancelled
- Appointment card: doctor name, specialty, date/time, status badge, organization
- Tap → appointment detail screen
- Status: booked, confirmed, checked-in, completed, cancelled, no-show

### 9. Appointment Detail Screen — `lib/features/booking/screens/appointment_detail_screen.dart` (new)

Full appointment detail:
- Doctor info with contact
- Date, time, duration, location
- Reason for visit, notes
- Status timeline (booked → confirmed → checked-in → completed)
- Actions: Reschedule, Cancel, Start Video Call (if telemedicine)

### 10. Reschedule Screen — `lib/features/booking/screens/reschedule_screen.dart` (new)

Change appointment time:
- Show current appointment details
- Slot picker for new date/time (reuse slot picker component)
- Confirm reschedule → updates `AppointmentLocal` status and scheduled time

### 11. New Providers — `lib/domain/providers/`

| File | Purpose |
|------|---------|
| `booking_flow_provider.dart` (new) | Multi-step booking wizard state (selected doctor, slot, appointment type) |
| `doctor_search_provider.dart` (new) | Search/filter practitioners by name, specialty, availability, organization |
| `slot_availability_provider.dart` (new) | Available slots by practitioner and date, slot booking count |

### 12. Navigation Updates

Add routes:
- `/patient/booking` — booking hub
- `/patient/booking/doctor-search` — doctor search
- `/patient/booking/doctor/:id` — doctor profile
- `/patient/booking/slots/:practitionerId` — slot picker
- `/patient/booking/confirm` — booking confirmation
- `/patient/booking/success` — booking success
- `/patient/appointments` — my appointments
- `/patient/appointments/:id` — appointment detail
- `/patient/appointments/:id/reschedule` — reschedule

Entry points:
- Patient services hub → "Book Appointment" → booking hub
- Patient home → upcoming appointment card → appointment detail

## Implementation Order

1. Create `booking_flow_provider.dart` for wizard state
2. Create `doctor_search_provider.dart` and `slot_availability_provider.dart`
3. Create `booking_hub_screen.dart`
4. Create `doctor_search_screen.dart` with filters
5. Create `doctor_profile_screen.dart`
6. Create `slot_picker_screen.dart` with calendar
7. Create `booking_confirmation_screen.dart`
8. Create `booking_success_screen.dart`
9. Create `my_appointments_screen.dart` with tabs
10. Create `appointment_detail_screen.dart` with actions
11. Create `reschedule_screen.dart`
12. Update router with booking routes
13. Link from services hub and patient home

## Acceptance Criteria

- [ ] Patient can book appointment via doctor search path (search → profile → slots → confirm → success)
- [ ] Patient can book via hospital-first path (hospital → doctor → slots → confirm)
- [ ] AI triage path shows placeholder with "Coming Soon" message
- [ ] Slot availability reflects actual booked counts
- [ ] Patient can view upcoming and past appointments
- [ ] Patient can reschedule an appointment (new slot selection)
- [ ] Patient can cancel an appointment (status update)
- [ ] Doctor sees booked appointments on schedule timesheet
- [ ] Booking creates `AppointmentLocal` record with proper references
- [ ] Slot availability updates after booking (decrements available count)
- [ ] 3-path hub UI renders correctly with large cards

## FHIR Compliance Notes

- **Appointment** — scheduled healthcare event between patient and practitioner
- **Slot** — available time periods for booking (status: free, busy, busy-unavailable)
- **Schedule** — overall schedule containing slots
- **PractitionerRole** — used to find practitioners at specific organizations

The booking flow creates `Appointment` FHIR resources with proper references to Patient, Practitioner, Location, and linked Slot.

## Mock Data Requirements

- Extend existing schedule slots to include bookable time slots for demo doctors
- Add `SlotLocal` records for next 7 days (mix of free, busy, busy-unavailable)
- Ensure demo doctors have `PractitionerRole` records linking them to organizations
- Add mock reviews/ratings data for doctor profiles

## Complexity Estimate

**High** — multi-step wizard flow with search/filter, calendar UI, and state management across screens. The 3-path booking hub and slot management add architectural complexity. However, the data layer (`AppointmentLocal`, `ScheduleSlotLocal`) already exists.
