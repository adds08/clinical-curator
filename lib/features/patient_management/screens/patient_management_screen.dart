import 'package:fhir/r4.dart' as fhir;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../domain/providers/patient_data_provider.dart';
import '../../../domain/providers/practitioner_data_provider.dart';

class PatientManagementScreen extends ConsumerStatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  ConsumerState<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends ConsumerState<PatientManagementScreen> {
  String _searchQuery = '';
  String _sortBy = 'latest';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final patients = ref.watch(allPatientsProvider);

    // Build display data from FHIR Patient resources
    var displayPatients = patients.map((p) {
      final fhirId = p.fhirId?.toString() ?? '';
      final patientRef = 'Patient/$fhirId';
      final name = _extractName(p);
      final initials = name.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
      final gender = p.gender?.toString() ?? '';
      final birthDate = p.birthDate?.toString() ?? '';
      final pid = _extractPid(p);

      // Get latest vitals from providers
      final hr = ref.watch(latestHeartRateProvider(patientRef));
      final bp = ref.watch(latestBloodPressureProvider(patientRef));

      return _PatientData(fhirId: fhirId, name: name, initials: initials, pid: pid, gender: gender, birthDate: birthDate, hr: hr, bp: bp);
    }).toList();

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayPatients = displayPatients.where((p) => p.name.toLowerCase().contains(q) || p.pid.toLowerCase().contains(q)).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'name_asc':
        displayPatients.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        displayPatients.sort((a, b) => b.name.compareTo(a.name));
        break;
      default:
        break;
    }

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, displayPatients.length),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(child: _buildSearchBar()),
                        const SizedBox(width: AppSpacing.sm),
                        _buildSortRow(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Expanded(
                      child: SingleChildScrollView(
                        child: displayPatients.isEmpty
                            ? _buildEmptyState()
                            : Column(
                                children:
                                    displayPatients
                                        .map(
                                          (p) => Padding(
                                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                            child: _buildPatientCard(context, p),
                                          ),
                                        )
                                        .toList()
                                      ..add(
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                                          child: Container(),
                                        ),
                                      ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.xl,
              bottom: AppSpacing.xl,
              child: PrimaryButton(
                onPressed: () => context.push(RouteNames.addPatient),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Text('New Intake', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int patientCount) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Directory',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.foreground, letterSpacing: -0.5),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Manage clinical intakes, assigned patient records, and real-time medical updates.',
          style: TextStyle(fontSize: 12, color: colors.mutedForeground, height: 1.4),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryBadge(
          child: Text('$patientCount Patients', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: _searchController,
      placeholder: const Text('Search by name or ID...'),
      filled: true,
      borderRadius: AppRadius.cardRadius,
      features: [InputFeature.leading(Icon(Icons.search, color: colors.mutedForeground, size: 20))],
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  String get _sortLabel {
    switch (_sortBy) {
      case 'name_asc':
        return 'Name A-Z';
      case 'name_desc':
        return 'Name Z-A';
      default:
        return 'Latest';
    }
  }

  static const _sortCycle = ['latest', 'name_asc', 'name_desc'];

  Widget _buildSortRow() {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final i = _sortCycle.indexOf(_sortBy);
            setState(() => _sortBy = _sortCycle[(i + 1) % _sortCycle.length]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_vert, size: 14, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  _sortLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 40, color: colors.mutedForeground.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No patients found',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Add a new intake to get started', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, _PatientData patient) {
    final colors = Theme.of(context).colorScheme;
    final hasVitals = patient.hr != '--' || patient.bp != '--/--';

    return GestureDetector(
      onTap: () => context.push('/patient-detail/${patient.fhirId}'),
      child: Card(
        padding: const EdgeInsets.all(AppSpacing.lg),
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        borderRadius: AppRadius.cardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(initials: patient.initials, size: 40, backgroundColor: colors.primary.withValues(alpha: 0.1)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            patient.pid,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                          ),
                          if (patient.gender.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              patient.gender[0].toUpperCase() + patient.gender.substring(1),
                              style: TextStyle(fontSize: 11, color: colors.mutedForeground),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasVitals) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: SurfaceTheme.colorFor(SurfaceLevel.low, context), borderRadius: AppRadius.inputRadius),
                child: Row(
                  children: [
                    if (patient.hr != '--') _buildVitalPill('HR', patient.hr, _hrColor(patient.hr, colors)),
                    if (patient.hr != '--' && patient.bp != '--/--') const SizedBox(width: AppSpacing.sm),
                    if (patient.bp != '--/--') _buildVitalPill('BP', patient.bp, colors.foreground),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    density: ButtonDensity.normal,
                    onPressed: () => context.push('/patient-detail/${patient.fhirId}'),
                    leading: const Icon(Icons.description_outlined, size: 13),
                    child: const Text('View Summary', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PrimaryButton(
                    density: ButtonDensity.normal,
                    onPressed: () => context.push('/patient-detail/${patient.fhirId}'),
                    leading: const Icon(Icons.medical_services_outlined, size: 13),
                    child: const Text('Checkup', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalPill(String label, String value, Color valueColor) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: SurfaceTheme.colorFor(SurfaceLevel.lowest, context), borderRadius: AppRadius.chipRadius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: colors.mutedForeground),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: valueColor),
          ),
        ],
      ),
    );
  }

  Color _hrColor(String hr, ColorScheme colors) {
    final val = int.tryParse(hr);
    if (val == null) return colors.foreground;
    if (val > 100 || val < 50) return colors.destructive;
    return colors.success;
  }

  String _extractName(fhir.Patient p) {
    if (p.name != null && p.name!.isNotEmpty) {
      final n = p.name!.first;
      if (n.text != null) return n.text!;
      final given = n.given?.join(' ') ?? '';
      final family = n.family ?? '';
      return '$given $family'.trim();
    }
    return 'Unknown';
  }

  String _extractPid(fhir.Patient p) {
    if (p.identifier != null) {
      for (final id in p.identifier!) {
        if (id.system?.toString() == 'urn:clinical-curator:patient-id') {
          return id.value ?? 'No ID';
        }
      }
    }
    return p.fhirId?.toString() ?? 'No ID';
  }
}

class _PatientData {
  final String fhirId;
  final String name;
  final String initials;
  final String pid;
  final String gender;
  final String birthDate;
  final String hr;
  final String bp;

  const _PatientData({
    required this.fhirId,
    required this.name,
    required this.initials,
    required this.pid,
    required this.gender,
    required this.birthDate,
    required this.hr,
    required this.bp,
  });
}
