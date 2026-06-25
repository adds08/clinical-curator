import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

class LabOrderingScreen extends ConsumerStatefulWidget {
  const LabOrderingScreen({super.key});

  @override
  ConsumerState<LabOrderingScreen> createState() => _LabOrderingScreenState();
}

class _LabOrderingScreenState extends ConsumerState<LabOrderingScreen> {
  int _selectedTab = 0;
  static const _tabLabels = ['New Order', 'Results Entry'];

  // New Order fields
  late TextEditingController _patientRefController;
  late TextEditingController _testNameController;
  late TextEditingController _indicationController;
  String _urgency = 'Routine';
  final _urgencies = ['Routine', 'STAT'];

  // Results Entry fields
  late TextEditingController _resultValueController;
  late TextEditingController _resultUnitController;
  late TextEditingController _refRangeController;
  String? _selectedOrderId;
  String _selectedOrderName = '';

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _patientRefController = TextEditingController();
    _testNameController = TextEditingController();
    _indicationController = TextEditingController();
    _resultValueController = TextEditingController();
    _resultUnitController = TextEditingController();
    _refRangeController = TextEditingController();
  }

  @override
  void dispose() {
    _patientRefController.dispose();
    _testNameController.dispose();
    _indicationController.dispose();
    _resultValueController.dispose();
    _resultUnitController.dispose();
    _refRangeController.dispose();
    super.dispose();
  }

  List<FhirResource> _getPendingOrders() {
    final box = DatabaseService.fhirResources;
    return box.values.where((r) => r.resourceType == 'ServiceRequest' && r.syncStatus != 2).toList();
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
              'Lab Orders',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          // Tabs
          Container(
            color: colors.background,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
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
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: selected ? colors.primary : Colors.transparent,
                          borderRadius: AppRadius.chipRadius,
                          border: selected ? null : Border.all(color: colors.border.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _tabLabels[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected ? colors.primaryForeground : colors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(index: _selectedTab, children: [_buildNewOrderTab(colors), _buildResultsTab(colors)]),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrderTab(dynamic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(controller: _patientRefController, placeholder: const Text('Patient reference (e.g. Patient/1)')),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _testNameController, placeholder: const Text('Test name (e.g. CBC, LFT, HbA1c)')),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _indicationController, placeholder: const Text('Clinical indication'), maxLines: 2),
          const SizedBox(height: AppSpacing.md),
          Text('Urgency', style: TextStyle(fontSize: 13, color: colors.mutedForeground)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: _urgencies.map((u) {
              final sel = _urgency == u;
              return GestureDetector(
                onTap: () => setState(() => _urgency = u),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(color: sel ? colors.primary : colors.surfaceLow, borderRadius: AppRadius.chipRadius),
                  child: Text(
                    u,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: sel ? colors.primaryForeground : colors.foreground),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Button.primary(onPressed: _saving ? null : () => _saveOrder(), child: Text(_saving ? 'Saving...' : 'Place Order')),
        ],
      ),
    );
  }

  Widget _buildResultsTab(dynamic colors) {
    final pendingOrders = _getPendingOrders();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Orders',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colors.foreground),
          ),
          const SizedBox(height: AppSpacing.md),
          if (pendingOrders.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Text('No pending orders', style: TextStyle(color: colors.mutedForeground)),
              ),
            )
          else
            ...pendingOrders.map((r) {
              final json = jsonDecode(r.jsonData);
              final testName = json['code']?['text'] ?? json['displayName'] ?? 'Test';
              final isSelected = _selectedOrderId == r.fhirId;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedOrderId = r.fhirId;
                  _selectedOrderName = testName;
                }),
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary.withValues(alpha: 0.05) : colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: colors.primary) : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(testName, style: TextStyle(fontSize: 14, color: colors.foreground)),
                      ),
                      PrimaryBadge(child: Text(r.fhirId, style: const TextStyle(fontSize: 9))),
                    ],
                  ),
                ),
              );
            }),

          if (_selectedOrderId != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Enter Results for $_selectedOrderName',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(controller: _resultValueController, placeholder: const Text('Result value')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _resultUnitController, placeholder: const Text('Unit (e.g. mg/dL)')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: _refRangeController, placeholder: const Text('Reference range (e.g. 70-110)')),
            const SizedBox(height: AppSpacing.md),
            Button.primary(onPressed: _saving ? null : () => _saveResult(), child: Text(_saving ? 'Saving...' : 'Save Result')),
          ],
        ],
      ),
    );
  }

  Future<void> _saveOrder() async {
    if (_patientRefController.text.trim().isEmpty || _testNameController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final id = 'sr-${now.millisecondsSinceEpoch}';
      final json = {
        'resourceType': 'ServiceRequest',
        'id': id,
        'status': 'active',
        'intent': 'order',
        'priority': _urgency.toLowerCase(),
        'code': {'text': _testNameController.text.trim()},
        'subject': {'reference': _patientRefController.text.trim()},
        'reasonCode': [
          {'text': _indicationController.text.trim()},
        ],
        'authoredOn': now.toIso8601String(),
      };

      await DatabaseService.fhirResources.add(
        FhirResource()
          ..fhirId = id
          ..resourceType = 'ServiceRequest'
          ..jsonData = jsonEncode(json)
          ..patientReference = _patientRefController.text.trim()
          ..syncStatus = 1
          ..isDownloadedOffline = false
          ..lastUpdated = now
          ..createdAt = now,
      );

      final toastColors = Theme.of(context).colorScheme;
      if (!mounted) return;
      showToast(
        context: context,
        builder: (c, o) => SurfaceCard(
          child: Basic(
            leading: Icon(LucideIcons.circleCheck, size: 18, color: toastColors.success),
            title: const Text('Lab order placed'),
          ),
        ),
      );

      _testNameController.clear();
      _indicationController.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveResult() async {
    if (_selectedOrderId == null || _resultValueController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final obsId = 'obs-lab-${now.millisecondsSinceEpoch}';
      final json = {
        'resourceType': 'Observation',
        'id': obsId,
        'status': 'final',
        'category': [
          {
            'coding': [
              {'system': 'http://terminology.hl7.org/CodeSystem/observation-category', 'code': 'laboratory'},
            ],
          },
        ],
        'code': {'text': _selectedOrderName},
        'valueQuantity': {'value': double.tryParse(_resultValueController.text) ?? 0, 'unit': _resultUnitController.text.trim()},
        'referenceRange': [
          {'text': _refRangeController.text.trim()},
        ],
        'effectiveDateTime': now.toIso8601String(),
      };

      final toastColors = Theme.of(context).colorScheme;
      await DatabaseService.fhirResources.add(
        FhirResource()
          ..fhirId = obsId
          ..resourceType = 'Observation'
          ..jsonData = jsonEncode(json)
          ..category = 'laboratory'
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
            title: const Text('Result saved'),
          ),
        ),
      );

      _resultValueController.clear();
      _resultUnitController.clear();
      _refRangeController.clear();
      _selectedOrderId = null;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
