import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/user_role.dart';
import '../../domain/providers/auth_provider.dart';
import '../../domain/providers/onboarding_provider.dart';
import '../../domain/providers/role_provider.dart';
import '../../features/shared/widgets/app_scaffold.dart';
import '../../features/shared/screens/services_hub_screen.dart';
import 'route_names.dart';

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
// Consent
import '../../features/consent/screens/consent_management_screen.dart';
// Admin
import '../../features/admin/screens/admin_panel_screen.dart';
import '../../features/admin/screens/verification_detail_screen.dart';
import '../../features/admin/screens/manage_organizations_screen.dart';
import '../../features/admin/screens/manage_health_tips_screen.dart';
// Notifications
import '../../features/notifications/screens/notifications_screen.dart';
// New service screens
import '../../features/hospitals/screens/hospitals_screen.dart';
import '../../features/lab_booking/screens/lab_booking_screen.dart';
import '../../features/pharmacy/screens/pharmacy_screen.dart';
import '../../features/insurance/screens/insurance_screen.dart';
// Admin extended
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/manage_users_screen.dart';
import '../../features/admin/screens/audit_log_screen.dart';
import '../../features/admin/screens/manage_rbac_screen.dart';
// Hospital detail
import '../../features/hospitals/screens/hospital_detail_screen.dart';
// Clinical workflows
import '../../features/clinical/screens/encounter_list_screen.dart';
import '../../features/clinical/screens/start_encounter_screen.dart';
import '../../features/clinical/screens/encounter_workspace_screen.dart';
import '../../features/clinical/screens/encounter_summary_screen.dart';
import '../../features/clinical/screens/add_condition_screen.dart';
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

final _doctorHomeNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorHome');
final _doctorPatientsNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorPatients');
final _doctorScheduleNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorSchedule');
final _doctorServicesNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorServices');
final _doctorAlertsNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorAlerts');
final _doctorProfileNavKey = GlobalKey<NavigatorState>(debugLabel: 'doctorProfile');

