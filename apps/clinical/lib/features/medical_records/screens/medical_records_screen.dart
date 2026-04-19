import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fhir/r4.dart' as fhir;

import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/patient_data_provider.dart';

// ---------------------------------------------------------------------------
// Data model for a unified timeline entry
// ---------------------------------------------------------------------------

enum ClinicalCategory {
  lab,
  medication,
  vital,
  immunization,
  allergy,
  diagnosis,
  note,
}

class _TimelineEntry {
  final String title;
  final String subtitle;
  final String detail;
  final String dateLabel;
  final DateTime sortDate;
  final ClinicalCategory category;
  final bool isCritical;

  const _TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.dateLabel,
    required this.sortDate,
    required this.category,
    this.isCritical = false,
  });
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class MedicalRecordsScreen extends ConsumerStatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  ConsumerState<MedicalRecordsScreen> createState() =>
      _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends ConsumerState<MedicalRecordsScreen> {
  String _activeFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const _filters = [
    'All',
    'Labs',
    'Medications',
    'Vitals',
    'Immunizations',
    'Allergies',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final rawId = authState.user?.fhirPatientId ?? '';
    final patientRef = rawId.isNotEmpty ? 'Patient/$rawId' : '';

    final entries = _buildEntries(patientRef, colors);
    final filtered = _applyFilters(entries);
    final grouped = _groupByMonth(filtered);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Medical Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.foreground, letterSpacing: -0.3),
            ),
            const SizedBox(height: 4),
            Text(
              'Your clinical timeline organized by date',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.mutedForeground),
            ),

            const SizedBox(height: 20),

            // Search
            TextField(
              controller: _searchController,
              placeholder: const Text('Search records...'),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 14),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((label) {
                  final isActive = _activeFilter == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _activeFilter = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? colors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? colors.primary : colors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (label != 'All') ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : _categoryColor(_filterToCategory(label) ?? ClinicalCategory.note, colors),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : colors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Timeline
            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Column(
                    children: [
                      Icon(
                        entries.isEmpty ? LucideIcons.fileText : LucideIcons.searchX,
                        size: 40,
                        color: colors.mutedForeground.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        entries.isEmpty
                            ? 'No medical records yet'
                            : 'No records match your filters',
                        style: TextStyle(fontSize: 14, color: colors.mutedForeground),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...grouped.entries.map((group) => _MonthGroup(
                    monthLabel: group.key,
                    entries: group.value,
                    categoryColor: _categoryColor,
                    categoryIcon: _categoryIcon,
                    categoryLabel: _categoryLabel,
                    colors: colors,
                  )),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Build unified entry list from providers + mock fallback
  // -------------------------------------------------------------------------

  List<_TimelineEntry> _buildEntries(String patientRef, ColorScheme colors) {
    final entries = <_TimelineEntry>[];

    if (patientRef.isNotEmpty) {
      _addLabEntries(ref.watch(patientLabsProvider(patientRef)), entries);
      _addMedicationEntries(
          ref.watch(patientMedicationsProvider(patientRef)), entries);
      _addVitalEntries(ref.watch(patientVitalsProvider(patientRef)), entries);
      _addImmunizationEntries(
          ref.watch(patientImmunizationsProvider(patientRef)), entries);
      _addAllergyEntries(
          ref.watch(patientAllergiesProvider(patientRef)), entries);
    }

    entries.sort((a, b) => b.sortDate.compareTo(a.sortDate));
    return entries;
  }

  void _addLabEntries(
      List<fhir.DiagnosticReport> reports, List<_TimelineEntry> out) {
    for (final r in reports) {
      final title = r.code.text ?? 'Lab Result';
      final date = r.effectiveDateTime?.value;
      final conclusion = r.conclusion ?? 'See full report';
      final performer = r.performer?.isNotEmpty == true
          ? r.performer!.first.display ?? ''
          : '';
      final isAbnormal =
          conclusion.toLowerCase().contains('high') ||
          conclusion.toLowerCase().contains('abnormal');

      out.add(_TimelineEntry(
        title: title,
        subtitle: performer.isNotEmpty ? 'Ordered by $performer' : 'Lab',
        detail: conclusion,
        dateLabel: _formatDate(date),
        sortDate: date ?? DateTime(2000),
        category: ClinicalCategory.lab,
        isCritical: isAbnormal,
      ));
    }
  }

  void _addMedicationEntries(
      List<fhir.MedicationRequest> meds, List<_TimelineEntry> out) {
    for (final m in meds) {
      final name = m.medicationCodeableConcept?.text ?? 'Unknown Medication';
      final dosage = m.dosageInstruction?.isNotEmpty == true
          ? m.dosageInstruction!.first.text ?? ''
          : '';
      final prescriber = m.requester?.display ?? '';
      final isActive = m.status?.toString().contains('active') == true;

      out.add(_TimelineEntry(
        title: name,
        subtitle: dosage.isNotEmpty ? dosage : 'Prescription',
        detail: prescriber.isNotEmpty
            ? 'Prescriber: $prescriber${isActive ? " | ACTIVE" : ""}'
            : (isActive ? 'Status: Active' : 'Prescription'),
        dateLabel: _formatDate(m.authoredOn?.value),
        sortDate: m.authoredOn?.value ?? DateTime(2000),
        category: ClinicalCategory.medication,
      ));
    }
  }

  void _addVitalEntries(
      List<fhir.Observation> obs, List<_TimelineEntry> out) {
    for (final o in obs) {
      final name = o.code.text ?? o.code.coding?.first.display ?? 'Vital Sign';
      final value = o.valueQuantity?.value?.value;
      final unit = o.valueQuantity?.unit ?? '';
      final date = o.effectiveDateTime?.value;

      String detail;
      if (value != null) {
        final v =
            value == value.roundToDouble() ? value.toInt().toString() : '$value';
        detail = '$v $unit';
      } else if (o.component != null && o.component!.isNotEmpty) {
        final parts = o.component!.map((c) {
          final cv = c.valueQuantity?.value?.value;
          final cu = c.valueQuantity?.unit ?? '';
          return cv != null ? '${cv.toInt()} $cu' : '';
        }).where((s) => s.isNotEmpty);
        detail = parts.join(' / ');
      } else {
        detail = 'Recorded';
      }

      out.add(_TimelineEntry(
        title: name,
        subtitle: 'Vital Signs',
        detail: detail,
        dateLabel: _formatDate(date),
        sortDate: date ?? DateTime(2000),
        category: ClinicalCategory.vital,
      ));
    }
  }

  void _addImmunizationEntries(
      List<fhir.Immunization> imms, List<_TimelineEntry> out) {
    for (final i in imms) {
      final name = i.vaccineCode.text ?? 'Vaccine';
      final date = i.occurrenceDateTime?.value;
      final location = i.location?.display ?? '';

      out.add(_TimelineEntry(
        title: name,
        subtitle: location.isNotEmpty ? location : 'Immunization',
        detail: 'Administered${location.isNotEmpty ? " at $location" : ""}',
        dateLabel: _formatDate(date),
        sortDate: date ?? DateTime(2000),
        category: ClinicalCategory.immunization,
      ));
    }
  }

  void _addAllergyEntries(
      List<fhir.AllergyIntolerance> allergies, List<_TimelineEntry> out) {
    for (final a in allergies) {
      final name = a.code?.text ?? 'Allergy';
      final severity = a.reaction?.isNotEmpty == true
          ? a.reaction!.first.severity?.toString().split('.').last ?? ''
          : '';
      final manifestation = a.reaction?.isNotEmpty == true &&
              a.reaction!.first.manifestation.isNotEmpty
          ? a.reaction!.first.manifestation.first.text ?? ''
          : '';
      final date = a.recordedDate?.value;

      out.add(_TimelineEntry(
        title: name,
        subtitle: severity.isNotEmpty ? 'Severity: $severity' : 'Allergy',
        detail: manifestation.isNotEmpty
            ? 'Reaction: $manifestation'
            : 'Allergy recorded',
        dateLabel: _formatDate(date),
        sortDate: date ?? DateTime(2000),
        category: ClinicalCategory.allergy,
        isCritical: true,
      ));
    }
  }

  // -------------------------------------------------------------------------
  // Filter + search
  // -------------------------------------------------------------------------

  List<_TimelineEntry> _applyFilters(List<_TimelineEntry> entries) {
    var result = entries;

    if (_activeFilter != 'All') {
      final cat = _filterToCategory(_activeFilter);
      if (cat != null) {
        result = result.where((e) => e.category == cat).toList();
      }
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.subtitle.toLowerCase().contains(query) ||
            e.detail.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  ClinicalCategory? _filterToCategory(String label) {
    switch (label) {
      case 'Labs':
        return ClinicalCategory.lab;
      case 'Medications':
        return ClinicalCategory.medication;
      case 'Vitals':
        return ClinicalCategory.vital;
      case 'Immunizations':
        return ClinicalCategory.immunization;
      case 'Allergies':
        return ClinicalCategory.allergy;
      default:
        return null;
    }
  }

  // -------------------------------------------------------------------------
  // Group entries by month
  // -------------------------------------------------------------------------

  Map<String, List<_TimelineEntry>> _groupByMonth(List<_TimelineEntry> entries) {
    final grouped = <String, List<_TimelineEntry>>{};
    for (final entry in entries) {
      final key = '${_monthsFull[entry.sortDate.month - 1]} ${entry.sortDate.year}';
      grouped.putIfAbsent(key, () => []).add(entry);
    }
    return grouped;
  }

  // -------------------------------------------------------------------------
  // Category visuals
  // -------------------------------------------------------------------------

  Color _categoryColor(ClinicalCategory cat, ColorScheme colors) {
    switch (cat) {
      case ClinicalCategory.lab:
        return colors.primary;
      case ClinicalCategory.medication:
        return colors.success;
      case ClinicalCategory.vital:
        return colors.oxygenSat;
      case ClinicalCategory.immunization:
        return colors.warning;
      case ClinicalCategory.allergy:
        return colors.destructive;
      case ClinicalCategory.diagnosis:
        return colors.destructive;
      case ClinicalCategory.note:
        return colors.mutedForeground;
    }
  }

  IconData _categoryIcon(ClinicalCategory cat) {
    switch (cat) {
      case ClinicalCategory.lab:
        return LucideIcons.microscope;
      case ClinicalCategory.medication:
        return LucideIcons.pill;
      case ClinicalCategory.vital:
        return LucideIcons.heartPulse;
      case ClinicalCategory.immunization:
        return LucideIcons.syringe;
      case ClinicalCategory.allergy:
        return LucideIcons.triangleAlert;
      case ClinicalCategory.diagnosis:
        return LucideIcons.clipboardPlus;
      case ClinicalCategory.note:
        return LucideIcons.stickyNote;
    }
  }

  String _categoryLabel(ClinicalCategory cat) {
    switch (cat) {
      case ClinicalCategory.lab:
        return 'Lab';
      case ClinicalCategory.medication:
        return 'Rx';
      case ClinicalCategory.vital:
        return 'Vital';
      case ClinicalCategory.immunization:
        return 'Vaccine';
      case ClinicalCategory.allergy:
        return 'Allergy';
      case ClinicalCategory.diagnosis:
        return 'Dx';
      case ClinicalCategory.note:
        return 'Note';
    }
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _monthsFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _formatDate(DateTime? date) {
    if (date == null) return '---';
    return '${_months[date.month - 1]} ${date.day}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Month Group — groups entries under a month header
// ─────────────────────────────────────────────────────────────────────────────

class _MonthGroup extends StatelessWidget {
  final String monthLabel;
  final List<_TimelineEntry> entries;
  final Color Function(ClinicalCategory, ColorScheme) categoryColor;
  final IconData Function(ClinicalCategory) categoryIcon;
  final String Function(ClinicalCategory) categoryLabel;
  final ColorScheme colors;

  const _MonthGroup({
    required this.monthLabel,
    required this.entries,
    required this.categoryColor,
    required this.categoryIcon,
    required this.categoryLabel,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Row(
              children: [
                Text(
                  monthLabel,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.mutedForeground, letterSpacing: 0.3),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(height: 1, color: colors.border.withValues(alpha: 0.5)),
                ),
                const SizedBox(width: 10),
                Text(
                  '${entries.length}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                ),
              ],
            ),
          ),

          // Timeline entries
          ...entries.asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            final isLast = index == entries.length - 1;

            return _TimelineEntryCard(
              entry: entry,
              isLast: isLast,
              color: categoryColor(entry.category, colors),
              icon: categoryIcon(entry.category),
              label: categoryLabel(entry.category),
              colors: colors,
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline Entry Card — single record in the timeline
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineEntryCard extends StatelessWidget {
  final _TimelineEntry entry;
  final bool isLast;
  final Color color;
  final IconData icon;
  final String label;
  final ColorScheme colors;

  const _TimelineEntryCard({
    required this.entry,
    required this.isLast,
    required this.color,
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline rail ──
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Icon circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                // Connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.border.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Content card ──
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(14),
                border: entry.isCritical
                    ? Border.all(color: colors.destructive.withValues(alpha: 0.2))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: category tag + date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                      Text(
                        entry.dateLabel,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.mutedForeground),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    entry.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground, height: 1.2),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    entry.subtitle,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.mutedForeground, height: 1.3),
                  ),
                  const SizedBox(height: 8),

                  // Detail value
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: entry.isCritical
                          ? colors.destructive.withValues(alpha: 0.06)
                          : colors.muted.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.detail,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: entry.isCritical ? colors.destructive : colors.foreground,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Allergy warning banner
                  if (entry.category == ClinicalCategory.allergy) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.warningBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.triangleAlert, size: 14, color: colors.warning),
                          const SizedBox(width: 6),
                          Text(
                            'Check drug interactions',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.warning),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
