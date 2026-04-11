import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/condition_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class AddConditionScreen extends ConsumerStatefulWidget {
  final String encounterFhirId;

  const AddConditionScreen({super.key, required this.encounterFhirId});

  @override
  ConsumerState<AddConditionScreen> createState() =>
      _AddConditionScreenState();
}

class _AddConditionScreenState extends ConsumerState<AddConditionScreen> {
  String _code = '';
  String _displayName = '';
  String _clinicalStatus = 'active';
  String _verificationStatus = 'confirmed';
  String _severity = 'moderate';
  bool _isSubmitting = false;

  // Common conditions for quick selection
  static const _commonConditions = [
    {'code': '38341003', 'name': 'Hypertension'},
    {'code': '73211009', 'name': 'Diabetes Mellitus Type 2'},
    {'code': '195967001', 'name': 'Asthma'},
    {'code': '84114007', 'name': 'Heart Failure'},
    {'code': '13645005', 'name': 'COPD'},
    {'code': '49436004', 'name': 'Atrial Fibrillation'},
    {'code': '44054006', 'name': 'Diabetes Mellitus Type 1'},
    {'code': '233604007', 'name': 'Pneumonia'},
    {'code': '36971009', 'name': 'Sinusitis'},
    {'code': '54150009', 'name': 'Upper Respiratory Infection'},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SubPageScaffold(
      title: 'Add Condition',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick select
            Text('Common Conditions',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    letterSpacing: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _commonConditions.map((c) {
                final selected = _code == c['code'];
                return GestureDetector(
                  onTap: () => setState(() {
                    _code = c['code']!;
                    _displayName = c['name']!;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.primary.withValues(alpha: 0.1)
                          : colors.surfaceLow,
                      borderRadius: AppRadius.chipRadius,
                    ),
                    child: Text(
                      c['name']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? colors.primary
                            : colors.mutedForeground,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Manual entry
            Text('Or Enter Manually',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    letterSpacing: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            TextArea(
              initialValue: _code,
              placeholder: const Text('SNOMED / ICD-10 Code'),
              onChanged: (v) => setState(() => _code = v),
              expandableWidth: false,
              minLines: 1,
              maxLines: 1,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextArea(
              initialValue: _displayName,
              placeholder: const Text('Condition Name'),
              onChanged: (v) => setState(() => _displayName = v),
              expandableWidth: false,
              minLines: 1,
              maxLines: 1,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Clinical Status
            Text('Clinical Status',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    letterSpacing: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: ['active', 'recurrence', 'inactive', 'resolved']
                  .map((s) => _StatusChip(
                        label: s,
                        selected: _clinicalStatus == s,
                        onTap: () =>
                            setState(() => _clinicalStatus = s),
                      ))
                  .toList(),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Verification Status
            Text('Verification',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    letterSpacing: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                'unconfirmed',
                'provisional',
                'differential',
                'confirmed'
              ]
                  .map((s) => _StatusChip(
                        label: s,
                        selected: _verificationStatus == s,
                        onTap: () =>
                            setState(() => _verificationStatus = s),
                      ))
                  .toList(),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Severity
            Text('Severity',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    letterSpacing: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: ['mild', 'moderate', 'severe']
                  .map((s) => _StatusChip(
                        label: s,
                        selected: _severity == s,
                        onTap: () => setState(() => _severity = s),
                      ))
                  .toList(),
            ),

            const SizedBox(height: AppSpacing.section),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _code.isEmpty ||
                        _displayName.isEmpty ||
                        _isSubmitting
                    ? null
                    : _save,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Add Condition'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSubmitting = true);

    final authState = ref.read(authProvider);
    final practRef = authState.user?.fhirPractitionerId != null
        ? 'Practitioner/${authState.user!.fhirPractitionerId}'
        : '';

    // Find encounter to get patientRef
    final encBox = DatabaseService.encounters;
    String patientRef = '';
    try {
      final enc = encBox.values
          .firstWhere((e) => e.fhirId == widget.encounterFhirId);
      patientRef = enc.patientRef;
    } catch (_) {}

    final now = DateTime.now();
    final condition = ConditionLocal()
      ..fhirId = 'cond-${now.millisecondsSinceEpoch}'
      ..patientRef = patientRef
      ..code = _code
      ..displayName = _displayName
      ..clinicalStatus = _clinicalStatus
      ..verificationStatus = _verificationStatus
      ..onsetDate = now
      ..recordedDate = now
      ..severity = _severity
      ..encounterRef = 'Encounter/${widget.encounterFhirId}'
      ..recorderRef = practRef
      ..createdAt = now
      ..syncStatus = 1;

    await DatabaseService.conditions.add(condition);

    if (mounted) {
      context.pop();
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
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
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceLow,
          borderRadius: AppRadius.chipRadius,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected
                ? colors.primaryForeground
                : colors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
