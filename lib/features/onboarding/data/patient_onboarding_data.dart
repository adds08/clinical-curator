import 'package:shadcn_flutter/shadcn_flutter.dart';

class OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });
}

const patientOnboardingPages = [
  OnboardingPageData(
    title: 'Welcome to Clinical Curator',
    subtitle: 'Your complete health companion — works even offline',
    icon: RadixIcons.heart,
    gradientColors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  ),
  OnboardingPageData(
    title: 'Your Health Records',
    subtitle:
        'Access medical records, vitals, and lab results powered by FHIR R4 standards',
    icon: RadixIcons.activityLog,
    gradientColors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
  ),
  OnboardingPageData(
    title: 'Book Appointments',
    subtitle:
        'Find doctors, pick available time slots, and manage your appointments',
    icon: RadixIcons.calendar,
    gradientColors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
  ),
  OnboardingPageData(
    title: 'Health Services',
    subtitle:
        'Ambulance, pharmacy, lab booking, telemedicine, and insurance — all in one place',
    icon: RadixIcons.backpack,
    gradientColors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
  ),
  OnboardingPageData(
    title: 'Stay Connected',
    subtitle:
        'Get notifications, read health tips, and manage your data consent',
    icon: RadixIcons.bell,
    gradientColors: [Color(0xFF059669), Color(0xFF10B981)],
  ),
];
