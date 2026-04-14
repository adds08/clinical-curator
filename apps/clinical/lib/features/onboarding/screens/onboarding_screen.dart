import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/router/route_names.dart';
import 'package:cc_fhir_models/models/user_role.dart';
import '../../../domain/providers/onboarding_provider.dart';
import '../../../domain/providers/role_provider.dart';
import '../data/doctor_onboarding_data.dart';
import '../data/patient_onboarding_data.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPageData> get _pages {
    final role = ref.read(roleProvider);
    if (role.isPractitioner) {
      return doctorOnboardingPages;
    }
    return patientOnboardingPages;
  }

  String get _accountType {
    final role = ref.read(roleProvider);
    return role.isPractitioner ? 'practitioner' : 'patient';
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _nextPage() {
    if (_isLastPage) {
      _complete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _complete() {
    ref.read(onboardingProvider.notifier).completeOnboarding(_accountType);
    final role = ref.read(roleProvider);
    final home = switch (role) {
      UserRole.patient => RouteNames.patientHome,
      UserRole.clinician => RouteNames.clinicianHome,
      UserRole.admin => RouteNames.adminVerifications,
    };
    context.go(home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GhostButton(
                  onPressed: _complete,
                  child: const Text('Skip'),
                ),
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (_, index) =>
                    OnboardingPage(data: pages[index]),
              ),
            ),
            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnboardingDots(
                    count: pages.length,
                    activeIndex: _currentPage,
                  ),
                  PrimaryButton(
                    onPressed: _nextPage,
                    child: Text(_isLastPage ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
