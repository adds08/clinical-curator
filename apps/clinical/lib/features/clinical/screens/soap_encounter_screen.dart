import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

/// SOAP Encounter Workspace — matches design spec Screen 3
/// S = Subjective (Chief Complaint + HPI)
/// O = Objective (Vitals + Physical Exam)
/// A = Assessment (ICD-10 search + diagnoses)
/// P = Plan (Orders + prescriptions + follow-up)
class SoapEncounterScreen extends ConsumerStatefulWidget {
  final String encounterId;

  const SoapEncounterScreen({super.key, required this.encounterId});

  @override
  ConsumerState<SoapEncounterScreen> createState() => _SoapEncounterScreenState();
}

class _SoapEncounterScreenState extends ConsumerState<SoapEncounterScreen> {
  // ── S: Subjective ──
  late TextEditingController _ccController;
  late TextEditingController _hpiController;

  // ── O: Objective ──
  late TextEditingController _hrController;
  late TextEditingController _sysController;
  late TextEditingController _diaController;
  late TextEditingController _tempController;
  late TextEditingController _spo2Controller;
  late TextEditingController _rrController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  String _selectedSystem = '';
  late TextEditingController _peNotesController;

  // ── A: Assessment ──
  late TextEditingController _diagnosisSearchController;
  List<Map<String, String>> _diagnosisResults = [];
  final List<Map<String, String>> _selectedDiagnoses = [];

  // ── P: Plan ──
  late TextEditingController _medicationController;
  late TextEditingController _labOrderController;
  late TextEditingController _imagingOrderController;
  late TextEditingController _referralController;
  late TextEditingController _followUpController;
  DateTime? _followUpDate;

  bool _saving = false;
  bool _encounterFound = true;

  static const _physicalSystems = ['CVS', 'Respiratory', 'GI', 'Neuro', 'MSK', 'Skin', 'ENT', 'Eye', 'GU', 'Psych'];

  // Common ICD-10 codes for quick-search (expanded in production)
  static const _icd10Codes = {
    'I10': 'Essential Hypertension',
    'E11.9': 'Type 2 Diabetes without complications',
    'I25.10': 'Atherosclerotic Heart Disease',
    'J45.909': 'Unspecified Asthma',
    'J44.9': 'COPD unspecified',
    'N18.9': 'Chronic Kidney Disease unspecified',
    'E78.5': 'Hyperlipidemia unspecified',
    'M54.5': 'Low Back Pain',
    'J02.9': 'Acute Pharyngitis unspecified',
    'N39.0': 'UTI site not specified',
    'R51': 'Headache',
    'R10.9': 'Abdominal pain unspecified',
    'J06.9': 'Acute URI unspecified',
    'K21.9': 'GERD without esophagitis',
    'E03.9': 'Hypothyroidism unspecified',
    'D64.9': 'Anemia unspecified',
    'F41.9': 'Anxiety disorder unspecified',
    'F32.9': 'MDD single episode unspecified',
    'M17.9': 'Osteoarthritis of knee unspecified',
    'G43.909': 'Migraine unspecified',
  };

  @override
  void initState() {
    super.initState();
    _ccController = TextEditingController();
    _hpiController = TextEditingController();
    _hrController = TextEditingController();
    _sysController = TextEditingController();
    _diaController = TextEditingController();
    _tempController = TextEditingController();
    _spo2Controller = TextEditingController();
    _rrController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _peNotesController = TextEditingController();
    _diagnosisSearchController = TextEditingController();
    _medicationController = TextEditingController();
    _labOrderController = TextEditingController();
    _imagingOrderController = TextEditingController();
    _referralController = TextEditingController();
    _followUpController = TextEditingController();
  }

