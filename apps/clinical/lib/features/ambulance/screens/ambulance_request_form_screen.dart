import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/ambulance_provider.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../shared/widgets/location_picker.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class AmbulanceRequestFormScreen extends ConsumerStatefulWidget {
  const AmbulanceRequestFormScreen({super.key});

  @override
  ConsumerState<AmbulanceRequestFormScreen> createState() =>
      _AmbulanceRequestFormScreenState();
}

class _AmbulanceRequestFormScreenState
    extends ConsumerState<AmbulanceRequestFormScreen> {
  String _selectedEmergencyType = 'Accident';
  final _patientNameController = TextEditingController();
  final _contactController = TextEditingController();

  PickedLocation? _pickedLocation;

  final List<String> _emergencyTypes = [
    'Accident',
    'Cardiac',
    'Respiratory',
    'Burns',
    'Maternity',
    'Other',
  ];

  @override
  void dispose() {
    _patientNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.of(context).push<PickedLocation>(
      PageRouteBuilder<PickedLocation>(
        pageBuilder: (_, _, _) => LocationPickerScreen(
          initialLocation: _pickedLocation?.latLng,
          initialAddress: _pickedLocation?.displayName,
        ),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
    if (result != null && mounted) {
      setState(() => _pickedLocation = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SubPageScaffold(
      title: 'Request Ambulance',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Header alert card --
            Alert(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.destructive.withValues(alpha: 0.15),
                  borderRadius: AppRadius.inputRadius,
                ),
                child: Icon(LucideIcons.siren,
                    color: colors.destructive, size: 24),
              ),
              title: const Text('Emergency Dispatch'),
              content: const Text('Fill in details for fastest response'),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // -- Pickup location with map preview --
            _buildLabel(context, 'Pickup Location'),
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: _openLocationPicker,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    // Mini map preview
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: AppRadius.cardRadius.topLeft,
                        topRight: AppRadius.cardRadius.topRight,
                      ),
                      child: SizedBox(
                        height: 140,
                        child: _pickedLocation != null
                            ? FlutterMap(
                                options: MapOptions(
                                  initialCenter: _pickedLocation!.latLng,
                                  initialZoom: 15,
                                  interactionOptions:
                                      const InteractionOptions(
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.clinicalcurator.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _pickedLocation!.latLng,
                                        width: 36,
                                        height: 36,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: colors.destructive,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2),
                                          ),
                                          child: const Icon(
                                              LucideIcons.mapPin,
                                              color: Colors.white,
                                              size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : FlutterMap(
                                options: const MapOptions(
                                  initialCenter:
                                      LatLng(27.7172, 85.3240),
                                  initialZoom: 13,
                                  interactionOptions:
                                      InteractionOptions(
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.clinicalcurator.app',
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // Address row
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            _pickedLocation != null
                                ? LucideIcons.mapPin
                                : LucideIcons.locateFixed,
                            color: _pickedLocation != null
                                ? colors.destructive
                                : colors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _pickedLocation?.displayName ??
                                  'Tap to set pickup location',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _pickedLocation != null
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: _pickedLocation != null
                                    ? colors.foreground
                                    : colors.mutedForeground,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(LucideIcons.chevronRight,
                              size: 18,
                              color: colors.mutedForeground),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Emergency type dropdown --
            _buildLabel(context, 'Emergency Type'),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: Select<String>(
                value: _selectedEmergencyType,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedEmergencyType = val);
                  }
                },
                itemBuilder: (context, item) => Text(item),
                // ignore: implicit_call_tearoffs
                popup: SelectPopup(
                  items: SelectItemList(
                    children: _emergencyTypes
                        .map((t) => SelectItemButton(
                              value: t,
                              child: Text(t),
                            ))
                        .toList(),
                  ),
                ),
                placeholder: const Text('Select emergency type'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Patient name --
            _buildLabel(context, 'Patient Name'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _patientNameController,
              placeholder: const Text('Full name'),
              features: [
                InputFeature.leading(
                  Icon(LucideIcons.user,
                      color: colors.mutedForeground, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // -- Contact number --
            _buildLabel(context, 'Contact Number'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _contactController,
              placeholder: const Text('+977-XXXXXXXXXX'),
              features: [
                InputFeature.leading(
                  Icon(LucideIcons.phone,
                      color: colors.mutedForeground, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // -- Submit button --
            SizedBox(
              width: double.infinity,
              child: Button.destructive(
                onPressed: () async {
                  if (_patientNameController.text.trim().isEmpty) {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          leading: Icon(LucideIcons.triangleAlert,
                              color: colors.warning),
                          title: const Text('Please enter patient name'),
                        ),
                      ),
                    );
                    return;
                  }
                  if (_contactController.text.trim().isEmpty) {
                    showToast(
                      context: context,
                      builder: (ctx, overlay) => SurfaceCard(
                        child: Basic(
                          leading: Icon(LucideIcons.triangleAlert,
                              color: colors.warning),
                          title:
                              const Text('Please enter contact number'),
                        ),
                      ),
                    );
                    return;
                  }

                  final user = ref.read(authProvider).user;
                  final patientRef =
                      user?.fhirPatientId ?? user?.id ?? 'unknown';

                  await ref.read(ambulanceProvider.notifier).createRequest(
                    patientRef: patientRef,
                    patientName: _patientNameController.text.trim(),
                    contactNumber: _contactController.text.trim(),
                    emergencyType: _selectedEmergencyType,
                    pickupLocation:
                        _pickedLocation?.displayName ?? 'Current Location',
                    latitude: _pickedLocation?.latLng.latitude,
                    longitude: _pickedLocation?.latLng.longitude,
                  );

                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  context.push(RouteNames.serviceAmbulanceConfirmation);
                },
                leading: const Icon(LucideIcons.truck, size: 20),
                child: const Text(
                  'Request Ambulance',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;
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
}
