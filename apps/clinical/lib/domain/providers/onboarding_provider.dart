import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static String completed(String role) => 'onboarding_${role}_completed';
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    state = OnboardingState(
      patientCompleted:
          _prefs?.getBool(_Keys.completed('patient')) ?? false,
      doctorCompleted:
          _prefs?.getBool(_Keys.completed('doctor')) ?? false,
    );
  }

  bool shouldShowOnboarding(String accountType) {
    if (accountType == 'patient') return !state.patientCompleted;
    if (accountType == 'practitioner' || accountType == 'doctor') {
      return !state.doctorCompleted;
    }
    return false;
  }

  Future<void> completeOnboarding(String accountType) async {
    _prefs ??= await SharedPreferences.getInstance();

    if (accountType == 'patient') {
      await _prefs!.setBool(_Keys.completed('patient'), true);
      state = state.copyWith(patientCompleted: true);
    } else if (accountType == 'practitioner' || accountType == 'doctor') {
      await _prefs!.setBool(_Keys.completed('doctor'), true);
      state = state.copyWith(doctorCompleted: true);
    }
  }
}

class OnboardingState {
  final bool patientCompleted;
  final bool doctorCompleted;

  const OnboardingState({
    this.patientCompleted = false,
    this.doctorCompleted = false,
  });

  OnboardingState copyWith({
    bool? patientCompleted,
    bool? doctorCompleted,
  }) {
    return OnboardingState(
      patientCompleted: patientCompleted ?? this.patientCompleted,
      doctorCompleted: doctorCompleted ?? this.doctorCompleted,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final notifier = OnboardingNotifier();
  notifier.init();
  return notifier;
});
