import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_fhir_models/collections/condition_collection.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import 'package:cc_fhir_models/collections/procedure_collection.dart';
import 'package:cc_fhir_models/collections/service_request_collection.dart';
import 'package:cc_fhir_models/collections/medication_request_collection.dart';
import '../../../domain/providers/condition_provider.dart';
import '../../../domain/providers/encounter_workflow_provider.dart';
import 'package:cc_rbac/can.dart';
import '../../../domain/providers/procedure_provider.dart';
import '../../../domain/providers/service_request_provider.dart';

class EncounterWorkspaceScreen extends ConsumerStatefulWidget {
  final String encounterId;

  const EncounterWorkspaceScreen({super.key, required this.encounterId});

  @override
  ConsumerState<EncounterWorkspaceScreen> createState() =>
      _EncounterWorkspaceScreenState();
}

class _EncounterWorkspaceScreenState
    extends ConsumerState<EncounterWorkspaceScreen> {
  int _selectedTab = 0;

  static const _tabLabels = [
    'Vitals',
    'Conditions',
    'Procedures',
    'Orders',
    'Notes',
    'Summary',
  ];

  EncounterLocal? _getEncounter() {
    final box = DatabaseService.encounters;
    try {
      return box.values
          .firstWhere((e) => e.fhirId == widget.encounterId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final encounter = _getEncounter();

    if (encounter == null) {
      return Scaffold(
        child: Center(
          child: Text('Encounter not found',
              style: TextStyle(color: colors.mutedForeground)),
        ),
      );
    }

    return Scaffold(
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: colors.background,
          leading: [
            IconButton.ghost(
              icon: const Icon(LucideIcons.arrowLeft, size: 22),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    encounter.patientName ?? 'Patient',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                  Text(
                    'Encounter in progress',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          trailing: [
            Can(
              permission: 'encounter.finalize',
              child: PrimaryButton(
                size: ButtonSize.small,
                onPressed: () => _showFinalizeDialog(context),
                child: const Text('Finalize'),
              ),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          // Tab selector
          Container(
            color: colors.background,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabLabels.length, (i) {
                  final selected = _selectedTab == i;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primary
                              : Colors.transparent,
                          borderRadius: AppRadius.chipRadius,
                          border: selected
                              ? null
                              : Border.all(
                                  color: colors.border
                                      .withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _tabLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? colors.primaryForeground
                                : colors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _VitalsTab(encounter: encounter),
                _ConditionsTab(encounter: encounter),
                _ProceduresTab(encounter: encounter),
                _OrdersTab(encounter: encounter),
                _NotesTab(encounter: encounter),
                _SummaryTab(encounter: encounter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalize Encounter'),
        content: const Text(
            'Are you sure you want to finalize this encounter? This will mark it as completed.'),
        actions: [
          OutlineButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(encounterWorkflowProvider.notifier)
                  .finalizeEncounter();
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.go('/clinical/summary/${widget.encounterId}');
              }
            },
            child: const Text('Finalize'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Tab 1: Vitals
// =============================================================================

class _VitalsTab extends StatefulWidget {
  final EncounterLocal encounter;
  const _VitalsTab({required this.encounter});

  @override
  State<_VitalsTab> createState() => _VitalsTabState();
}

class _VitalsTabState extends State<_VitalsTab> {
  String _heartRate = '';
  String _systolic = '';
  String _diastolic = '';
  String _temperature = '';
  String _spo2 = '';
  String _respRate = '';
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Record Vitals',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.lg),
          _VitalInput(
              label: 'Heart Rate',
              unit: 'bpm',
              value: _heartRate,
              onChanged: (v) => setState(() => _heartRate = v),
              icon: LucideIcons.heart,
              color: colors.heartRate),
          _VitalInput(
              label: 'Systolic BP',
              unit: 'mmHg',
              value: _systolic,
              onChanged: (v) => setState(() => _systolic = v),
              icon: LucideIcons.droplet,
              color: colors.bloodPressure),
          _VitalInput(
              label: 'Diastolic BP',
              unit: 'mmHg',
              value: _diastolic,
              onChanged: (v) => setState(() => _diastolic = v),
              icon: LucideIcons.droplet,
              color: colors.bloodPressure),
          _VitalInput(
              label: 'Temperature',
              unit: '°C',
              value: _temperature,
              onChanged: (v) => setState(() => _temperature = v),
              icon: LucideIcons.thermometer,
              color: colors.temperature),
          _VitalInput(
              label: 'SpO2',
              unit: '%',
              value: _spo2,
              onChanged: (v) => setState(() => _spo2 = v),
              icon: LucideIcons.wind,
              color: colors.oxygenSat),
          _VitalInput(
              label: 'Respiratory Rate',
              unit: '/min',
              value: _respRate,
              onChanged: (v) => setState(() => _respRate = v),
              icon: LucideIcons.waves,
              color: colors.primary),
          const SizedBox(height: AppSpacing.xxl),
          if (_saved)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Icon(LucideIcons.circleCheck,
                      size: 16, color: colors.success),
                  const SizedBox(width: 6),
                  Text('Vitals saved',
                      style:
                          TextStyle(color: colors.success, fontSize: 13)),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _saveVitals,
              child: const Text('Save Vitals'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveVitals() {
    final now = DateTime.now();
    final patientRef = widget.encounter.patientRef;
    final encRef = 'Encounter/${widget.encounter.fhirId}';

    void saveObs(String code, String display, String rawValue,
        String unit, String unitCode) {
      if (rawValue.isEmpty) return;
      final numVal = double.tryParse(rawValue);
      if (numVal == null) return;

      final id = 'obs-${now.millisecondsSinceEpoch}-$code';
      final json = jsonEncode({
        'resourceType': 'Observation',
        'id': id,
        'status': 'final',
        'category': [
          {
            'coding': [
              {
                'system':
                    'http://terminology.hl7.org/CodeSystem/observation-category',
                'code': 'vital-signs',
                'display': 'Vital Signs',
              }
            ]
          }
        ],
        'code': {
          'coding': [
            {'system': 'http://loinc.org', 'code': code, 'display': display}
          ]
        },
        'subject': {'reference': patientRef},
        'encounter': {'reference': encRef},
        'effectiveDateTime': now.toIso8601String(),
        'valueQuantity': {
          'value': numVal,
          'unit': unit,
          'system': 'http://unitsofmeasure.org',
          'code': unitCode,
        },
      });

      DatabaseService.fhirResources.add(FhirResource()
        ..fhirId = id
        ..resourceType = 'Observation'
        ..jsonData = json
        ..patientReference = patientRef
        ..category = 'vital-signs'
        ..syncStatus = 1
        ..isDownloadedOffline = false
        ..lastUpdated = now
        ..createdAt = now);
    }

    saveObs('8867-4', 'Heart Rate', _heartRate, 'bpm', '/min');
    saveObs('8480-6', 'Systolic BP', _systolic, 'mmHg', 'mm[Hg]');
    saveObs('8462-4', 'Diastolic BP', _diastolic, 'mmHg', 'mm[Hg]');
    saveObs('8310-5', 'Temperature', _temperature, '°C', 'Cel');
    saveObs('2708-6', 'SpO2', _spo2, '%', '%');
    saveObs('9279-1', 'Respiratory Rate', _respRate, '/min', '/min');

    setState(() {
      _heartRate = '';
      _systolic = '';
      _diastolic = '';
      _temperature = '';
      _spo2 = '';
      _respRate = '';
      _saved = true;
    });
  }
}

class _VitalInput extends StatelessWidget {
  final String label;
  final String unit;
  final String value;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final Color color;

  const _VitalInput({
    required this.label,
    required this.unit,
    required this.value,
    required this.onChanged,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: SurfaceTheme.cardDecoration(context: context),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 14, color: colors.foreground)),
            ),
            SizedBox(
              width: 80,
              child: TextArea(
                initialValue: value,
                onChanged: onChanged,
                expandableWidth: false,
                minLines: 1,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(unit,
                style:
                    TextStyle(fontSize: 12, color: colors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Tab 2: Conditions
// =============================================================================

class _ConditionsTab extends ConsumerWidget {
  final EncounterLocal encounter;
  const _ConditionsTab({required this.encounter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final conditions =
        ref.watch(allConditionsProvider(encounter.patientRef));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Problem List',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground)),
              IconButton.ghost(
                icon: const Icon(LucideIcons.plus, size: 20),
                onPressed: () =>
                    context.push('/clinical/add-condition/${encounter.fhirId}'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (conditions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.section),
                child: Text('No conditions recorded',
                    style: TextStyle(color: colors.mutedForeground)),
              ),
            )
          else
            ...conditions.map((c) => _ConditionRow(condition: c)),
        ],
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  final ConditionLocal condition;
  const _ConditionRow({required this.condition});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isActive = condition.clinicalStatus == 'active' ||
        condition.clinicalStatus == 'recurrence';
    final statusColor = isActive ? colors.success : colors.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: SurfaceTheme.cardDecoration(context: context),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(condition.displayName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.foreground)),
                  Text(
                    '${condition.clinicalStatus} · ${condition.code}',
                    style: TextStyle(
                        fontSize: 12, color: colors.mutedForeground),
                  ),
                ],
              ),
            ),
            if (condition.severity != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.surfaceLow,
                  borderRadius: AppRadius.chipRadius,
                ),
                child: Text(condition.severity!,
                    style: TextStyle(
                        fontSize: 11, color: colors.mutedForeground)),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Tab 3: Procedures
// =============================================================================

class _ProceduresTab extends ConsumerWidget {
  final EncounterLocal encounter;
  const _ProceduresTab({required this.encounter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final encRef = 'Encounter/${encounter.fhirId}';
    final procedures = ref.watch(proceduresByEncounterProvider(encRef));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Procedures',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground)),
              IconButton.ghost(
                icon: const Icon(LucideIcons.plus, size: 20),
                onPressed: () => _addProcedure(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (procedures.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.section),
                child: Text('No procedures recorded',
                    style: TextStyle(color: colors.mutedForeground)),
              ),
            )
          else
            ...procedures.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration:
                        SurfaceTheme.cardDecoration(context: context),
                    child: Row(
                      children: [
                        Icon(LucideIcons.briefcaseMedical,
                            size: 18, color: colors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.displayName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colors.foreground)),
                              Text(p.status,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: colors.mutedForeground)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void _addProcedure(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _QuickAddDialog(
        title: 'Add Procedure',
        codeLabel: 'Procedure Code',
        nameLabel: 'Procedure Name',
        onSave: (code, name) {
          DatabaseService.procedures.add(ProcedureLocal()
            ..fhirId = 'proc-${DateTime.now().millisecondsSinceEpoch}'
            ..patientRef = encounter.patientRef
            ..encounterRef = 'Encounter/${encounter.fhirId}'
            ..code = code
            ..displayName = name
            ..status = 'completed'
            ..performedDate = DateTime.now()
            ..performerRef = encounter.practitionerRef
            ..performerName = encounter.practitionerName
            ..createdAt = DateTime.now()
            ..syncStatus = 1);
        },
      ),
    );
  }
}

// =============================================================================
// Tab 4: Orders
// =============================================================================

class _OrdersTab extends ConsumerWidget {
  final EncounterLocal encounter;
  const _OrdersTab({required this.encounter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final encRef = 'Encounter/${encounter.fhirId}';
    final orders = ref.watch(ordersByEncounterProvider(encRef));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinical Orders',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _OrderActionChip(
                icon: LucideIcons.flaskConical,
                label: 'Lab Order',
                onTap: () => _addServiceRequest(context, 'laboratory'),
              ),
              _OrderActionChip(
                icon: LucideIcons.image,
                label: 'Imaging',
                onTap: () => _addServiceRequest(context, 'imaging'),
              ),
              _OrderActionChip(
                icon: LucideIcons.arrowLeftRight,
                label: 'Referral',
                onTap: () => _addServiceRequest(context, 'referral'),
              ),
              _OrderActionChip(
                icon: LucideIcons.pill,
                label: 'Prescribe',
                onTap: () => _addMedication(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (orders.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text('No orders yet',
                    style: TextStyle(color: colors.mutedForeground)),
              ),
            )
          else
            ...orders.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration:
                        SurfaceTheme.cardDecoration(context: context),
                    child: Row(
                      children: [
                        Icon(
                          o.category == 'laboratory'
                              ? LucideIcons.flaskConical
                              : o.category == 'imaging'
                                  ? LucideIcons.image
                                  : LucideIcons.arrowLeftRight,
                          size: 18,
                          color: colors.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.displayName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colors.foreground)),
                              Text(
                                '${o.category ?? "order"} · ${o.priority} · ${o.status}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colors.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void _addServiceRequest(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (ctx) => _QuickAddDialog(
        title:
            'Add ${category[0].toUpperCase()}${category.substring(1)} Order',
        codeLabel: 'Code',
        nameLabel: 'Description',
        onSave: (code, name) {
          DatabaseService.serviceRequests.add(ServiceRequestLocal()
            ..fhirId = 'sr-${DateTime.now().millisecondsSinceEpoch}'
            ..patientRef = encounter.patientRef
            ..requesterRef = encounter.practitionerRef
            ..requesterName = encounter.practitionerName
            ..code = code
            ..displayName = name
            ..status = 'active'
            ..intent = 'order'
            ..priority = 'routine'
            ..category = category
            ..encounterRef = 'Encounter/${encounter.fhirId}'
            ..createdAt = DateTime.now()
            ..syncStatus = 1);
        },
      ),
    );
  }

  void _addMedication(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _QuickAddDialog(
        title: 'Prescribe Medication',
        codeLabel: 'Drug Code',
        nameLabel: 'Medication Name',
        onSave: (code, name) {
          DatabaseService.medicationRequests.add(MedicationRequestLocal()
            ..fhirId = 'medreq-${DateTime.now().millisecondsSinceEpoch}'
            ..patientRef = encounter.patientRef
            ..requesterRef = encounter.practitionerRef
            ..requesterName = encounter.practitionerName
            ..medicationCode = code
            ..medicationName = name
            ..status = 'active'
            ..encounterRef = 'Encounter/${encounter.fhirId}'
            ..createdAt = DateTime.now()
            ..syncStatus = 1);
        },
      ),
    );
  }
}

class _OrderActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OrderActionChip({
    required this.icon,
    required this.label,
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
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.buttonRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.primary)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Tab 5: Notes
// =============================================================================

class _NotesTab extends StatefulWidget {
  final EncounterLocal encounter;
  const _NotesTab({required this.encounter});

  @override
  State<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<_NotesTab> {
  late String _notes;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _notes = widget.encounter.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinical Notes',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: TextArea(
              initialValue: _notes,
              placeholder: const Text(
                  'Document clinical findings, assessment, and plan...'),
              onChanged: (v) => _notes = v,
              expandableWidth: false,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_saved)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Icon(LucideIcons.circleCheck,
                      size: 16, color: colors.success),
                  const SizedBox(width: 6),
                  Text('Notes saved',
                      style:
                          TextStyle(color: colors.success, fontSize: 13)),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: () async {
                widget.encounter
                  ..notes = _notes
                  ..updatedAt = DateTime.now();
                await widget.encounter.save();
                setState(() => _saved = true);
              },
              child: const Text('Save Notes'),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Tab 6: Summary
// =============================================================================

class _SummaryTab extends ConsumerWidget {
  final EncounterLocal encounter;
  const _SummaryTab({required this.encounter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final encRef = 'Encounter/${encounter.fhirId}';
    final conditions =
        ref.watch(allConditionsProvider(encounter.patientRef));
    final procedures = ref.watch(proceduresByEncounterProvider(encRef));
    final orders = ref.watch(ordersByEncounterProvider(encRef));
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Encounter Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.lg),
          _SummarySection(
            title: 'Visit Details',
            items: [
              'Patient: ${encounter.patientName ?? "—"}',
              'Provider: ${encounter.practitionerName ?? "—"}',
              'Type: ${encounter.classCode}',
              'Started: ${dateFormat.format(encounter.startDate)}',
              if (encounter.endDate != null)
                'Ended: ${dateFormat.format(encounter.endDate!)}',
              'Status: ${encounter.status}',
            ],
          ),
          if (conditions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _SummarySection(
              title: 'Conditions (${conditions.length})',
              items: conditions
                  .map((c) => '${c.displayName} — ${c.clinicalStatus}')
                  .toList(),
            ),
          ],
          if (procedures.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _SummarySection(
              title: 'Procedures (${procedures.length})',
              items: procedures
                  .map((p) => '${p.displayName} — ${p.status}')
                  .toList(),
            ),
          ],
          if (orders.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _SummarySection(
              title: 'Orders (${orders.length})',
              items: orders
                  .map((o) =>
                      '${o.displayName} (${o.category ?? "order"}) — ${o.status}')
                  .toList(),
            ),
          ],
          if (encounter.notes != null &&
              encounter.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _SummarySection(
              title: 'Notes',
              items: [encounter.notes!],
            ),
          ],
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _SummarySection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground)),
          const SizedBox(height: AppSpacing.sm),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(item,
                    style: TextStyle(
                        fontSize: 13, color: colors.mutedForeground)),
              )),
        ],
      ),
    );
  }
}

// =============================================================================
// Shared: Quick Add Dialog
// =============================================================================

class _QuickAddDialog extends StatefulWidget {
  final String title;
  final String codeLabel;
  final String nameLabel;
  final void Function(String code, String name) onSave;

  const _QuickAddDialog({
    required this.title,
    required this.codeLabel,
    required this.nameLabel,
    required this.onSave,
  });

  @override
  State<_QuickAddDialog> createState() => _QuickAddDialogState();
}

class _QuickAddDialogState extends State<_QuickAddDialog> {
  String _code = '';
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextArea(
            initialValue: '',
            placeholder: Text(widget.codeLabel),
            onChanged: (v) => _code = v,
            expandableWidth: false,
            minLines: 1,
            maxLines: 1,
          ),
          const SizedBox(height: AppSpacing.md),
          TextArea(
            initialValue: '',
            placeholder: Text(widget.nameLabel),
            onChanged: (v) => _name = v,
            expandableWidth: false,
            minLines: 1,
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        OutlineButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          onPressed: () {
            if (_code.isNotEmpty && _name.isNotEmpty) {
              widget.onSave(_code, _name);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
