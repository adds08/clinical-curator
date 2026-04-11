class RouteNames {
  RouteNames._();

  // Auth
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const signup = '/signup';
  static const register = '/register';

  // Patient
  static const patientHome = '/patient/home';
  static const patientRecords = '/patient/records';
  static const patientRecordsCardiovascular = '/patient/records/cardiovascular';
  static const patientServices = '/patient/services';
  static const patientAmbulance = '/patient/services/ambulance';
  static const patientAmbulanceConfirmation =
      '/patient/services/ambulance/confirmation';
  static const patientAmbulanceTracking =
      '/patient/services/ambulance/tracking';
  static const patientTelemedicine = '/patient/services/telemedicine';
  static const patientTelemedicineCall = '/patient/services/telemedicine/call';
  static const patientHealthTips = '/patient/services/health-tips';
  static const patientAlerts = '/patient/alerts';
  static const patientProfile = '/patient/profile';
  static const patientConsent = '/patient/profile/consent';

  // Doctor
  static const doctorHome = '/doctor/home';
  static const doctorPatients = '/doctor/patients';
  static const doctorPatientsAdd = '/doctor/patients/add';
  static const doctorPatientDetail = '/doctor/patients/:id';
  static const doctorRecords = '/doctor/records';
  static const doctorSchedule = '/doctor/schedule';
  static const doctorScheduleAdd = '/doctor/schedule/add';
  static const doctorServices = '/doctor/services';
  static const doctorAlerts = '/doctor/alerts';
  static const doctorProfile = '/doctor/profile';
  static const doctorClinicianSettings = '/doctor/profile/clinician-settings';

  // Admin
  static const adminVerifications = '/admin/verifications';
  static const adminVerificationDetail = '/admin/verifications/:id';
  static const adminFacilities = '/admin/facilities';
  static const adminHealthTips = '/admin/health-tips';

  // Root-level sub-pages (full-screen, no bottom nav)
  static const serviceAmbulance = '/service/ambulance';
  static const serviceAmbulanceConfirmation = '/service/ambulance/confirmation';
  static const serviceAmbulanceTracking = '/service/ambulance/tracking';
  static const serviceTelemedicine = '/service/telemedicine';
  static const serviceTelemedicineCall = '/service/telemedicine/call';
  static const serviceHealthTips = '/service/health-tips';
  static const consent = '/consent';
  static const clinicianSettings = '/clinician-settings';
  static const addPatient = '/add-patient';
  static const patientDetail = '/patient-detail/:id';
  static const scheduleEntry = '/schedule-entry';
  static const cardiovascular = '/cardiovascular';
  static const verificationDetail = '/verification/:id';
  static const notifications = '/notifications';

  // New service screens
  static const serviceHospitals = '/service/hospitals';
  static const serviceLabBooking = '/service/lab-booking';
  static const servicePharmacy = '/service/pharmacy';
  static const serviceInsurance = '/service/insurance';

  // Admin extended
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminAuditLog = '/admin/audit-log';
  static const adminRbac = '/admin/rbac';

  // Hospital detail
  static const hospitalDetail = '/hospital/:id';

  // Clinical workflows
  static const clinicalEncounters = '/clinical/encounters';
  static const clinicalStartEncounter = '/clinical/start-encounter';
  static const clinicalWorkspace = '/clinical/workspace/:id';
  static const clinicalSummary = '/clinical/summary/:id';
  static const clinicalAddCondition = '/clinical/add-condition/:encounterId';

  // Booking
  static const booking = '/booking';
  static const bookingDoctorSearch = '/booking/doctor-search';
  static const bookingDoctorProfile = '/booking/doctor/:id';
  static const bookingSlots = '/booking/slots/:practitionerId';
  static const bookingConfirm = '/booking/confirm';
  static const bookingSuccess = '/booking/success';
  static const bookingMyAppointments = '/booking/my-appointments';
  static const bookingAppointmentDetail = '/booking/appointment/:id';
  static const bookingReschedule = '/booking/reschedule/:id';
}
