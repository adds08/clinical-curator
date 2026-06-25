import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

class PharmacyDispenseScreen extends ConsumerStatefulWidget {
  const PharmacyDispenseScreen({super.key});

  @override
  ConsumerState<PharmacyDispenseScreen> createState() => _PharmacyDispenseScreenState();
}

class _PharmacyDispenseScreenState extends ConsumerState<PharmacyDispenseScreen> {
  late TextEditingController _patientController;
  late TextEditingController _medicationController;
  late TextEditingController _strengthController;
  late TextEditingController _quantityController;
  late TextEditingController _instructionsController;
  String _form = 'Tablet';
  String _status = 'Dispensed';

  final _forms = ['Tablet', 'Capsule', 'Syrup', 'Injection', 'Cream', 'Drops', 'Inhaler'];
  final _statuses = ['Dispensed', 'Pending', 'Partial'];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _patientController = TextEditingController();
    _medicationController = TextEditingController();
    _strengthController = TextEditingController();
    _quantityController = TextEditingController();
    _instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _patientController.dispose();
    _medicationController.dispose();
    _strengthController.dispose();
    _quantityController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: colors.background,
          leading: [
            IconButton.ghost(icon: const Icon(LucideIcons.arrowLeft, size: 22), onPressed: () => Navigator.of(context).pop()),
            const SizedBox(width: 4),
            Text(
              'Dispense Medication',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
          ],
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _patientController, placeholder: const Text('Patient reference')),
            const SizedBox(height: AppSpacing.md),
            TextField(controller: _medicationController, placeholder: const Text('Medication name')),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: _strengthController, placeholder: const Text('Strength')),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(controller: _quantityController, placeholder: const Text('Quantity')),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(controller: _instructionsController, placeholder: const Text('Instructions / Sig'), maxLines: 2),
            const SizedBox(height: AppSpacing.md),
            PrimaryBadge(child: Text('Form: $_form · Status: $_status')),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: _saving ? null : () => _saveDispense(),
                child: Text(_saving ? 'Saving...' : 'Record Dispensation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDispense() async {
    if (_patientController.text.trim().isEmpty || _medicationController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final id = 'disp-${now.millisecondsSinceEpoch}';
      final json = {
        'resourceType': 'MedicationDispense',
        'id': id,
        'status': _status.toLowerCase(),
        'medicationCodeableConcept': {'text': '${_medicationController.text.trim()} ${_strengthController.text.trim()}'},
        'subject': {'reference': _patientController.text.trim()},
        'dosageInstruction': [
          {'text': _instructionsController.text.trim()},
        ],
        'quantity': {'value': int.tryParse(_quantityController.text) ?? 0, 'unit': _form},
        'whenHandedOver': now.toIso8601String(),
      };

      final toastColors = Theme.of(context).colorScheme;
      await DatabaseService.fhirResources.add(
        FhirResource()
          ..fhirId = id
          ..resourceType = 'MedicationDispense'
          ..jsonData = jsonEncode(json)
          ..patientReference = _patientController.text.trim()
          ..syncStatus = 1
          ..isDownloadedOffline = false
          ..lastUpdated = now
          ..createdAt = now,
      );

      if (!mounted) return;
      showToast(
        context: context,
        builder: (c, o) => SurfaceCard(
          child: Basic(
            leading: Icon(LucideIcons.circleCheck, size: 18, color: toastColors.success),
            title: const Text('Dispensation recorded'),
          ),
        ),
      );

      _patientController.clear();
      _medicationController.clear();
      _strengthController.clear();
      _quantityController.clear();
      _instructionsController.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
