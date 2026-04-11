# Clinical Curator -- User Guide

## Demo Login Credentials

| Email | Password | Role | What you can do |
|-------|----------|------|-----------------|
| `arjun@example.com` | `password123` | Patient | View health summary, medical records (labs, prescriptions, imaging, immunizations), services, profile |
| `sunita@example.com` | `password123` | Patient | Same as above; has critical vitals and a penicillin allergy in records |
| `arpan@example.com` | `password123` | Doctor | Toggle to Doctor View from Profile to see dashboard, manage patients, schedule, and clinician settings |
| `elena@example.com` | `password123` | Doctor | Same doctor features; Internal Medicine specialist |
| `anjali@example.com` | `password123` | Nurse | Toggle to practitioner view; ICU nursing |
| `bikesh@example.com` | `password123` | Doctor (pending) | Cannot toggle to Doctor View yet; awaiting admin verification |
| `admin@example.com` | `admin123` | Admin | Access admin panel to review and approve/reject practitioner registrations |

---

## 1. Getting Started

### Download and Install

1. Download the Clinical Curator app from the Google Play Store (Android) or Apple App Store (iOS).
2. Open the app and wait for the initial setup to complete.

### Create an Account

1. On the login screen, tap **Create Account**.
2. Fill in your details:
   - Full name
   - Email address
   - Phone number
   - Password (minimum 8 characters)
3. Accept the Terms of Service and Privacy Policy.
4. Tap **Sign Up** to create your account.
5. You will be redirected to the Patient Home screen.

### Login

1. Enter your registered email and password on the login screen.
2. Tap **Login**.
3. If your credentials are valid, you will be taken to your role-specific home screen (Patient, Doctor, or Admin).

---

## 2. Patient View

### Home Screen

The Patient Home screen provides an at-a-glance overview of your health:

- **Greeting section** -- Personalized welcome message with a notification bell.
- **Health Summary Card** -- Displays your latest vital signs:
  - Heart rate (bpm)
  - Blood pressure (mmHg)
  - Last updated timestamp
  - "View Details" link for full vitals history
- **Profile Completion** -- A progress bar showing how complete your profile is, with a prompt to add missing information (emergency contacts, insurance details).
- **Public Health Updates** -- Active health alerts in your area (e.g., dengue warnings, vaccination drives).
- **Medical Services Grid** -- Quick-access tiles for:
  - Medical Records
  - Find Hospitals
  - Telemedicine
  - Ambulance
  - Health Tips
  - Lab Booking
  - Pharmacy
  - Insurance

### Medical Records

Access your full medical history from the **Records** tab in the bottom navigation bar.

- **Browse Records** -- Scroll through a chronological list of all your medical records.
- **Filter by Type** -- Use the filter chips at the top to narrow results:
  - **Labs** -- Blood work, urinalysis, and other laboratory results
  - **Prescriptions** -- Current and past medication prescriptions
  - **Imaging** -- X-rays, MRI, CT scans, and other imaging reports
  - **Immunizations** -- Vaccination history and upcoming schedules
- **Record Cards** -- Each record shows the type, date, provider, and a brief summary. Tap a card to view full details.

### Cardiovascular Detail View

Tap on a cardiovascular-related record to see:

- Detailed heart rate and blood pressure trends
- ECG/EKG summaries (when available)
- Risk factor assessments
- Physician notes and recommendations

### Services

#### Ambulance Request

1. From the Services tab or Home screen, tap **Ambulance**.
2. **Request Form** -- Fill in:
   - Current location (auto-detected or manual entry)
   - Emergency type / reason
   - Patient condition description
   - Contact phone number
3. Tap **Submit Request** to proceed to the confirmation screen.
4. **Confirmation Screen** -- Review the request details and confirm.
5. **Tracking Screen** -- Once dispatched, track the ambulance in real time:
   - Estimated arrival time
   - Driver/paramedic information
   - Live status updates

#### Telemedicine

1. Tap **Telemedicine** from Services or the Home screen grid.
2. **Search Doctors** -- Browse or search for available practitioners by specialty, name, or availability.
3. **Book Appointment** -- Select a time slot and confirm the booking.
4. **Video Call** -- At the scheduled time, join the video consultation directly from the app:
   - Camera and microphone controls
   - Chat panel for sharing notes
   - End call button

#### Health Tips

1. Tap **Health Tips** from Services.
2. Browse curated health articles, tips, and wellness advice.
3. Content covers topics like nutrition, exercise, mental health, disease prevention, and seasonal health guidance.

### Profile

Access your profile from the **Profile** tab in the bottom navigation:

- **Account Settings** -- Update your name, email, phone number, and profile photo.
- **Language** -- Switch the app language.
- **Security** -- Change password, enable biometric login.
- **Notifications** -- Configure push notification preferences (appointment reminders, health alerts, lab results).
- **Consent Management** -- Manage which practitioners have access to your records (see Section 5).
- **Role Toggle** -- If you are also a verified practitioner, switch to Doctor View from here.

