import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

// Screens
import 'features/patient_dashboard/screens/patient_dashboard_screen.dart';
import 'features/medical_records/screens/medical_records_screen.dart';
import 'features/doctor_schedule/screens/doctor_schedule_screen.dart';
import 'features/patient_directory/screens/patient_directory_screen.dart';
import 'features/clinical_report/screens/add_clinical_report_screen.dart';
import 'features/ambulance_services/screens/ambulance_services_screen.dart';
import 'features/profile/screens/profile_settings_screen.dart';
import 'features/registration/screens/practitioner_registration_screen.dart';
import 'features/auth/screens/secure_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.ShadcnApp(
      title: 'The Clinical Curator',
      theme: shadcn.ThemeData(
        colorScheme: shadcn.ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF004ac6), // Primary
          primaryForeground: const Color(0xFFffffff), // On Primary
          secondary: const Color(0xFF545f73), // Secondary
          secondaryForeground: const Color(0xFFffffff), // On Secondary
          destructive: const Color(0xFFba1a1a), // Error
          destructiveForeground: const Color(0xFFffffff), // On Error
          background: const Color(0xFFf7f9fb), // Background
          foreground: const Color(0xFF191c1e), // On Background
          card: const Color(0xFFffffff), // Card (default to white for now based on UI)
          cardForeground: const Color(0xFF191c1e), // Card Foreground
          popover: const Color(0xFFffffff), // Popover
          popoverForeground: const Color(0xFF191c1e), // Popover Foreground
          muted: const Color(0xFFe0e3e5), // Surface Variant / Muted
          mutedForeground: const Color(0xFF434655), // On Surface Variant / Muted Foreground
          accent: const Color(0xFFd5e0f8), // Secondary Container / Accent
          accentForeground: const Color(0xFF586377), // On Secondary Container / Accent Foreground
          border: const Color(0xFFc3c6d7), // Outline Variant
          input: const Color(0xFF737686), // Outline / Input
          ring: const Color(0xFF004ac6), // Ring / Primary focus
          chart1: const Color(0xFF2662D9),
          chart2: const Color(0xFFE23670),
          chart3: const Color(0xFFE88C30),
          chart4: const Color(0xFFAF57DB),
          chart5: const Color(0xFF2EB88A),
        ),
        radius: 0.5,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      {'name': 'Secure Login', 'screen': const SecureLoginScreen()},
      {'name': 'Practitioner Registration', 'screen': const PractitionerRegistrationScreen()},
      {'name': 'Patient Dashboard', 'screen': const PatientDashboardScreen()},
      {'name': 'Medical Records', 'screen': const MedicalRecordsScreen()},
      {'name': 'Doctor Schedule', 'screen': const DoctorScheduleScreen()},
      {'name': 'Patient Directory', 'screen': const PatientDirectoryScreen()},
      {'name': 'Add Clinical Report', 'screen': const AddClinicalReportScreen()},
      {'name': 'Ambulance Services', 'screen': const AmbulanceServicesScreen()},
      {'name': 'Profile Settings', 'screen': const ProfileSettingsScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Clinical Curator - Screens'),
        backgroundColor: const Color(0xFF004ac6),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: screens.length,
        itemBuilder: (context, index) {
          final item = screens[index];
          return ListTile(
            title: Text(item['name'] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['screen'] as Widget),
              );
            },
          );
        },
      ),
    );
  }
}
