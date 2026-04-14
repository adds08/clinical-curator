import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../data/patient_onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top 55%: gradient background with icon
        Expanded(
          flex: 55,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradientColors,
              ),
            ),
            child: Center(
              child: Icon(
                data.icon,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Bottom 45%: text content
        Expanded(
          flex: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                ).h2(),
                const SizedBox(height: 16),
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                ).muted(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
