import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_data/providers/practitioner_data_provider.dart';

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

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _bufferController = TextEditingController(text: '5');
  String? _timeError;

  final List<String> _facilities = ['City Central Hospital', 'St. Jude Medical Center'];

  final List<String> _durations = ['15m', '30m', '45m', '60m'];
  final List<int> _durationMinutes = [15, 30, 45, 60];

  int get _calculatedSlots {
    const totalMinutes = 480;
    final slotMin = _durationMinutes[_selectedDurationIndex];
    final buffer = int.tryParse(_bufferController.text) ?? 0;
    if (slotMin + buffer <= 0) return 0;
    return totalMinutes ~/ (slotMin + buffer);
  }

  void _validateTimes() {
    if (_startTime != null && _endTime != null) {
      final start = _startTime!.hour * 60 + _startTime!.minute;
      final end = _endTime!.hour * 60 + _endTime!.minute;
      if (end <= start) {
        setState(() => _timeError = 'End time must be after start time');
      } else {
        setState(() => _timeError = null);
      }
    } else {
      setState(() => _timeError = null);
    }
  }

  @override
  void dispose() {
    _bufferController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SubPageScaffold(
      title: 'Add Schedule',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Date field with DatePicker in popover mode --
            _buildLabel('Date'),
            const SizedBox(height: AppSpacing.sm),
            DatePicker(
              value: _selectedDate,
              onChanged: (date) => setState(() => _selectedDate = date),
              placeholder: const Text('Select a date'),
              mode: PromptMode.popover,
              stateBuilder: (date) {
                final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                return isPast ? DateState.disabled : DateState.enabled;
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Facility dropdown --
            _buildLabel('Facility'),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: Select<String>(
                value: _selectedFacility,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedFacility = val);
                },
                itemBuilder: (context, item) => Text(item),
                popup: SelectPopup(
                  items: SelectItemList(
                    children: _facilities.map((f) => SelectItemButton(value: f, child: Text(f))).toList(),
                  ),
                ),
                placeholder: const Text('Select facility'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Start / End time with TimePicker in popover mode --
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Time'),
                      const SizedBox(height: AppSpacing.sm),
                      TimePicker(
                        value: _startTime,
                        onChanged: (time) {
                          setState(() => _startTime = time);
                          _validateTimes();
                        },
                        placeholder: const Text('Start time'),
                        mode: PromptMode.popover,
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
                      TimePicker(
                        value: _endTime,
                        onChanged: (time) {
                          setState(() => _endTime = time);
                          _validateTimes();
                        },
                        placeholder: const Text('End time'),
                        mode: PromptMode.popover,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_timeError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_timeError!, style: TextStyle(fontSize: 11, color: colors.destructive)),
            ],
            const SizedBox(height: AppSpacing.xxl),

            // -- Slot Duration chips --
            _buildLabel('Slot Duration'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: List.generate(_durations.length, (i) {
                final isSelected = i == _selectedDurationIndex;
                return Chip(
                  onPressed: () => setState(() => _selectedDurationIndex = i),
                  child: Text(
                    _durations[i],
                    style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? colors.primary : colors.mutedForeground),
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
              child: TextField(controller: _bufferController, placeholder: const Text('5'), onChanged: (_) => setState(() {})),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Toggles --
            _buildToggleRow(
              value: _allowEmergencyOverride,
              label: 'Allow Emergency Override Slots',
              onChanged: (v) {
                setState(() => _allowEmergencyOverride = v);
                showToast(
                  context: context,
                  builder: (ctx, overlay) => SurfaceCard(child: Text(v ? 'Emergency override enabled' : 'Emergency override disabled')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildToggleRow(
              value: _enableTelehealth,
              label: 'Enable Telehealth',
              onChanged: (v) {
                setState(() => _enableTelehealth = v);
                showToast(
                  context: context,
                  builder: (ctx, overlay) => SurfaceCard(child: Text(v ? 'Telehealth enabled' : 'Telehealth disabled')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Live preview card --
            Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              fillColor: colors.primary.withValues(alpha: 0.06),
              child: Row(
                children: [
                  Icon(LucideIcons.eye, color: colors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SCHEDULE PREVIEW',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primary, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_calculatedSlots available ${_durations[_selectedDurationIndex]} slots',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.foreground),
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
              child: Button.primary(
                onPressed: () async {
                  // Validate required fields
                  if (_selectedDate == null || _startTime == null || _endTime == null) {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          leading: Icon(LucideIcons.triangleAlert, color: colors.warning),
                          title: const Text('Please fill in all required fields'),
                        ),
                      ),
                    );
                    return;
                  }
                  if (_timeError != null) {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          leading: Icon(LucideIcons.triangleAlert, color: colors.warning),
                          title: Text(_timeError!),
                        ),
                      ),
                    );
                    return;
                  }

                  final user = ref.read(authProvider).user;
                  final practRef = user?.fhirPractitionerId ?? user?.id ?? 'unknown';
                  // Ensure practitionerRef has the Practitionr/ prefix so the provider query matches
                  final fullPractRef = practRef.startsWith('Practitioner/') ? practRef : 'Practitioner/$practRef';

                  final startStr = _formatTimeOfDay(_startTime!);
                  final endStr = _formatTimeOfDay(_endTime!);

                  final slot = ScheduleSlotLocal()
                    ..practitionerRef = fullPractRef
                    ..date = _selectedDate!
                    ..startTime = startStr
                    ..endTime = endStr
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

                  // Bump the slot refresh provider so the timesheet re-reads from Hive
                  ref.read(slotRefreshProvider.notifier).state++;

                  if (!mounted) return;
                  showToast(
                    context: context,
                    builder: (ctx, overlay) => SurfaceCard(
                      child: Basic(
                        leading: Icon(LucideIcons.circleCheck, color: colors.success),
                        title: const Text('Schedule saved'),
                        subtitle: const Text('Your schedule entry has been created'),
                      ),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 600), () {
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

  String _formatTimeOfDay(TimeOfDay t) {
    final minute = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'AM' : 'PM';
    final hr12 = t.hour == 0 ? 12 : (t.hour > 12 ? t.hour - 12 : t.hour);
    return '${hr12.toString().padLeft(2, '0')}:$minute $ampm';
  }

  Widget _buildLabel(String text) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.mutedForeground, letterSpacing: 0.3),
    );
  }

  Widget _buildToggleRow({required bool value, required String label, required ValueChanged<bool> onChanged}) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Checkbox(
            state: value ? CheckboxState.checked : CheckboxState.unchecked,
            onChanged: (state) {
              onChanged(state == CheckboxState.checked);
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.foreground),
            ),
          ),
        ],
      ),
    );
  }
}
