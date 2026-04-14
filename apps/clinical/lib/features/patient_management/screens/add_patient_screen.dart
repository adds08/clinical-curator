import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_data/providers/practitioner_data_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class AddPatientScreen extends ConsumerStatefulWidget {
  const AddPatientScreen({super.key});

  @override
  ConsumerState<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends ConsumerState<AddPatientScreen> {
  String _selectedGender = 'Male';
  String? _selectedCondition;
  String? _selectedFacility;
  bool _bookOpdNow = true;

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _chiefComplaintController = TextEditingController();

  final String _patientId =
      'REG-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-X';

  List<String> get _facilities {
    final box = DatabaseService.organizations;
    return box.values
        .where((o) => o.type == 'hospital')
        .map((o) => o.name)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Default to first hospital
    final hospitals = _facilities;
    if (hospitals.isNotEmpty) _selectedFacility = hospitals.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _chiefComplaintController.dispose();
    super.dispose();
  }

  Future<void> _registerPatient() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('Validation Error'),
            subtitle: const Text('Please enter the patient\'s full name.'),
            leading: const Icon(Icons.error_outline, size: 18),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
      return;
    }

    final nameParts = name.split(' ');
    final givenName = nameParts.first;
    final familyName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : nameParts.first;

    String genderCode;
    switch (_selectedGender) {
      case 'Male':
        genderCode = 'male';
        break;
      case 'Female':
        genderCode = 'female';
        break;
      default:
        genderCode = 'other';
    }

    final fhirId =
        'patient-${name.toLowerCase().replaceAll(' ', '-')}-${DateTime.now().millisecondsSinceEpoch}';

    final patient = fhir.Patient(
      fhirId: fhirId,
      name: [
        fhir.HumanName(family: familyName, given: [givenName], text: name),
      ],
      gender: fhir.FhirCode(genderCode),
      birthDate: _dobController.text.isNotEmpty
          ? fhir.FhirDate(_dobController.text)
          : null,
      identifier: [
        fhir.Identifier(
          system: fhir.FhirUri('urn:clinical-curator:patient-id'),
          value: _patientId,
        ),
      ],
      active: fhir.FhirBoolean(true),
    );

    final now = DateTime.now();
    final resource = FhirResource()
      ..fhirId = fhirId
      ..resourceType = 'Patient'
      ..jsonData = jsonEncode(patient.toJson())
      ..patientReference = 'Patient/$fhirId'
      ..syncStatus = 1
      ..isDownloadedOffline = true
      ..lastUpdated = now
      ..createdAt = now;

    await DatabaseService.fhirResources.add(resource);

    // Book OPD appointment if checked
    if (_bookOpdNow) {
      final user = ref.read(authProvider).user;
      final practRef = user?.fhirPractitionerId != null
          ? 'Practitioner/${user!.fhirPractitionerId}'
          : '';
      final practName = user?.displayName ?? 'Doctor';

      final complaint = _chiefComplaintController.text.trim();
      final noteParts = [
        ?_selectedFacility,
        ?_selectedCondition,
        if (complaint.isNotEmpty) complaint,
      ];
      final notes =
          noteParts.isNotEmpty ? noteParts.join(' — ') : 'New patient intake';

      final appointment = AppointmentLocal()
        ..patientRef = 'Patient/$fhirId'
        ..practitionerRef = practRef
        ..practitionerName = practName
        ..patientName = name
        ..appointmentType = 'opd'
        ..status = 'checked-in'
        ..scheduledAt = now
        ..durationMinutes = 20
        ..specialty = _selectedCondition
        ..notes = notes
        ..createdAt = now
        ..syncStatus = 1;

      await DatabaseService.appointments.add(appointment);
      ref.read(appointmentRefreshProvider.notifier).state++;
    }

    ref.read(patientRefreshProvider.notifier).state++;

    if (!mounted) return;

    showToast(
      context: context,
      builder: (ctx, overlay) => SurfaceCard(
        child: Basic(
          title: const Text('Patient registered successfully'),
          subtitle: Text(_bookOpdNow
              ? '$name added & OPD appointment created.'
              : '$name has been added to the directory.'),
          leading: const Icon(Icons.check_circle_outline, size: 18),
        ),
      ),
      location: ToastLocation.bottomRight,
    );

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/doctor/patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final facilities = _facilities;

    return SubPageScaffold(
      title: 'New Patient Intake',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Facility
            _buildSectionLabel('Facility / Clinic'),
            const SizedBox(height: AppSpacing.sm),
            if (facilities.isEmpty)
              TextField(
                initialValue: 'No facilities found',
                readOnly: true,
                filled: true,
                borderRadius: AppRadius.cardRadius,
              )
            else
              SizedBox(
                width: double.infinity,
                child: Select<String>(
                  value: _selectedFacility,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedFacility = val);
                  },
                  itemBuilder: (context, item) => Text(item),
                  // ignore: implicit_call_tearoffs
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: facilities
                          .map((f) => SelectItemButton(value: f, child: Text(f)))
                          .toList(),
                    ),
                  ),
                  placeholder: const Text('Select facility'),
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),

            // Full Name
            _buildSectionLabel('Full Name'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _nameController,
              placeholder: const Text('Enter patient\'s full name'),
              filled: true,
              borderRadius: AppRadius.cardRadius,
              features: [
                InputFeature.leading(Icon(Icons.person_outline,
                    color: colors.mutedForeground, size: 20)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Date of Birth
            _buildSectionLabel('Date of Birth'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _dobController,
              placeholder: const Text('YYYY-MM-DD'),
              filled: true,
              borderRadius: AppRadius.cardRadius,
              features: [
                InputFeature.leading(Icon(Icons.calendar_today_outlined,
                    color: colors.mutedForeground, size: 20)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Gender
            _buildSectionLabel('Gender'),
            const SizedBox(height: AppSpacing.sm),
            _buildGenderSelector(),
            const SizedBox(height: AppSpacing.xxl),

            // Patient ID
            _buildSectionLabel('Patient ID'),
            const SizedBox(height: AppSpacing.sm),
            _buildDisabledField(value: _patientId, icon: Icons.badge_outlined),
            const SizedBox(height: AppSpacing.xs),
            Text('Auto-generated. Cannot be modified.',
                style: TextStyle(
                    fontSize: 11,
                    color: colors.mutedForeground,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: AppSpacing.xxl),

            // Primary Condition
            _buildSectionLabel('Primary Condition'),
            const SizedBox(height: AppSpacing.sm),
            _buildConditionSelector(),
            const SizedBox(height: AppSpacing.xxl),

            // Chief Complaint
            _buildSectionLabel('Chief Complaint'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _chiefComplaintController,
              placeholder: const Text('Reason for visit...'),
              maxLines: 2,
              filled: true,
              borderRadius: AppRadius.cardRadius,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Book OPD toggle
            GestureDetector(
              onTap: () => setState(() => _bookOpdNow = !_bookOpdNow),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: _bookOpdNow
                      ? colors.primary.withValues(alpha: 0.06)
                      : SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(
                      color: _bookOpdNow ? colors.primary : colors.border),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      state: _bookOpdNow
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: (state) {
                        setState(() =>
                            _bookOpdNow = state == CheckboxState.checked);
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Book OPD Appointment Now',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _bookOpdNow
                                      ? colors.primary
                                      : colors.foreground)),
                          const SizedBox(height: 2),
                          Text(
                              'Add this patient to your OPD queue immediately',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colors.mutedForeground)),
                        ],
                      ),
                    ),
                    Icon(Icons.event_available,
                        color: _bookOpdNow
                            ? colors.primary
                            : colors.mutedForeground,
                        size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Data protection notice
            Alert(
              leading: const Icon(Icons.shield_outlined, size: 18),
              title: const Text('Data Protection Notice'),
              content: const Text(
                  'Data will be encrypted and synced with National Health Registry.'),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Register button
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                size: const ButtonSize(1.2),
                onPressed: _registerPatient,
                child: Text(
                  _bookOpdNow ? 'Register & Book OPD' : 'Register Patient',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    final colors = Theme.of(context).colorScheme;
    return Text(text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.foreground));
  }

  Widget _buildDisabledField({required String value, required IconData icon}) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 14, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: SurfaceTheme.colorFor(SurfaceLevel.low, context),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.mutedForeground, size: 20),
          const SizedBox(width: AppSpacing.md),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.mutedForeground)),
          const Spacer(),
          Icon(Icons.lock_outline, size: 16, color: colors.mutedForeground),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    final colors = Theme.of(context).colorScheme;
    final genders = ['Male', 'Female', 'Other'];
    return Row(
      children: genders.map((gender) {
        final isSelected = _selectedGender == gender;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: gender != genders.last ? AppSpacing.sm : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = gender),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary.withValues(alpha: 0.08)
                      : SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                  borderRadius: AppRadius.inputRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected ? colors.primary : Colors.transparent,
                        border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.mutedForeground,
                            width: 2),
                      ),
                      child: isSelected
                          ? Icon(Icons.check,
                              size: 12, color: colors.primaryForeground)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(gender,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? colors.primary
                                : colors.mutedForeground)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConditionSelector() {
    final colors = Theme.of(context).colorScheme;
    final conditions = [
      'Respiratory',
      'Post-Op',
      'Cardiovascular',
      'Neurological',
      'General',
      'Orthopedic',
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: conditions.map((condition) {
        final isSelected = _selectedCondition == condition;
        return Chip(
          onPressed: () => setState(() => _selectedCondition = condition),
          child: Text(condition,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? colors.primary : colors.mutedForeground)),
        );
      }).toList(),
    );
  }
}
