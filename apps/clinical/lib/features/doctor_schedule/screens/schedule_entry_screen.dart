import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class ScheduleEntryScreen extends ConsumerStatefulWidget {
  const ScheduleEntryScreen({super.key});

  @override
  ConsumerState<ScheduleEntryScreen> createState() => _ScheduleEntryScreenState();
}

class _ScheduleEntryScreenState extends ConsumerState<ScheduleEntryScreen> {
  String _selectedFacility = 'City Central Hospital';
  int _selectedDurationIndex = 0;
  bool _allowEmergencyOverride = false;
  bool _enableTelehealth = false;

  final _dateController = TextEditingController(text: 'Oct 28, 2024');
  final _startTimeController = TextEditingController(text: '08:00 AM');
  final _endTimeController = TextEditingController(text: '04:00 PM');
  final _bufferController = TextEditingController(text: '5');

  final List<String> _facilities = [
    'City Central Hospital',
    'St. Jude Medical Center',
  ];

  final List<String> _durations = ['15m', '30m', '45m', '60m'];
  final List<int> _durationMinutes = [15, 30, 45, 60];

  int get _calculatedSlots {
    const totalMinutes = 480;
    final slotMin = _durationMinutes[_selectedDurationIndex];
    final buffer = int.tryParse(_bufferController.text) ?? 0;
    if (slotMin + buffer <= 0) return 0;
    return totalMinutes ~/ (slotMin + buffer);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _bufferController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return SubPageScaffold(
      title: 'Add Schedule',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Date field --
            _buildLabel('Date'),
            const SizedBox(height: AppSpacing.sm),
            shadcn.TextField(
              controller: _dateController,
              placeholder: const Text('Select date'),
              features: [
                shadcn.InputFeature.trailing(
                  Icon(Icons.calendar_today,
                      color: colors.mutedForeground, size: 18),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Facility dropdown --
            _buildLabel('Facility'),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: shadcn.Select<String>(
                value: _selectedFacility,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedFacility = val);
                },
                itemBuilder: (context, item) => Text(item),
                // ignore: implicit_call_tearoffs
                popup: shadcn.SelectPopup(
                  items: shadcn.SelectItemList(
                    children: _facilities
                        .map((f) => shadcn.SelectItemButton(
                              value: f,
                              child: Text(f),
                            ))
                        .toList(),
                  ),
                ),
                placeholder: const Text('Select facility'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Start / End time --
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Time'),
                      const SizedBox(height: AppSpacing.sm),
                      shadcn.TextField(
                        controller: _startTimeController,
                        placeholder: const Text('08:00 AM'),
                        features: [
                          shadcn.InputFeature.trailing(
                            Icon(Icons.access_time,
                                color: colors.mutedForeground, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('End Time'),
                      const SizedBox(height: AppSpacing.sm),
                      shadcn.TextField(
                        controller: _endTimeController,
                        placeholder: const Text('04:00 PM'),
                        features: [
                          shadcn.InputFeature.trailing(
                            Icon(Icons.access_time,
                                color: colors.mutedForeground, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Slot Duration chips --
            _buildLabel('Slot Duration'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: List.generate(_durations.length, (i) {
                final isSelected = i == _selectedDurationIndex;
                return shadcn.Chip(
                  onPressed: () =>
                      setState(() => _selectedDurationIndex = i),
                  child: Text(
                    _durations[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? colors.primary
                          : colors.mutedForeground,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Buffer time --
            _buildLabel('Buffer Time (minutes)'),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: 120,
              child: shadcn.TextField(
                controller: _bufferController,
                placeholder: const Text('5'),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Toggles --
            _buildToggleRow(
              value: _allowEmergencyOverride,
              label: 'Allow Emergency Override Slots',
              onChanged: (v) {
                setState(() => _allowEmergencyOverride = v);
                shadcn.showToast(
                  context: context,
                  builder: (ctx, overlay) => shadcn.SurfaceCard(
                    child: Text(v
                        ? 'Emergency override enabled'
                        : 'Emergency override disabled'),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildToggleRow(
              value: _enableTelehealth,
              label: 'Enable Telehealth',
              onChanged: (v) {
                setState(() => _enableTelehealth = v);
                shadcn.showToast(
                  context: context,
                  builder: (ctx, overlay) => shadcn.SurfaceCard(
                    child: Text(
                        v ? 'Telehealth enabled' : 'Telehealth disabled'),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Live preview card --
            shadcn.Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              fillColor: colors.primary.withValues(alpha: 0.06),
              child: Row(
                children: [
                  Icon(Icons.preview, color: colors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SCHEDULE PREVIEW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_calculatedSlots available ${_durations[_selectedDurationIndex]} slots',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: colors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // -- Save button --
            SizedBox(
              width: double.infinity,
              child: shadcn.Button.primary(
                onPressed: () async {
                  // Validate required fields
                  if (_dateController.text.trim().isEmpty ||
                      _startTimeController.text.trim().isEmpty ||
                      _endTimeController.text.trim().isEmpty) {
                    shadcn.showToast(
                      context: context,
                      builder: (ctx, overlay) => shadcn.SurfaceCard(
                        child: shadcn.Basic(
                          leading: Icon(Icons.warning_amber, color: colors.warning),
                          title: const Text('Please fill in all required fields'),
                        ),
                      ),
                    );
                    return;
                  }

                  final user = ref.read(authProvider).user;
                  final practRef = user?.fhirPractitionerId ?? user?.id ?? 'unknown';

                  final slot = ScheduleSlotLocal()
                    ..practitionerRef = practRef
                    ..date = DateTime.now()
                    ..startTime = _startTimeController.text.trim()
                    ..endTime = _endTimeController.text.trim()
                    ..slotDurationMinutes = _durationMinutes[_selectedDurationIndex]
                    ..maxPatients = _calculatedSlots
                    ..bookedCount = 0
                    ..facilityName = _selectedFacility
                    ..isEmergencyOverride = _allowEmergencyOverride
                    ..isTelehealth = _enableTelehealth
                    ..status = 'available'
                    ..createdAt = DateTime.now()
                    ..syncStatus = 1;

                  await DatabaseService.scheduleSlots.add(slot);

                  if (!mounted) return;
                  shadcn.showToast(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (ctx, overlay) => shadcn.SurfaceCard(
                      child: shadcn.Basic(
                        leading: Icon(Icons.check_circle, color: colors.success),
                        title: const Text('Schedule saved'),
                        subtitle: const Text('Your schedule entry has been created'),
                      ),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 600), () {
                    // ignore: use_build_context_synchronously
                    if (mounted) context.pop();
                  });
                },
                child: const Text('Save Schedule'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // -- Helpers --

  Widget _buildLabel(String text) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: colors.mutedForeground,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildToggleRow({
    required bool value,
    required String label,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          shadcn.Checkbox(
            state: value
                ? shadcn.CheckboxState.checked
                : shadcn.CheckboxState.unchecked,
            onChanged: (state) {
              onChanged(state == shadcn.CheckboxState.checked);
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
