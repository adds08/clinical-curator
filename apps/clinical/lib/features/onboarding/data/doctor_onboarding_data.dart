import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'patient_onboarding_data.dart';

const doctorOnboardingPages = [
  OnboardingPageData(
    title: 'Welcome, Doctor',
    subtitle:
        'A clinical workspace designed for Nepal\'s healthcare professionals',
    icon: RadixIcons.accessibility,
    gradientColors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  ),
  OnboardingPageData(
    title: 'Patient Management',
    subtitle:
        'View patient profiles, FHIR-powered clinical history, and health records',
    icon: RadixIcons.person,
    gradientColors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
  ),
  OnboardingPageData(
    title: 'Clinical Encounters',
    subtitle:
        'Document with SOAP notes, record conditions, and prescribe medications',
    icon: RadixIcons.clipboardCopy,
    gradientColors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
  ),
  OnboardingPageData(
    title: 'Schedule Management',
    subtitle:
        'Create timesheet entries, manage appointment slots, and offer telehealth',
    icon: RadixIcons.calendar,
    gradientColors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
  ),
  OnboardingPageData(
    title: 'Services & Tools',
    subtitle:
        'Order labs, manage referrals, and publish health tips for your patients',
    icon: RadixIcons.gear,
    gradientColors: [Color(0xFF059669), Color(0xFF10B981)],
  ),
];