  @override
  void dispose() {
    _ccController.dispose();
    _hpiController.dispose();
    _hrController.dispose();
    _sysController.dispose();
    _diaController.dispose();
    _tempController.dispose();
    _spo2Controller.dispose();
    _rrController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _peNotesController.dispose();
    _diagnosisSearchController.dispose();
    _medicationController.dispose();
    _labOrderController.dispose();
    _imagingOrderController.dispose();
    _referralController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  EncounterLocal? _getEncounter() {
    final box = DatabaseService.encounters;
    try {
      return box.values.firstWhere((e) => e.fhirId == widget.encounterId);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.fileQuestion, size: 48, color: colors.mutedForeground),
              const SizedBox(height: AppSpacing.md),
              Text('Encounter not found', style: TextStyle(color: colors.mutedForeground)),
            ],
          ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
                  ),
                  Text(
                    '${encounter.classCode ?? "OPD"} · ${encounter.status ?? "in-progress"}',
                    style: TextStyle(fontSize: 12, color: colors.success, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
          trailing: [
            OutlineButton(onPressed: _saving ? null : () => _saveDraft(encounter), child: Text(_saving ? 'Saving...' : 'Save Draft')),
            const SizedBox(width: AppSpacing.sm),
            PrimaryButton(onPressed: _saving ? null : () => _completeEncounter(encounter), child: Text(_saving ? 'Saving...' : 'Complete')),
          ],
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── S: Subjective ──
            _buildSectionHeader(context, 'S — Subjective', LucideIcons.messageSquare),
            const SizedBox(height: AppSpacing.md),
            TextField(controller: _ccController, placeholder: const Text('Chief Complaint — What brings the patient today?')),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _hpiController,
              placeholder: const Text('History of Present Illness — Onset, course, severity...'),
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── O: Objective ──
            _buildSectionHeader(context, 'O — Objective', LucideIcons.clipboardCheck),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Vitals',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _buildVitalField('BP Systolic', 'mmHg', _sysController, LucideIcons.activity)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildVitalField('BP Diastolic', 'mmHg', _diaController, LucideIcons.activity)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _buildVitalField('Heart Rate', 'bpm', _hrController, LucideIcons.heart)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildVitalField('SpO₂', '%', _spo2Controller, LucideIcons.wind)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildVitalField('Temp', '°C', _tempController, LucideIcons.thermometer)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _buildVitalField('Resp Rate', '/min', _rrController, LucideIcons.waves)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildVitalField('Weight', 'kg', _weightController, LucideIcons.scale)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildVitalField('Height', 'cm', _heightController, LucideIcons.ruler)),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),
            Text(
              'Physical Exam',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _physicalSystems.map((system) {
                final selected = _selectedSystem == system;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSystem = _selectedSystem == system ? '' : system;
                      if (_selectedSystem.isNotEmpty) {
                        _peNotesController.text = '$_selectedSystem: ';
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(color: selected ? colors.primary : colors.surfaceLow, borderRadius: AppRadius.chipRadius),
                    child: Text(
                      system,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? colors.primaryForeground : colors.foreground,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_selectedSystem.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              TextField(controller: _peNotesController, placeholder: const Text('Exam findings...'), maxLines: 3),
            ],

            const SizedBox(height: AppSpacing.xxl),

            // ── A: Assessment ──
            _buildSectionHeader(context, 'A — Assessment', LucideIcons.stethoscope),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _diagnosisSearchController,
              placeholder: const Text('Search diagnosis (ICD-10 code or name)...'),
              onChanged: _searchDiagnoses,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_diagnosisResults.isNotEmpty) ...[
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.border),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _diagnosisResults.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: colors.border.withValues(alpha: 0.3)),
                  itemBuilder: (context, index) {
                    final d = _diagnosisResults[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!_selectedDiagnoses.any((s) => s['code'] == d['code'])) {
                            _selectedDiagnoses.add(d);
                          }
                          _diagnosisResults = [];
                          _diagnosisSearchController.clear();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Text(
                              d['code'] ?? '',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(d['display'] ?? '', style: TextStyle(fontSize: 13, color: colors.foreground)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            // Selected diagnoses
            ..._selectedDiagnoses.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        d['code'] ?? '',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(d['display'] ?? '', style: TextStyle(fontSize: 13, color: colors.foreground)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedDiagnoses.removeAt(i)),
                      child: Icon(LucideIcons.x, size: 16, color: colors.mutedForeground),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: AppSpacing.xxl),

            // ── P: Plan ──
            _buildSectionHeader(context, 'P — Plan', LucideIcons.clipboardList),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Orders',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _medicationController, placeholder: const Text('Medication Order + dosage')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _labOrderController, placeholder: const Text('Lab Order — e.g. CBC, LFT, Lipid Panel')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _imagingOrderController, placeholder: const Text('Imaging Order — e.g. CXR, USG Abdomen, MRI Brain')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _referralController, placeholder: const Text('Referral — e.g. Cardiology, Orthopedics')),

            const SizedBox(height: AppSpacing.lg),
            Text(
              'Follow-up',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: _followUpController, placeholder: const Text('Follow-up notes...')),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DatePicker(
                    value: _followUpDate,
                    onChanged: (date) => setState(() => _followUpDate = date),
                    placeholder: const Text('Pick follow-up date'),
                    mode: PromptMode.popover,
                    stateBuilder: (date) {
                      final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                      return isPast ? DateState.disabled : DateState.enabled;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: _saving ? null : () => _saveDraft(encounter),
                    child: Text(_saving ? 'Saving...' : 'Save Draft'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    onPressed: _saving ? null : () => _completeEncounter(encounter),
                    child: Text(_saving ? 'Saving...' : 'Complete Encounter'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.foreground),
        ),
      ],
    );
  }

  Widget _buildVitalField(String label, String unit, TextEditingController controller, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: colors.mutedForeground),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 10, color: colors.mutedForeground)),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            placeholder: Text(unit, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
          ),
        ],
      ),
    );
  }

  void _searchDiagnoses(String query) {
    if (query.trim().isEmpty) {
      setState(() => _diagnosisResults = []);
      return;
    }
    final q = query.trim().toLowerCase();
    final results = _icd10Codes.entries
        .where((e) => e.key.toLowerCase().contains(q) || e.value.toLowerCase().contains(q))
        .map((e) => {'code': e.key, 'display': e.value})
        .take(10)
        .toList();
    setState(() => _diagnosisResults = results);
  }

  Future<void> _saveDraft(EncounterLocal encounter) async {
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final patientRef = encounter.patientRef;

      // Save vitals as Observations
      await _saveVitals(now, patientRef);

      // Save diagnoses as Condition resources
      for (final d in _selectedDiagnoses) {
        final condId = 'condition-${now.millisecondsSinceEpoch}-${d['code']}';
        final condJson = {
          'resourceType': 'Condition',
          'id': condId,
          'clinicalStatus': {
            'coding': [
              {'system': 'http://terminology.hl7.org/CodeSystem/condition-clinical', 'code': 'active'},
            ],
          },
          'code': {
            'coding': [
              {'system': 'http://hl7.org/fhir/sid/icd-10', 'code': d['code'], 'display': d['display']},
            ],
            'text': d['display'],
          },
          'subject': {'reference': patientRef},
          'encounter': {'reference': 'Encounter/${encounter.fhirId}'},
          'recordedDate': now.toIso8601String(),
        };
        await DatabaseService.fhirResources.add(
          FhirResource()
            ..fhirId = condId
            ..resourceType = 'Condition'
            ..jsonData = jsonEncode(condJson)
            ..patientReference = patientRef
            ..category = 'diagnosis'
            ..syncStatus = 1
            ..isDownloadedOffline = false
            ..lastUpdated = now
            ..createdAt = now,
        );
      }

      // Build SOAP note text
      final soapParts = <String>[];
      if (_ccController.text.trim().isNotEmpty) soapParts.add('S - CC: ${_ccController.text.trim()}');
      if (_hpiController.text.trim().isNotEmpty) soapParts.add('S - HPI: ${_hpiController.text.trim()}');
      if (_peNotesController.text.trim().isNotEmpty) soapParts.add('O - PE: ${_peNotesController.text.trim()}');
      if (_selectedDiagnoses.isNotEmpty) {
        soapParts.add('A - Dx: ${_selectedDiagnoses.map((d) => '${d['code']} ${d['display']}').join('; ')}');
      }
      if (_medicationController.text.trim().isNotEmpty) soapParts.add('P - Med: ${_medicationController.text.trim()}');
      if (_labOrderController.text.trim().isNotEmpty) soapParts.add('P - Lab: ${_labOrderController.text.trim()}');
      if (_imagingOrderController.text.trim().isNotEmpty) soapParts.add('P - Imaging: ${_imagingOrderController.text.trim()}');
      if (_referralController.text.trim().isNotEmpty) soapParts.add('P - Referral: ${_referralController.text.trim()}');
      if (_followUpDate != null || _followUpController.text.trim().isNotEmpty) {
        soapParts.add(
          'P - Follow-up: ${_followUpDate != null ? DateFormat('MMM d, yyyy').format(_followUpDate!) : ''} ${_followUpController.text.trim()}',
        );
      }

      if (soapParts.isNotEmpty) {
        final noteId = 'soap-${now.millisecondsSinceEpoch}';
        final noteJson = {
          'resourceType': 'Observation',
          'id': noteId,
          'status': 'preliminary',
          'code': {
            'coding': [
              {'system': 'http://loinc.org', 'code': '34109-9', 'display': 'SOAP Note'},
            ],
            'text': 'SOAP Note',
          },
          'subject': {'reference': patientRef},
          'encounter': {'reference': 'Encounter/${encounter.fhirId}'},
          'effectiveDateTime': now.toIso8601String(),
          'valueString': soapParts.join('\n'),
        };
        await DatabaseService.fhirResources.add(
          FhirResource()
            ..fhirId = noteId
            ..resourceType = 'Observation'
            ..jsonData = jsonEncode(noteJson)
            ..patientReference = patientRef
            ..category = 'clinical-note'
            ..syncStatus = 1
            ..isDownloadedOffline = false
            ..lastUpdated = now
            ..createdAt = now,
        );
      }

      // Update encounter notes
      encounter.notes = soapParts.join('\n\n');
      encounter.updatedAt = now;
      await encounter.save();

      if (!mounted) return;
      final toastColors = Theme.of(context).colorScheme;
      showToast(
        context: context,
        builder: (c, o) => SurfaceCard(
          child: Basic(
            leading: Icon(LucideIcons.circleCheck, size: 18, color: toastColors.success),
            title: const Text('Draft saved'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _completeEncounter(EncounterLocal encounter) async {
    // Save draft first
    await _saveDraft(encounter);

    // Mark encounter as finished
    encounter.status = 'finished';
    encounter.endDate = DateTime.now();
    encounter.updatedAt = DateTime.now();
    await encounter.save();

    if (!mounted) return;
    context.go('/clinical/summary/${widget.encounterId}');
  }

  Future<void> _saveVitals(DateTime now, String patientRef) async {
    void saveObs(String code, String display, String rawValue, String unit, String unitCode) {
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
              {'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'vital-signs', 'display': 'Vital Signs'},
            ],
          },
        ],
        'code': {
          'coding': [
            {'system': 'http://loinc.org', 'code': code, 'display': display},
          ],
        },
        'subject': {'reference': patientRef},
        'encounter': {'reference': 'Encounter/${widget.encounterId}'},
        'effectiveDateTime': now.toIso8601String(),
        'valueQuantity': {'value': numVal, 'unit': unit, 'system': 'http://unitsofmeasure.org', 'code': unitCode},
      });

      DatabaseService.fhirResources.add(
        FhirResource()
          ..fhirId = id
          ..resourceType = 'Observation'
          ..jsonData = json
          ..patientReference = patientRef
          ..category = 'vital-signs'
          ..syncStatus = 1
          ..isDownloadedOffline = false
          ..lastUpdated = now
          ..createdAt = now,
      );
    }

    saveObs('8867-4', 'Heart Rate', _hrController.text, 'bpm', '/min');
    saveObs('8480-6', 'Systolic BP', _sysController.text, 'mmHg', 'mm[Hg]');
    saveObs('8462-4', 'Diastolic BP', _diaController.text, 'mmHg', 'mm[Hg]');
    saveObs('8310-5', 'Temperature', _tempController.text, '°C', 'Cel');
    saveObs('2708-6', 'SpO2', _spo2Controller.text, '%', '%');
    saveObs('9279-1', 'Respiratory Rate', _rrController.text, '/min', '/min');
    saveObs('29463-7', 'Body Weight', _weightController.text, 'kg', 'kg');
    saveObs('8302-2', 'Body Height', _heightController.text, 'cm', 'cm');
  }
}
