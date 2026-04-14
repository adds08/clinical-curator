import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/fhir_constants.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/encounter_workflow_provider.dart';
import '../../../domain/providers/practitioner_role_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class StartEncounterScreen extends ConsumerStatefulWidget {
  final String? preselectedPatientId;

  const StartEncounterScreen({super.key, this.preselectedPatientId});

  @override
  ConsumerState<StartEncounterScreen> createState() =>
      _StartEncounterScreenState();
}

class _StartEncounterScreenState extends ConsumerState<StartEncounterScreen> {
  String _selectedClass = FhirConstants.encounterClassAmbulatory;
  final String _serviceType = 'General';
  String? _selectedOrgRef;
  String _reason = '';
  String? _selectedPatientId;
  String? _selectedPatientName;
  bool _isSubmitting = false;


  @override
  void initState() {
    super.initState();
    if (widget.preselectedPatientId != null) {
      _selectedPatientId = widget.preselectedPatientId;
      _resolvePatientName(widget.preselectedPatientId!);
    }
  }

  void _resolvePatientName(String patientId) {
    final box = DatabaseService.fhirResources;
    for (final r in box.values) {
      if (r.resourceType == 'Patient' && r.fhirId == patientId) {
        setState(() {
          _selectedPatientName =
              r.patientReference ?? patientId;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final practRef = authState.user?.fhirPractitionerId != null
        ? 'Practitioner/${authState.user!.fhirPractitionerId}'
        : '';
    final practRoles = ref.watch(rolesByPractitionerProvider(practRef));

    return SubPageScaffold(
      title: 'Start Encounter',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient selection
            _SectionLabel(label: 'Patient'),
            const SizedBox(height: AppSpacing.sm),
            _PatientSelector(
              selectedId: _selectedPatientId,
              selectedName: _selectedPatientName,
              onSelect: (id, name) => setState(() {
                _selectedPatientId = id;
                _selectedPatientName = name;
              }),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Encounter class
            _SectionLabel(label: 'Encounter Type'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                _ClassChip(
                    label: 'Ambulatory',
                    value: 'AMB',
                    selected: _selectedClass == 'AMB',
                    onTap: () =>
                        setState(() => _selectedClass = 'AMB')),
                _ClassChip(
                    label: 'Emergency',
                    value: 'EMER',
                    selected: _selectedClass == 'EMER',
                    onTap: () =>
                        setState(() => _selectedClass = 'EMER')),
                _ClassChip(
                    label: 'Inpatient',
                    value: 'IMP',
                    selected: _selectedClass == 'IMP',
                    onTap: () =>
                        setState(() => _selectedClass = 'IMP')),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Organization (from practitioner roles)
            if (practRoles.isNotEmpty) ...[
              _SectionLabel(label: 'Institution'),
              const SizedBox(height: AppSpacing.sm),
              ...practRoles.map((role) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedOrgRef = role.organizationRef;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: _selectedOrgRef == role.organizationRef
                              ? colors.primary.withValues(alpha: 0.08)
                              : SurfaceTheme.colorFor(
                                  SurfaceLevel.lowest, context),
                          borderRadius: AppRadius.buttonRadius,
                          border: _selectedOrgRef == role.organizationRef
                              ? Border.all(
                                  color:
                                      colors.primary.withValues(alpha: 0.3),
                                  width: 1.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_hospital_rounded,
                                size: 18, color: colors.primary),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.organizationName ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colors.foreground,
                                    ),
                                  ),
                                  Text(
                                    role.specialty ?? role.code,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedOrgRef == role.organizationRef)
                              Icon(Icons.check_circle_rounded,
                                  size: 18, color: colors.primary),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // Reason for visit
            _SectionLabel(label: 'Reason for Visit'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final reason in [
                  'Routine checkup',
                  'Follow-up',
                  'Acute illness',
                  'Injury',
                  'Referral',
                  'Lab review'
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() => _reason = reason);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: _reason == reason
                            ? colors.primary.withValues(alpha: 0.1)
                            : colors.surfaceLow,
                        borderRadius: AppRadius.chipRadius,
                      ),
                      child: Text(
                        reason,
                        style: TextStyle(
                          fontSize: 13,
                          color: _reason == reason
                              ? colors.primary
                              : colors.mutedForeground,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: TextArea(
                initialValue: _reason,
                placeholder: const Text('Or type a reason...'),
                onChanged: (v) => setState(() => _reason = v),
                expandableWidth: false,
              ),
            ),

            const SizedBox(height: AppSpacing.section),

            // Start button
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _selectedPatientId == null || _isSubmitting
                    ? null
                    : _startEncounter,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Start Encounter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startEncounter() async {
    if (_selectedPatientId == null) return;
    setState(() => _isSubmitting = true);

    final authState = ref.read(authProvider);
    final practId = authState.user?.fhirPractitionerId ?? '';
    final practName = authState.user?.displayName ?? 'Doctor';

    try {
      final enc =
          await ref.read(encounterWorkflowProvider.notifier).startEncounter(
                patientRef: 'Patient/$_selectedPatientId',
                practitionerRef: 'Practitioner/$practId',
                classCode: _selectedClass,
                patientName: _selectedPatientName ?? _selectedPatientId!,
                practitionerName: practName,
                organizationRef: _selectedOrgRef,
                reasons: _reason.isNotEmpty ? [_reason] : null,
                serviceType: _serviceType,
              );

      if (mounted) {
        context.go('/clinical/workspace/${enc.fhirId}');
      }
    } catch (_) {
      setState(() => _isSubmitting = false);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: colors.mutedForeground,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ClassChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _ClassChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color:
              selected ? colors.primary : colors.surfaceLow,
          borderRadius: AppRadius.buttonRadius,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected
                ? colors.primaryForeground
                : colors.foreground,
          ),
        ),
      ),
    );
  }
}

class _PatientSelector extends StatelessWidget {
  final String? selectedId;
  final String? selectedName;
  final void Function(String id, String name) onSelect;

  const _PatientSelector({
    required this.selectedId,
    required this.selectedName,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (selectedId != null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.buttonRadius,
          border: Border.all(
              color: colors.primary.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.person_rounded, size: 20, color: colors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                selectedName ?? selectedId!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.foreground),
              ),
            ),
            Icon(Icons.check_circle_rounded,
                size: 18, color: colors.primary),
          ],
        ),
      );
    }

    // Show a searchable patient list
    final box = DatabaseService.fhirResources;
    final patients = box.values
        .where((r) => r.resourceType == 'Patient' && r.syncStatus != 2)
        .toList();

    return Column(
      children: patients.map((p) {
        // Try to extract name from user accounts
        String displayName = p.fhirId;
        try {
          final userBox = DatabaseService.userAccounts;
          for (final u in userBox.values) {
            if (u.fhirPatientId == p.fhirId) {
              displayName = u.displayName;
              break;
            }
          }
        } catch (_) {}

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GestureDetector(
            onTap: () => onSelect(p.fhirId, displayName),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                borderRadius: AppRadius.buttonRadius,
              ),
              child: Row(
                children: [
                  Icon(Icons.person_outline_rounded,
                      size: 18, color: colors.mutedForeground),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    displayName,
                    style: TextStyle(
                        fontSize: 14, color: colors.foreground),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
