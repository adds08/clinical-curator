import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_fhir_models/models/user_role.dart';
import '../../domain/providers/auth_provider.dart';
import '../../domain/providers/onboarding_provider.dart';
import '../../domain/providers/role_provider.dart';
import '../../features/shared/widgets/app_scaffold.dart';
import '../../features/shared/screens/services_hub_screen.dart';
import 'package:cc_core/router/route_names.dart';

// Auth
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/practitioner_registration_screen.dart';
// Patient
import '../../features/patient_home/screens/patient_home_screen.dart';
import '../../features/medical_records/screens/medical_records_screen.dart';
import '../../features/medical_records/screens/cardiovascular_detail_screen.dart';
// Doctor
import '../../features/doctor_dashboard/screens/doctor_dashboard_screen.dart';
import '../../features/patient_management/screens/patient_management_screen.dart';
import '../../features/patient_management/screens/add_patient_screen.dart';
import '../../features/patient_detail/screens/patient_detail_screen.dart';
// Schedule
import '../../features/doctor_schedule/screens/schedule_timesheet_screen.dart';
import '../../features/doctor_schedule/screens/schedule_entry_screen.dart';
// Services
import '../../features/ambulance/screens/ambulance_request_form_screen.dart';
import '../../features/ambulance/screens/ambulance_request_screen.dart';
import '../../features/ambulance/screens/ambulance_tracking_screen.dart';
import '../../features/health_tips/screens/health_tips_screen.dart';
import '../../features/telemedicine/screens/telemedicine_screen.dart';
import '../../features/telemedicine/screens/video_call_screen.dart';
// Profile
import '../../features/profile/screens/profile_settings_screen.dart';
import '../../features/profile/screens/clinician_settings_screen.dart';
// Help
import '../../features/help/screens/user_manual_screen.dart';
// Consent
import '../../features/consent/screens/consent_management_screen.dart';
// Admin features now live in apps/admin — no imports here.
// Notifications
import '../../features/notifications/screens/notifications_screen.dart';
// New service screens
import '../../features/hospitals/screens/hospitals_screen.dart';
import '../../features/lab_booking/screens/lab_booking_screen.dart';
import '../../features/pharmacy/screens/pharmacy_screen.dart';
import '../../features/insurance/screens/insurance_screen.dart';
// Admin extended routes also moved to apps/admin.
// Hospital detail
import '../../features/hospitals/screens/hospital_detail_screen.dart';
// Clinical workflows
import '../../features/clinical/screens/encounter_list_screen.dart';
import '../../features/clinical/screens/start_encounter_screen.dart';
import '../../features/clinical/screens/encounter_workspace_screen.dart';
import '../../features/clinical/screens/encounter_summary_screen.dart';
import '../../features/clinical/screens/add_condition_screen.dart';
// Patient Chart (EMR)
import '../../features/patient_chart/screens/patient_chart_screen.dart';
// Booking
import '../../features/booking/screens/booking_hub_screen.dart';
import '../../features/booking/screens/doctor_search_screen.dart';
import '../../features/booking/screens/doctor_profile_screen.dart';
import '../../features/booking/screens/slot_picker_screen.dart';
import '../../features/booking/screens/booking_confirmation_screen.dart';
import '../../features/booking/screens/booking_success_screen.dart';
import '../../features/booking/screens/my_appointments_screen.dart';
import '../../features/booking/screens/appointment_detail_screen.dart';
import '../../features/booking/screens/reschedule_screen.dart';
import '../../features/booking/screens/ai_triage_screen.dart';
// Onboarding
import '../../features/onboarding/screens/onboarding_screen.dart';

// ---------------------------------------------------------------------------
// Navigator keys
// ---------------------------------------------------------------------------
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final _patientHomeNavKey = GlobalKey<NavigatorState>(debugLabel: 'patientHome');
final _patientRecordsNavKey = GlobalKey<NavigatorState>(debugLabel: 'patientRecords');
final _patientServicesNavKey = GlobalKey<NavigatorState>(debugLabel: 'patientServices');
final _patientAlertsNavKey = GlobalKey<NavigatorState>(debugLabel: 'patientAlerts');
final _patientProfileNavKey = GlobalKey<NavigatorState>(debugLabel: 'patientProfile');

