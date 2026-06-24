import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/practitioner_role_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/practitioner_role_provider.dart';
import '../../../domain/providers/slot_availability_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../shared/widgets/practitioner_verified_badge.dart';

class TelemedicineScreen extends ConsumerStatefulWidget {
  const TelemedicineScreen({super.key});

  @override
  ConsumerState<TelemedicineScreen> createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends ConsumerState<TelemedicineScreen> {
  final _searchController = TextEditingController();
  int _selectedCategory = 0;

  static const List<String> _specialties = [
    'All',
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Ophthalmology',
    'Internal Med',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PractitionerRoleLocal> _filterDoctors(List<PractitionerRoleLocal> all) {
    final selectedSpecialty = _specialties[_selectedCategory];
    final query = _searchController.text.trim().toLowerCase();

    return all.where((r) {
      // Only doctors (practitionerType == 'doctor') if available, else all active
      // PractitionerRoleLocal doesn't carry practitionerType directly — the
      // collection models a role; filter by active which is already applied
      // in the provider.
      if (selectedSpecialty != 'All' && r.specialty != selectedSpecialty) {
        return false;
      }
      if (query.isNotEmpty) {
        final name = (r.practitionerName ?? '').toLowerCase();
        final spec = (r.specialty ?? '').toLowerCase();
        if (!name.contains(query) && !spec.contains(query)) return false;
      }
      return true;
    }).toList();
  }

  String _initials(String name) {
    final clean = name.replaceAll(RegExp(r'^Dr\.\s*'), '');
    final parts = clean.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  String _formatSlotLabel(DateTime date, String startTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    String prefix;
    if (dateOnly == today) {
      prefix = 'Today';
    } else if (dateOnly == tomorrow) {
      prefix = 'Tomorrow';
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      prefix = '${months[date.month - 1]} ${date.day}';
    }
    return '$prefix, $startTime';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final allRoles = ref.watch(allPractitionerRolesProvider);
    final doctors = _filterDoctors(allRoles);

    return SubPageScaffold(
      title: 'Telemedicine',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Search bar --
            TextField(
              controller: _searchController,
              placeholder: const Text('Search specialists...'),
              onChanged: (_) => setState(() {}),
              features: [
                InputFeature.leading(
                  Icon(LucideIcons.search,
                      color: colors.mutedForeground, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // -- Category chips --
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _specialties.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final selected = i == _selectedCategory;
                  return Chip(
                    onPressed: () =>
                        setState(() => _selectedCategory = i),
                    child: Text(
                      _specialties[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? colors.primary
                            : colors.mutedForeground,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Header --
            Text(
              'Available Specialists',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.foreground,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // -- Specialists grid or empty state --
            if (doctors.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(LucideIcons.stethoscope,
                        size: 40,
                        color: colors.mutedForeground.withValues(alpha: 0.4)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No specialists available',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.68,
                ),
                itemCount: doctors.length,
                itemBuilder: (context, i) => _buildDoctorCard(doctors[i]),
              ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Quick consult section --
            Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              fillColor: colors.primary.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.zap,
                          color: colors.primary, size: 22),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Quick Consult',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.foreground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Connect with the next available specialist instantly.',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.mutedForeground,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: Button.primary(
                      onPressed: doctors.isEmpty
                          ? null
                          : () {
                              final next = doctors.first;
                              showToast(
                                context: context,
                                builder: (ctx, overlay) => SurfaceCard(
                                  child: Basic(
                                    leading: Icon(LucideIcons.video,
                                        color: colors.primary),
                                    title: const Text(
                                        'Finding available specialist...'),
                                    subtitle: const Text(
                                        'You will be connected shortly'),
                                  ),
                                ),
                              );
                              Future.delayed(
                                  const Duration(milliseconds: 1200), () {
                                if (mounted) {
                                  final name = next.practitionerName != null
                                      ? 'Dr. ${next.practitionerName}'
                                      : null;
                                  final params = <String, String>{};
                                  if (name != null) params['name'] = name;
                                  if (next.specialty != null) {
                                    params['specialty'] = next.specialty!;
                                  }
                                  final uri = Uri(
                                    path: RouteNames.serviceTelemedicineCall,
                                    queryParameters:
                                        params.isEmpty ? null : params,
                                  );
                                  // ignore: use_build_context_synchronously
                                  context.push(uri.toString());
                                }
                              });
                            },
                      leading: const Icon(LucideIcons.video, size: 20),
                      child: const Text('Start Quick Consult'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(PractitionerRoleLocal doctor) {
    final colors = Theme.of(context).colorScheme;
    final name = doctor.practitionerName ?? 'Unknown';
    final displayName = name.startsWith('Dr.') ? name : 'Dr. $name';
    final specialty = doctor.specialty ?? 'General';
    final slots = ref.watch(availableSlotsProvider(doctor.practitionerRef));
    final nextSlotLabel = slots.isNotEmpty
        ? _formatSlotLabel(slots.first.date, slots.first.startTime)
        : null;

    return Card(
      padding: const EdgeInsets.all(AppSpacing.md),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Avatar(initials: _initials(name), size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialty,
            style: TextStyle(
              fontSize: 11,
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          PractitionerVerifiedBadge(practitionerRef: doctor.practitionerRef),
          const SizedBox(height: AppSpacing.sm),
          if (nextSlotLabel != null)
            Text(
              'Next: $nextSlotLabel',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            )
          else
            Text(
              'No slots available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.mutedForeground,
              ),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              onPressed: slots.isEmpty
                  ? null
                  : () async {
                      final user = ref.read(authProvider).user;
                      final patientRef =
                          user?.fhirPatientId ?? user?.id ?? '';
                      final patientName = user?.displayName ?? 'Patient';
                      final slot = slots.first;

                      final appointment = AppointmentLocal()
                        ..patientRef = patientRef
                        ..practitionerRef = doctor.practitionerRef
                        ..practitionerName = displayName
                        ..patientName = patientName
                        ..appointmentType = 'telemedicine'
                        ..status = 'booked'
                        ..scheduledAt = slot.date
                        ..durationMinutes = 30
                        ..specialty = specialty
                        ..createdAt = DateTime.now()
                        ..syncStatus = 1;

                      await DatabaseService.appointments.add(appointment);

                      if (!context.mounted) return;
                      showToast(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (ctx, overlay) => SurfaceCard(
                          child: Basic(
                            leading: Icon(LucideIcons.circleCheck,
                                color: colors.success),
                            title: Text('Booking confirmed with $displayName'),
                            subtitle: Text(nextSlotLabel ?? ''),
                          ),
                        ),
                      );
                    },
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
