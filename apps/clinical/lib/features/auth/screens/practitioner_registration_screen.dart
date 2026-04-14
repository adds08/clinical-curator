import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/utils/validators.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class PractitionerRegistrationScreen extends ConsumerStatefulWidget {
  const PractitionerRegistrationScreen({super.key});

  @override
  ConsumerState<PractitionerRegistrationScreen> createState() =>
      _PractitionerRegistrationScreenState();
}

class _PractitionerRegistrationScreenState
    extends ConsumerState<PractitionerRegistrationScreen> {
  final _licenseController = TextEditingController();
  final _facilityController = TextEditingController();

  String? _selectedPractitionerType;
  String? _selectedSpecialization;
  bool _frontUploaded = false;
  bool _backUploaded = false;

  String? _typeError;
  String? _licenseError;
  String? _specializationError;
  String? _facilityError;

  static const _specializations = [
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Dermatology',
    'Internal Medicine',
    'Pediatrics',
    'General Practice',
  ];

  @override
  void dispose() {
    _licenseController.dispose();
    _facilityController.dispose();
    super.dispose();
  }

  bool _validate() {
    String? typeErr;
    if (_selectedPractitionerType == null) {
      typeErr = 'Please select a practitioner type';
    }

    final licenseErr =
        Validators.validateLicenseNumber(_licenseController.text);

    String? specErr;
    if (_selectedSpecialization == null) {
      specErr = 'Please select a specialization';
    }

    String? facilityErr;
    if (_facilityController.text.trim().isEmpty) {
      facilityErr = 'Facility affiliation is required';
    }

    setState(() {
      _typeError = typeErr;
      _licenseError = licenseErr;
      _specializationError = specErr;
      _facilityError = facilityErr;
    });

    return typeErr == null &&
        licenseErr == null &&
        specErr == null &&
        facilityErr == null;
  }

  Future<void> _handleSubmit() async {
    if (!_validate()) return;

    final user = ref.read(authProvider).user;
    if (user == null) return;

    // 1. Update UserAccount to mark as practitioner pending verification
    final box = DatabaseService.userAccounts;
    for (final account in box.values) {
      if (account.email == user.email) {
        account.isPractitioner = true;
        account.isVerified = false;
        account.practitionerType =
            _selectedPractitionerType?.toLowerCase() ?? 'doctor';
        account.accountType = 'practitioner';
        account.updatedAt = DateTime.now();
        await account.save();
        break;
      }
    }

    // 2. Create a FHIR Practitioner resource
    final practitionerId = 'practitioner-${DateTime.now().millisecondsSinceEpoch}';
    final nameParts = user.displayName.split(' ');
    final familyName = nameParts.length > 1 ? nameParts.last : user.displayName;
    final givenNames = nameParts.length > 1
        ? nameParts.sublist(0, nameParts.length - 1)
        : [user.displayName];

    final practitioner = fhir.Practitioner(
      fhirId: practitionerId,
      name: [
        fhir.HumanName(
          family: familyName,
          given: givenNames,
          text: user.displayName,
        ),
      ],
      identifier: [
        fhir.Identifier(
          system: fhir.FhirUri('urn:clinical-curator:license'),
          value: _licenseController.text.trim(),
        ),
      ],
      qualification: [
        fhir.PractitionerQualification(
          code: fhir.CodeableConcept(
            text: _selectedSpecialization ?? 'General Practice',
          ),
        ),
      ],
    );

    final fhirResource = FhirResource()
      ..fhirId = practitionerId
      ..resourceType = 'Practitioner'
      ..jsonData = jsonEncode(practitioner.toJson())
      ..practitionerReference = 'Practitioner/$practitionerId'
      ..syncStatus = 1
      ..isDownloadedOffline = true
      ..lastUpdated = DateTime.now()
      ..createdAt = DateTime.now();

    await DatabaseService.fhirResources.add(fhirResource);

    // 3. Link practitioner ID to user account
    for (final account in box.values) {
      if (account.email == user.email) {
        account.fhirPractitionerId = practitionerId;
        await account.save();
        break;
      }
    }

    // 4. Show confirmation and navigate back
    if (!mounted) return;
    showToast(
      context: context,
      builder: (ctx, overlay) => SurfaceCard(
        child: Basic(
          title: const Text('Registration Submitted'),
          subtitle: const Text(
              'Your credentials are pending admin review. You will be notified once verified.'),
          leading: Icon(Icons.check_circle, size: 18, color: Theme.of(context).colorScheme.success),
        ),
      ),
      location: ToastLocation.bottomRight,
    );
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.go(RouteNames.login);
    });
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
                    'Register as Practitioner',
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
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Subtitle
                        Text(
                          'Submit your credentials for admin verification',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 24),

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

                        // Main form card
                        Card(
                          padding: const EdgeInsets.all(24),
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Professional Credentials',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: colors.foreground,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Practitioner Type
                              _buildFieldLabel('PRACTITIONER TYPE'),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                value: _selectedPractitionerType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPractitionerType = value;
                                    _typeError = null;
                                  });
                                },
                                child: Row(
                                  children: [
                                    _buildTypeOption(
                                      value: 'Doctor',
                                      icon: Icons.medical_services_outlined,
                                      label: 'Doctor',
                                    ),
                                    const SizedBox(width: 12),
                                    _buildTypeOption(
                                      value: 'Nurse',
                                      icon: Icons.health_and_safety_outlined,
                                      label: 'Nurse',
                                    ),
                                  ],
                                ),
                              ),
                              if (_typeError != null)
                                _buildErrorText(_typeError!),
                              const SizedBox(height: 20),

                              // Medical License Number
                              _buildFieldLabel('MEDICAL LICENSE NUMBER'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _licenseController,
                                hintText: 'e.g. NMC12345',
                                filled: true,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              if (_licenseError != null)
                                _buildErrorText(_licenseError!),
                              const SizedBox(height: 20),

                              // Specialization
                              _buildFieldLabel('SPECIALIZATION'),
                              const SizedBox(height: 6),
                              Select<String>(
                                value: _selectedSpecialization,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSpecialization = value;
                                    _specializationError = null;
                                  });
                                },
                                itemBuilder: (context, value) => Text(
                                  value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                placeholder: Text(
                                  'Select specialization',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors.mutedForeground,
                                  ),
                                ),
                                popup: (context) {
                                  return SelectPopup(
                                    autoClose: true,
                                    items: SelectItemList(
                                      children: _specializations
                                          .map(
                                            (spec) => SelectItemButton<String>(
                                              value: spec,
                                              child: Text(
                                                spec,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  );
                                },
                              ),
                              if (_specializationError != null)
                                _buildErrorText(_specializationError!),
                              const SizedBox(height: 20),

                              // Facility Affiliation
                              _buildFieldLabel('FACILITY AFFILIATION'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _facilityController,
                                hintText:
                                    'e.g. Tribhuvan University Teaching Hospital',
                                filled: true,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              if (_facilityError != null)
                                _buildErrorText(_facilityError!),
                              const SizedBox(height: 24),

                              // License Photo Upload
                              _buildFieldLabel('LICENSE PHOTO'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildUploadCard(
                                      label: 'Front',
                                      uploaded: _frontUploaded,
                                      onTap: () {
                                        setState(() {
                                          _frontUploaded = !_frontUploaded;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildUploadCard(
                                      label: 'Back',
                                      uploaded: _backUploaded,
                                      onTap: () {
                                        setState(() {
                                          _backUploaded = !_backUploaded;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // NMC Verification Notice
                              Alert(
                                leading: Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: colors.primary,
                                ),
                                title: const Text(
                                  'NMC Verification',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: const Text(
                                  'Your credentials will be verified against the Nepal Medical Council database. This usually takes 24-48 hours.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Submit button
                              PrimaryButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : _handleSubmit,
                                size: const ButtonSize(1.1),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.white,
                                ),
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
                                        'Submit for Verification',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Note text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: colors.mutedForeground,
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Your application will be reviewed by our admin team',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colors.mutedForeground,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildTypeOption({
    required String value,
    required IconData icon,
    required String label,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedPractitionerType == value;
    return Expanded(
      child: RadioItem<String>(
        value: value,
        trailing: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.06)
                  : colors.muted,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.4)
                    : colors.border.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? colors.primary
                      : colors.mutedForeground,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colors.primary
                        : colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String label,
    required bool uploaded,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: uploaded
              ? colors.successBackground
              : colors.muted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: uploaded
                ? colors.success.withValues(alpha: 0.4)
                : colors.border.withValues(alpha: 0.3),
            style: uploaded ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              uploaded ? Icons.check_circle : Icons.cloud_upload_outlined,
              size: 28,
              color: uploaded ? colors.success : colors.mutedForeground,
            ),
            const SizedBox(height: 8),
            Text(
              uploaded ? '$label Uploaded' : 'Upload $label',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: uploaded ? colors.success : colors.mutedForeground,
              ),
            ),
            if (!uploaded) ...[
              const SizedBox(height: 2),
              Text(
                'Tap to select',
                style: TextStyle(
                  fontSize: 10,
                  color: colors.mutedForeground,
                ),
              ),
            ],
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