final _adminVerificationsNavKey = GlobalKey<NavigatorState>(debugLabel: 'adminVerifications');
final _adminFacilitiesNavKey = GlobalKey<NavigatorState>(debugLabel: 'adminFacilities');
final _adminHealthTipsNavKey = GlobalKey<NavigatorState>(debugLabel: 'adminHealthTips');

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

      final isAuthRoute = currentPath == RouteNames.login ||
          currentPath == RouteNames.signup ||
          currentPath == RouteNames.register;
      final isOnboarding = currentPath == RouteNames.onboarding;

      if (!isAuthenticated && !isAuthRoute) return RouteNames.login;
      if (isAuthenticated && isAuthRoute) {
        final user = authState.user;
        final accountType = (user != null &&
                (user.activeRole == UserRole.doctor ||
                    user.activeRole == UserRole.nurse))
            ? 'practitioner'
            : 'patient';
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
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: RouteNames.signup, builder: (_, __) => const SignupScreen()),
      GoRoute(path: RouteNames.register, builder: (_, __) => const PractitionerRegistrationScreen()),

      // ─── Onboarding ───────────────────────────────────────────────
      GoRoute(path: RouteNames.onboarding, builder: (_, __) => const OnboardingScreen()),

      // ─── Full-screen sub-pages (no bottom nav) ────────────────────
      // These push on top of the shell, showing their own back-button AppBar.

      // Ambulance flow
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/ambulance',
        builder: (_, __) => const AmbulanceRequestFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/ambulance/confirmation',
        builder: (_, __) => const AmbulanceRequestScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/ambulance/tracking',
        builder: (_, __) => const AmbulanceTrackingScreen(),
      ),
      // Telemedicine
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/telemedicine',
        builder: (_, __) => const TelemedicineScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/telemedicine/call',
        builder: (_, __) => const VideoCallScreen(),
      ),
      // Health Tips
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/health-tips',
        builder: (_, __) => const HealthTipsScreen(),
      ),
      // Consent
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/consent',
        builder: (_, __) => const ConsentManagementScreen(),
      ),
      // Clinician settings
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinician-settings',
        builder: (_, __) => const ClinicianSettingsScreen(),
      ),
      // Add patient
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-patient',
        builder: (_, __) => const AddPatientScreen(),
      ),
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/schedule-entry',
        builder: (_, __) => const ScheduleEntryScreen(),
      ),
      // Cardiovascular detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/cardiovascular',
        builder: (_, __) => const CardiovascularDetailScreen(),
      ),
      // Verification detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/verification/:id',
        builder: (_, __) => const VerificationDetailScreen(),
      ),
      // New service screens
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/hospitals',
        builder: (_, __) => const HospitalsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/lab-booking',
        builder: (_, __) => const LabBookingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/pharmacy',
        builder: (_, __) => const PharmacyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/service/insurance',
        builder: (_, __) => const InsuranceScreen(),
      ),

      // ─── Admin extended (full-screen, no bottom nav) ────────────
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/dashboard',
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/users',
        builder: (_, __) => const ManageUsersScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/audit-log',
        builder: (_, __) => const AuditLogScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/admin/rbac',
        builder: (_, __) => const ManageRbacScreen(),
      ),
      // Hospital detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/hospital/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return HospitalDetailScreen(organizationId: id);
        },
      ),

      // ─── Clinical workflows (full-screen, no bottom nav) ─────────
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinical/encounters',
        builder: (_, __) => const EncounterListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/clinical/start-encounter',
        builder: (_, __) => const StartEncounterScreen(),
      ),
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
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking',
        builder: (_, __) => const BookingHubScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/doctor-search',
        builder: (_, __) => const DoctorSearchScreen(),
      ),
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
          final id = Uri.decodeComponent(
              state.pathParameters['practitionerId'] ?? '');
          return SlotPickerScreen(practitionerRef: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/confirm',
        builder: (_, __) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/success',
        builder: (_, __) => const BookingSuccessScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking/my-appointments',
        builder: (_, __) => const MyAppointmentsScreen(),
      ),
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
        builder: (_, __, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _patientHomeNavKey,
            routes: [
              GoRoute(path: RouteNames.patientHome, builder: (_, __) => const PatientHomeScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _patientRecordsNavKey,
            routes: [
              GoRoute(path: RouteNames.patientRecords, builder: (_, __) => const MedicalRecordsScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _patientServicesNavKey,
            routes: [
              GoRoute(path: RouteNames.patientServices, builder: (_, __) => const ServicesHubScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _patientAlertsNavKey,
            routes: [
              GoRoute(path: RouteNames.patientAlerts, builder: (_, __) => const NotificationsScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _patientProfileNavKey,
            routes: [
              GoRoute(path: RouteNames.patientProfile, builder: (_, __) => const ProfileSettingsScreen()),
            ],
          ),
        ],
      ),

      // ─── Doctor shell (bottom nav) ────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _doctorHomeNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorHome, builder: (_, __) => const DoctorDashboardScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _doctorPatientsNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorPatients, builder: (_, __) => const PatientManagementScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _doctorScheduleNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorSchedule, builder: (_, __) => const ScheduleTimesheetScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _doctorServicesNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorServices, builder: (_, __) => const ServicesHubScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _doctorAlertsNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorAlerts, builder: (_, __) => const NotificationsScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _doctorProfileNavKey,
            routes: [
              GoRoute(path: RouteNames.doctorProfile, builder: (_, __) => const ProfileSettingsScreen()),
            ],
          ),
        ],
      ),

      // ─── Admin shell ──────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _adminVerificationsNavKey,
            routes: [
              GoRoute(path: RouteNames.adminVerifications, builder: (_, __) => const AdminPanelScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminFacilitiesNavKey,
            routes: [
              GoRoute(path: RouteNames.adminFacilities, builder: (_, __) => const ManageOrganizationsScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminHealthTipsNavKey,
            routes: [
              GoRoute(path: RouteNames.adminHealthTips, builder: (_, __) => const ManageHealthTipsScreen()),
            ],
          ),
        ],
      ),
    ],
  );
});

String _homeForRole(UserRole role) {
  switch (role) {
    case UserRole.patient: return RouteNames.patientHome;
    case UserRole.doctor:
    case UserRole.nurse: return RouteNames.doctorHome;
    case UserRole.admin: return RouteNames.adminVerifications;
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
    ref.listen(roleProvider, (_, _) => notifyListeners());
  }
}
