import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/validators.dart';
import '../../../data/collections/fhir_resource_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/connectivity_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _agreedToTerms = false;

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _dobError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _genderError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final nameErr = Validators.validateName(_nameController.text);
    final emailErr = Validators.validateEmail(_emailController.text);
    final phoneErr = Validators.validatePhone(_phoneController.text);
    final passwordErr = Validators.validatePassword(_passwordController.text);

    String? dobErr;
    if (_dobController.text.trim().isEmpty) {
      dobErr = 'Date of birth is required';
    }

    String? confirmErr;
    if (_confirmPasswordController.text.isEmpty) {
      confirmErr = 'Please confirm your password';
    } else if (_confirmPasswordController.text != _passwordController.text) {
      confirmErr = 'Passwords do not match';
    }

    String? genderErr;
    if (_selectedGender == null) {
      genderErr = 'Please select a gender';
    }

    String? termsErr;
    if (!_agreedToTerms) {
      termsErr = 'You must agree to the terms';
    }

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _phoneError = phoneErr;
      _dobError = dobErr;
      _passwordError = passwordErr;
      _confirmPasswordError = confirmErr;
      _genderError = genderErr;
      _termsError = termsErr;
    });

    return nameErr == null &&
        emailErr == null &&
        phoneErr == null &&
        dobErr == null &&
        passwordErr == null &&
        confirmErr == null &&
        genderErr == null &&
        termsErr == null;
  }

  String _generateHealthId() {
    final rng = Random();
    final seg1 = rng.nextInt(9000) + 1000;
    final seg2 = rng.nextInt(9000) + 1000;
    final seg3 = (rng.nextInt(90) + 10).toString();
    return 'NEP-$seg1-$seg2-$seg3';
  }

  Future<void> _handleSignup() async {
    if (!_validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 1. Create account via auth provider
    final isOnline = ref.read(isOnlineProvider);
    await ref.read(authProvider.notifier).signup(email, password, name, isOnline: isOnline);

    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated || authState.user == null) return;

    // 2. Generate health ID and create FHIR Patient resource
    final healthId = _generateHealthId();
    final patientId = 'patient-${DateTime.now().millisecondsSinceEpoch}';
    final nameParts = name.split(' ');
    final familyName = nameParts.length > 1 ? nameParts.last : name;
    final givenNames = nameParts.length > 1
        ? nameParts.sublist(0, nameParts.length - 1)
        : [name];

    final patient = fhir.Patient(
      fhirId: patientId,
      identifier: [
        fhir.Identifier(
          system: fhir.FhirUri('urn:clinical-curator:health-id'),
          value: healthId,
        ),
      ],
      name: [
        fhir.HumanName(
          family: familyName,
          given: givenNames,
          text: name,
        ),
      ],
      gender: _selectedGender == 'Male'
          ? fhir.FhirCode('male')
          : _selectedGender == 'Female'
              ? fhir.FhirCode('female')
              : fhir.FhirCode('other'),
      birthDate: _dobController.text.trim().isNotEmpty
          ? fhir.FhirDate(_dobController.text.trim())
          : null,
      telecom: [
        if (_phoneController.text.trim().isNotEmpty)
          fhir.ContactPoint(
            system: fhir.ContactPointSystem.phone,
            value: _phoneController.text.trim(),
          ),
        fhir.ContactPoint(
          system: fhir.ContactPointSystem.email,
          value: email,
        ),
      ],
    );

    final fhirResource = FhirResource()
      ..fhirId = patientId
      ..resourceType = 'Patient'
      ..jsonData = jsonEncode(patient.toJson())
      ..patientReference = 'Patient/$patientId'
      ..syncStatus = 1
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();

    await DatabaseService.fhirResources.add(fhirResource);

    // 3. Update the UserAccount with fhirPatientId and healthId
    final box = DatabaseService.userAccounts;
    for (final account in box.values) {
      if (account.email == email.toLowerCase()) {
        account.fhirPatientId = patientId;
        account.healthId = healthId;
        await account.save();
        break;
      }
    }

    // 4. Re-check auth to pick up updated user data
    await ref.read(authProvider.notifier).checkAuthStatus();
    // go_router redirect handles navigation on success
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Top bar with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  GhostButton(
                    density: ButtonDensity.icon,
                    onPressed: () => context.go(RouteNames.login),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: colors.border.withValues(alpha: 0.2),
            ),

            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Error from auth provider
                        if (authState.errorMessage != null) ...[
                          Alert(
                            destructive: true,
                            leading: const Icon(
                              Icons.error_outline,
                              size: 18,
                            ),
                            title: Text(authState.errorMessage!),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Full Name
                        _buildFieldLabel('FULL NAME'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nameController,
                          hintText: 'Enter your full name',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        if (_nameError != null) _buildErrorText(_nameError!),
                        const SizedBox(height: 16),

                        // Email
                        _buildFieldLabel('EMAIL'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'name@example.com',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        if (_emailError != null) _buildErrorText(_emailError!),
                        const SizedBox(height: 16),

                        // Phone
                        _buildFieldLabel('PHONE NUMBER'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: '+977 98XXXXXXXX',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        if (_phoneError != null) _buildErrorText(_phoneError!),
                        const SizedBox(height: 16),

                        // Date of Birth
                        _buildFieldLabel('DATE OF BIRTH'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _dobController,
                          keyboardType: TextInputType.datetime,
                          hintText: 'YYYY-MM-DD',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        if (_dobError != null) _buildErrorText(_dobError!),
                        const SizedBox(height: 16),

                        // Gender
                        _buildFieldLabel('GENDER'),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          value: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              _genderError = null;
                            });
                          },
                          child: Row(
                            children: [
                              RadioItem<String>(
                                value: 'Male',
                                trailing: const Text(
                                  'Male',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 20),
                              RadioItem<String>(
                                value: 'Female',
                                trailing: const Text(
                                  'Female',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 20),
                              RadioItem<String>(
                                value: 'Other',
                                trailing: const Text(
                                  'Other',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_genderError != null)
                          _buildErrorText(_genderError!),
                        const SizedBox(height: 16),

                        // Password
                        _buildFieldLabel('PASSWORD'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          hintText: 'Min 8 characters with 1 number',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                          features: const [
                            InputFeature.passwordToggle(
                              mode: PasswordPeekMode.toggle,
                            ),
                          ],
                        ),
                        if (_passwordError != null)
                          _buildErrorText(_passwordError!),
                        const SizedBox(height: 16),

                        // Confirm Password
                        _buildFieldLabel('CONFIRM PASSWORD'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          hintText: 'Re-enter your password',
                          filled: true,
                          borderRadius: BorderRadius.circular(8),
                          features: const [
                            InputFeature.passwordToggle(
                              mode: PasswordPeekMode.toggle,
                            ),
                          ],
                        ),
                        if (_confirmPasswordError != null)
                          _buildErrorText(_confirmPasswordError!),
                        const SizedBox(height: 20),

                        // Terms checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              state: _agreedToTerms
                                  ? CheckboxState.checked
                                  : CheckboxState.unchecked,
                              onChanged: (state) {
                                setState(() {
                                  _agreedToTerms =
                                      state == CheckboxState.checked;
                                  _termsError = null;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _agreedToTerms = !_agreedToTerms;
                                    _termsError = null;
                                  });
                                },
                                child: Text(
                                  'I agree to the Terms of Service and Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: colors.mutedForeground,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_termsError != null)
                          _buildErrorText(_termsError!),
                        const SizedBox(height: 24),

                        // Submit button
                        PrimaryButton(
                          onPressed:
                              authState.isLoading ? null : _handleSignup,
                          size: const ButtonSize(1.1),
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),

                        // Sign In link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.mutedForeground,
                              ),
                            ),
                            GhostButton(
                              density: ButtonDensity.compact,
                              onPressed: () => context.go(RouteNames.login),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colors.secondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildErrorText(String error) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 2),
      child: Text(
        error,
        style: TextStyle(
          fontSize: 12,
          color: colors.destructive,
        ),
      ),
    );
  }
}
