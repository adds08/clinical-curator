import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/screens/secure_login_screen.dart';
import 'features/registration/screens/practitioner_registration_screen.dart';
import 'features/patient_dashboard/screens/patient_dashboard_screen.dart';
import 'features/medical_records/screens/medical_records_screen.dart';
import 'features/ambulance_services/screens/ambulance_services_screen.dart';
import 'features/profile/screens/profile_settings_screen.dart';
import 'features/doctor_schedule/screens/doctor_schedule_screen.dart';
import 'features/patient_directory/screens/patient_directory_screen.dart';
import 'features/clinical_report/screens/add_clinical_report_screen.dart';
import 'features/shared/widgets/scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final GlobalKey<NavigatorState> _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final GlobalKey<NavigatorState> _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');
final GlobalKey<NavigatorState> _shellNavigatorDKey = GlobalKey<NavigatorState>(debugLabel: 'shellD');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: <RouteBase>[
    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const SecureLoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) => const PractitionerRegistrationScreen(),
    ),

    // Stateful Nested Navigation Shell (Bottom Nav Bar)
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Tab 1: Dashboard
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/dashboard',
              builder: (BuildContext context, GoRouterState state) => const PatientDashboardScreen(),
              routes: [
                GoRoute(
                  path: 'doctor-schedule',
                  builder: (BuildContext context, GoRouterState state) => const DoctorScheduleScreen(),
                ),
                GoRoute(
                  path: 'patient-directory',
                  builder: (BuildContext context, GoRouterState state) => const PatientDirectoryScreen(),
                  routes: [
                    GoRoute(
                      path: 'add-clinical-report',
                      builder: (BuildContext context, GoRouterState state) => const AddClinicalReportScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 2: Records
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/records',
              builder: (BuildContext context, GoRouterState state) => const MedicalRecordsScreen(),
            ),
          ],
        ),

        // Tab 3: Services
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/services',
              builder: (BuildContext context, GoRouterState state) => const AmbulanceServicesScreen(),
            ),
          ],
        ),

        // Tab 4: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) => const ProfileSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