---

## 3. Registering as a Practitioner

### How to Register

1. From the login or signup screen, tap **Register as Practitioner**.
2. Complete the registration form:
   - Full legal name
   - Medical license number
   - License photo upload (clear image of your medical license)
   - Specialization (e.g., General Practice, Cardiology, Pediatrics)
   - Affiliated facility/hospital
   - Years of experience
   - Contact details
3. Submit the application.

### Admin Verification Process

After submission, your application enters the verification queue:

1. An admin reviews your submitted documents.
2. The admin checks your license photo against the provided license number.
3. The admin verifies your specialization and facility affiliation.
4. You may be contacted if additional information is needed.

### After Approval

- You will receive a notification that your practitioner account has been verified.
- A **Doctor View** toggle becomes available in your Profile settings.
- You can now switch between Patient View and Doctor View at any time.
- If rejected, you will receive a notification with the reason and can reapply with corrected information.

---

## 4. Doctor/Nurse View

### Switching to Doctor View

1. Go to **Profile** in the bottom navigation.
2. Tap the role toggle to switch to **Doctor View**.
3. The bottom navigation and home screen will change to the clinician layout.

### Dashboard

The Doctor Dashboard provides a clinical overview:

- **Statistics Cards** -- Quick counts for:
  - Total patients
  - Appointments today
  - Pending consultations
  - Completed visits
- **Today's Schedule** -- A timeline of upcoming appointments.
- **Patient Queue** -- Patients waiting for consultation, sorted by priority.
- **Quick Tools** -- Shortcuts to common actions (add patient, create prescription, view schedule).

### Patient Management

Access from the **Patients** tab in the bottom navigation:

- **Patient Directory** -- A searchable list of all your patients.
- **Search and Filter** -- Find patients by name, ID, condition, or last visit date.
- **Add Patient** -- Register a new patient to your care:
  - Enter patient details or scan their QR consent code
  - Patient must grant consent for you to access their records

### Patient Detail

Tap a patient in the directory to view their full profile:

- **Vitals** -- Latest heart rate, blood pressure, temperature, SpO2.
- **Lab Results** -- Recent laboratory findings with trend indicators.
- **Medications** -- Active prescriptions and medication history.
- **Visit History** -- Chronological log of all consultations with this patient.
- **Notes** -- Add or review clinical notes.

### Schedule

Access from the **Schedule** tab:

- **Timesheet View** -- See your weekly and daily schedule at a glance.
- **Create Availability** -- Add available time slots:
  - Select date and time range
  - Set consultation type (in-person, telemedicine)
  - Set recurring availability if needed
- **Manage Appointments** -- View, confirm, or reschedule booked appointments.

### Clinician Settings

Available from Profile > Clinician Settings:

- **Facilities** -- Manage your affiliated healthcare facilities.
- **Notifications** -- Configure clinical notification preferences (new patient requests, lab alerts, appointment changes).
- **Audit Log** -- View a log of all actions performed on patient records for compliance and accountability.

---

## 5. Consent Management

### Granting Access to Practitioners

1. Go to **Profile > Consent Management**.
2. Tap **Grant Access**.
3. Search for the practitioner by name or scan their QR code.
4. Select the scope of access:
   - Full medical records
   - Specific record types (labs, prescriptions, imaging, etc.)
   - Time-limited access
5. Confirm the consent grant.

### Revoking Access

1. In **Consent Management**, find the practitioner in your active consents list.
2. Tap the practitioner's entry.
3. Tap **Revoke Access**.
4. Confirm the revocation. The practitioner will immediately lose access to your records.

### Sharing via QR Code

1. In **Consent Management**, tap **Share via QR**.
2. A QR code is generated containing your consent token.
3. The practitioner scans this QR code from their app to request access.
4. You will receive a notification to approve or deny the request.

---

## 6. Offline Support

### How Offline Mode Works

Clinical Curator is built with an offline-first architecture:

- All critical data is cached locally using Hive CE on your device.
- When you open the app without an internet connection, you can still browse your medical records, view vitals, and access previously loaded data.

### Downloading Records for Offline

1. While connected to the internet, navigate to your Medical Records.
2. Records you view are automatically cached for offline access.
3. For bulk download, use the **Download for Offline** option in Settings to sync all records to your device.

### Syncing When Back Online

- When your device regains internet connectivity, the app automatically syncs:
  - Any locally created data (e.g., ambulance requests, appointment bookings) is uploaded.
  - New records from the server are downloaded.
  - Conflict resolution is handled automatically, with server data taking precedence for clinical records.
- A sync indicator in the top bar shows the current sync status.
