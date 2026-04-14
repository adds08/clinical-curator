import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';
import 'package:cc_core/theme/clinical_colors.dart';

class TelemedicineScreen extends ConsumerStatefulWidget {
  const TelemedicineScreen({super.key});

  @override
  ConsumerState<TelemedicineScreen> createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends ConsumerState<TelemedicineScreen> {
  final _searchController = TextEditingController();
  int _selectedCategory = 0;

  static const List<String> _specialties = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Ophthalmology',
    'Internal Med',
  ];

  static const List<_DoctorMock> _doctors = [
    _DoctorMock(
      name: 'Dr. Arpan K. Sharma',
      initials: 'AS',
      specialty: 'Cardiology',
      rating: '4.9',
      nextSlot: 'Today, 3:00 PM',
    ),
    _DoctorMock(
      name: 'Dr. Priya Thapa',
      initials: 'PT',
      specialty: 'Dermatology',
      rating: '4.8',
      nextSlot: 'Today, 4:30 PM',
    ),
    _DoctorMock(
      name: 'Dr. Rajesh Koirala',
      initials: 'RK',
      specialty: 'Neurology',
      rating: '4.7',
      nextSlot: 'Tomorrow, 10:00 AM',
    ),
    _DoctorMock(
      name: 'Dr. Sita Gurung',
      initials: 'SG',
      specialty: 'Ophthalmology',
      rating: '4.8',
      nextSlot: 'Today, 5:00 PM',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return SubPageScaffold(
      title: 'Telemedicine',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Search bar --
            shadcn.TextField(
              controller: _searchController,
              placeholder: const Text('Search specialists...'),
              features: [
                shadcn.InputFeature.leading(
                  Icon(Icons.search,
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
                  return shadcn.Chip(
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

            // -- Specialists grid --
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.68,
              ),
              itemCount: _doctors.length,
              itemBuilder: (context, i) =>
                  _buildDoctorCard(_doctors[i]),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Quick consult section --
            shadcn.Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              fillColor: colors.primary.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on,
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
                    child: shadcn.Button.primary(
                      onPressed: () {
                        shadcn.showToast(
                          context: context,
                          builder: (ctx, overlay) => shadcn.SurfaceCard(
                            child: shadcn.Basic(
                              leading: Icon(Icons.videocam,
                                  color: colors.primary),
                              title: Text('Finding available specialist...'),
                              subtitle: Text(
                                  'You will be connected shortly'),
                            ),
                          ),
                        );
                        Future.delayed(
                            const Duration(milliseconds: 1200), () {
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            context.push(RouteNames.serviceTelemedicineCall);
                          }
                        });
                      },
                      leading: const Icon(Icons.videocam, size: 20),
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

  Widget _buildDoctorCard(_DoctorMock doctor) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return shadcn.Card(
      padding: const EdgeInsets.all(AppSpacing.md),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          shadcn.Avatar(initials: doctor.initials, size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFFACC15), size: 13),
              const SizedBox(width: 3),
              Text(
                doctor.rating,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            doctor.specialty,
            style: TextStyle(
              fontSize: 11,
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Next: ${doctor.nextSlot}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: shadcn.Button.primary(
              onPressed: () async {
                final user = ref.read(authProvider).user;
                final patientRef = user?.fhirPatientId ?? user?.id ?? '';
                final patientName = user?.displayName ?? 'Patient';

                final appointment = AppointmentLocal()
                  ..patientRef = patientRef
                  ..practitionerRef = 'practitioner-${doctor.initials.toLowerCase()}'
                  ..practitionerName = doctor.name
                  ..patientName = patientName
                  ..appointmentType = 'telemedicine'
                  ..status = 'booked'
                  ..scheduledAt = DateTime.now().add(const Duration(hours: 2))
                  ..durationMinutes = 30
                  ..specialty = doctor.specialty
                  ..createdAt = DateTime.now()
                  ..syncStatus = 1;

                await DatabaseService.appointments.add(appointment);

                if (!context.mounted) return;
                shadcn.showToast(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (ctx, overlay) => shadcn.SurfaceCard(
                    child: shadcn.Basic(
                      leading: Icon(Icons.check_circle, color: colors.success),
                      title: Text('Booking confirmed with ${doctor.name}'),
                      subtitle: Text(doctor.nextSlot),
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

class _DoctorMock {
  final String name;
  final String initials;
  final String specialty;
  final String rating;
  final String nextSlot;
  const _DoctorMock({
    required this.name,
    required this.initials,
    required this.specialty,
    required this.rating,
    required this.nextSlot,
  });
}