final _clinicianHomeNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianHome');
final _clinicianPatientsNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianPatients');
final _clinicianScheduleNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianSchedule');
final _clinicianServicesNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianServices');
final _clinicianAlertsNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianAlerts');
final _clinicianProfileNavKey = GlobalKey<NavigatorState>(debugLabel: 'clinicianProfile');

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final role = ref.watch(roleProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.login,
    refreshListenable: _RouterRefreshNotifier(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.isAuthenticated;
      final currentPath = state.matchedLocation;

      final isAuthRoute = currentPath == RouteNames.login || currentPath == RouteNames.signup || currentPath == RouteNames.register;
      final isOnboarding = currentPath == RouteNames.onboarding;

      if (!isAuthenticated && !isAuthRoute) return RouteNames.login;
      if (isAuthenticated && isAuthRoute) {
        final user = authState.user;
        final accountType = (user != null && user.activeRole.isPractitioner) ? 'practitioner' : 'patient';
        if (ref.read(onboardingProvider.notifier).shouldShowOnboarding(accountType)) {
          return RouteNames.onboarding;
        }
        return _homeForRole(role);
      }
      if (isOnboarding && !isAuthenticated) return RouteNames.login;
      return null;
    },
    routes: <RouteBase>[
      // ─── Auth (no shell) ───────────────────────────────────────────
      GoRoute(path: RouteNames.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: RouteNames.signup, builder: (_, _) => const SignupScreen()),
      GoRoute(path: RouteNames.register, builder: (_, _) => const PractitionerRegistrationScreen()),

      // ─── Onboarding ───────────────────────────────────────────────
      GoRoute(path: RouteNames.onboarding, builder: (_, _) => const OnboardingScreen()),

      // ─── Full-screen sub-pages (no bottom nav) ────────────────────
      // These push on top of the shell, showing their own back-button AppBar.

      // Ambulance flow
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/ambulance', builder: (_, _) => const AmbulanceRequestFormScreen()),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/ambulance/confirmation',
        builder: (_, _) => const AmbulanceRequestScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/ambulance/tracking',
        builder: (_, _) => const AmbulanceTrackingScreen(),
      ),
      // Telemedicine
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/telemedicine', builder: (_, _) => const TelemedicineScreen()),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/telemedicine/call',
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return VideoCallScreen(practitionerName: q['name'], specialty: q['specialty']);
        },
      ),
      // Health Tips
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/health-tips', builder: (_, _) => const HealthTipsScreen()),
      // Consent
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/consent', builder: (_, _) => const ConsentManagementScreen()),
      // Clinician settings
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/clinician-settings', builder: (_, _) => const ClinicianSettingsScreen()),
      // User manual (in-app markdown docs)
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: RouteNames.userManual, builder: (_, _) => const UserManualScreen()),
      // Add patient
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/add-patient', builder: (_, _) => const AddPatientScreen()),
      // Patient detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/patient-detail/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return PatientDetailScreen(patientId: id);
        },
      ),
      // Schedule entry
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/schedule-entry', builder: (_, _) => const ScheduleEntryScreen()),
      // Cardiovascular detail
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/cardiovascular', builder: (_, _) => const CardiovascularDetailScreen()),
      // Verification detail moved to apps/admin.
      // New service screens
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/hospitals', builder: (_, _) => const HospitalsScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/lab-booking', builder: (_, _) => const LabBookingScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/pharmacy', builder: (_, _) => const PharmacyScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/service/insurance', builder: (_, _) => const InsuranceScreen()),

      // Admin routes live in apps/admin (separate binary).
      // Hospital detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/hospital/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return HospitalDetailScreen(organizationId: id);
        },
      ),

      // ─── EMR: Patient Chart ──────────────────────────────────────
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/patient-chart/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return PatientChartScreen(patientId: id);
        },
      ),

      // ─── Clinical workflows (full-screen, no bottom nav) ─────────
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/clinical/encounters', builder: (_, _) => const EncounterListScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/clinical/start-encounter', builder: (_, _) => const StartEncounterScreen()),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinical/workspace/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return EncounterWorkspaceScreen(encounterId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinical/summary/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return EncounterSummaryScreen(encounterId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinical/add-condition/:encounterId',
        builder: (_, state) {
          final encounterId = state.pathParameters['encounterId'] ?? '';
          return AddConditionScreen(encounterFhirId: encounterId);
        },
      ),

      // ─── Booking flow (full-screen, no bottom nav) ─────────────────
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking', builder: (_, _) => const BookingHubScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking/doctor-search', builder: (_, _) => const DoctorSearchScreen()),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/doctor/:id',
        builder: (_, state) {
          final id = Uri.decodeComponent(state.pathParameters['id'] ?? '');
          return DoctorProfileScreen(practitionerRef: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/slots/:practitionerId',
        builder: (_, state) {
          final id = Uri.decodeComponent(state.pathParameters['practitionerId'] ?? '');
          return SlotPickerScreen(practitionerRef: id);
        },
      ),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking/confirm', builder: (_, _) => const BookingConfirmationScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking/success', builder: (_, _) => const BookingSuccessScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking/my-appointments', builder: (_, _) => const MyAppointmentsScreen()),
      GoRoute(parentNavigatorKey: _rootNavigatorKey, path: '/booking/ai-triage', builder: (_, _) => const AiTriageScreen()),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/appointment/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return AppointmentDetailScreen(appointmentKey: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/reschedule/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return RescheduleScreen(appointmentKey: id);
        },
      ),

      // ─── Patient shell (bottom nav) ───────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _patientHomeNavKey,
            routes: [GoRoute(path: RouteNames.patientHome, builder: (_, _) => const PatientHomeScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _patientRecordsNavKey,
            routes: [GoRoute(path: RouteNames.patientRecords, builder: (_, _) => const MedicalRecordsScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _patientServicesNavKey,
            routes: [GoRoute(path: RouteNames.patientServices, builder: (_, _) => const ServicesHubScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _patientAlertsNavKey,
            routes: [GoRoute(path: RouteNames.patientAlerts, builder: (_, _) => const NotificationsScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _patientProfileNavKey,
            routes: [GoRoute(path: RouteNames.patientProfile, builder: (_, _) => const ProfileSettingsScreen())],
          ),
        ],
      ),

      // ─── Doctor shell (bottom nav) ────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _clinicianHomeNavKey,
            routes: [GoRoute(path: RouteNames.clinicianHome, builder: (_, _) => const DoctorDashboardScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _clinicianPatientsNavKey,
            routes: [GoRoute(path: RouteNames.clinicianPatients, builder: (_, _) => const PatientManagementScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _clinicianScheduleNavKey,
            routes: [GoRoute(path: RouteNames.clinicianSchedule, builder: (_, _) => const ScheduleTimesheetScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _clinicianServicesNavKey,
            routes: [GoRoute(path: RouteNames.clinicianServices, builder: (_, _) => const ServicesHubScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _clinicianAlertsNavKey,
            routes: [GoRoute(path: RouteNames.clinicianAlerts, builder: (_, _) => const NotificationsScreen())],
          ),
          StatefulShellBranch(
            navigatorKey: _clinicianProfileNavKey,
            routes: [GoRoute(path: RouteNames.clinicianProfile, builder: (_, _) => const ProfileSettingsScreen())],
          ),
        ],
      ),

      // Admin shell removed — see apps/admin for verification, facilities,
      // health-tips, dashboard, users, audit-log, RBAC routes.
    ],
  );
});

String _homeForRole(UserRole role) {
  switch (role) {
    case UserRole.patient:
      return RouteNames.patientHome;
    case UserRole.clinician:
      return RouteNames.clinicianHome;
    // Admin users belong to apps/admin; if one logs in here, fall back to login.
    case UserRole.admin:
      return RouteNames.login;
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
    ref.listen(roleProvider, (_, _) => notifyListeners());
  }
}
