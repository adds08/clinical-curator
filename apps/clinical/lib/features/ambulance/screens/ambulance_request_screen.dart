import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import '../../../domain/providers/ambulance_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

/// Simulated route for the mini map preview.
const _routePoints = [
  LatLng(27.7050, 85.3131),
  LatLng(27.7070, 85.3150),
  LatLng(27.7090, 85.3175),
  LatLng(27.7110, 85.3190),
  LatLng(27.7130, 85.3210),
  LatLng(27.7150, 85.3225),
  LatLng(27.7172, 85.3240),
];

const _destinationLatLng = LatLng(27.7172, 85.3240);

class AmbulanceRequestScreen extends ConsumerStatefulWidget {
  const AmbulanceRequestScreen({super.key});

  @override
  ConsumerState<AmbulanceRequestScreen> createState() =>
      _AmbulanceRequestScreenState();
}

class _AmbulanceRequestScreenState
    extends ConsumerState<AmbulanceRequestScreen> {
  int _ambulanceIndex = 0;
  late Timer _timer;

  static const List<String> _instructions = [
    'Stay calm and keep the patient comfortable',
    'Prepare identification documents and current medications',
    'Clear the entrance path for stretcher access',
    'Unlock the main door or gate in advance',
    'Keep someone nearby to guide the ambulance crew',
  ];

  static const _cancellationReasons = [
    'No longer needed',
    'Found alternative transport',
    'Patient condition improved',
    'Requested by mistake',
    'Taking too long',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_ambulanceIndex < _routePoints.length - 1) {
        setState(() => _ambulanceIndex++);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showCancellationDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    String? selectedReason;

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDrawerState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why are you cancelling?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Help us improve our service',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              ..._cancellationReasons.map((reason) {
                final isSelected = selectedReason == reason;
                return GestureDetector(
                  onTap: () => setDrawerState(() => selectedReason = reason),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.destructive.withValues(alpha: 0.08)
                          : colors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colors.destructive
                            : colors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? LucideIcons.circleDot
                              : LucideIcons.circle,
                          size: 20,
                          color: isSelected
                              ? colors.destructive
                              : colors.mutedForeground,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          reason,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: colors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Button.destructive(
                  onPressed: selectedReason == null
                      ? null
                      : () {
                          ref
                              .read(ambulanceProvider.notifier)
                              .cancelActiveRequestWithReason(
                                  selectedReason!);
                          closeDrawer(ctx);
                          showToast(
                            context: context,
                            builder: (c, o) => SurfaceCard(
                              child: Basic(
                                leading: Icon(LucideIcons.circleX,
                                    color: colors.destructive),
                                title:
                                    const Text('Request cancelled'),
                              ),
                            ),
                          );
                          Future.delayed(
                              const Duration(milliseconds: 500), () {
                            if (context.mounted) context.pop();
                          });
                        },
                  child: const Text('Confirm Cancellation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    String selectedTimeliness = 'on_time';
    int selectedHelpfulness = 5;
    final feedbackController = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDrawerState) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.success.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.circleCheck,
                        color: colors.success, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Received?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground,
                          ),
                        ),
                        Text(
                          'Confirm to close this request',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Timeliness rating
              Text(
                'How was the arrival time?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTimelinessChip(
                    ctx, setDrawerState, colors,
                    value: 'early',
                    label: 'Early',
                    icon: LucideIcons.gauge,
                    isSelected: selectedTimeliness == 'early',
                    onTap: () => setDrawerState(
                        () => selectedTimeliness = 'early'),
                  ),
                  const SizedBox(width: 8),
                  _buildTimelinessChip(
                    ctx, setDrawerState, colors,
                    value: 'on_time',
                    label: 'On Time',
                    icon: LucideIcons.circleCheck,
                    isSelected: selectedTimeliness == 'on_time',
                    onTap: () => setDrawerState(
                        () => selectedTimeliness = 'on_time'),
                  ),
                  const SizedBox(width: 8),
                  _buildTimelinessChip(
                    ctx, setDrawerState, colors,
                    value: 'delayed',
                    label: 'Delayed',
                    icon: LucideIcons.clock,
                    isSelected: selectedTimeliness == 'delayed',
                    onTap: () => setDrawerState(
                        () => selectedTimeliness = 'delayed'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Helpfulness rating
              Text(
                'Rate the helpfulness',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final rating = i + 1;
                  return GestureDetector(
                    onTap: () => setDrawerState(
                        () => selectedHelpfulness = rating),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        rating <= selectedHelpfulness
                            ? LucideIcons.star
                            : LucideIcons.star,
                        size: 36,
                        color: rating <= selectedHelpfulness
                            ? const Color(0xFFFACC15)
                            : colors.mutedForeground,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Feedback notes
              Text(
                'Additional feedback (optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: feedbackController,
                placeholder: const Text(
                    'Any comments about the service...'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: Button.primary(
                  onPressed: () {
                    ref
                        .read(ambulanceProvider.notifier)
                        .completeWithRating(
                          timeliness: selectedTimeliness,
                          helpfulness: selectedHelpfulness,
                          feedbackNotes: feedbackController.text
                                  .trim()
                                  .isNotEmpty
                              ? feedbackController.text.trim()
                              : null,
                        );
                    closeDrawer(ctx);
                    showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(
                        child: Basic(
                          leading: Icon(LucideIcons.thumbsUp,
                              color: colors.success),
                          title: const Text(
                              'Thank you for your feedback!'),
                          subtitle: const Text(
                              'Request completed successfully'),
                        ),
                      ),
                    );
                    Future.delayed(
                        const Duration(milliseconds: 500), () {
                      if (context.mounted) context.pop();
                    });
                  },
                  leading: const Icon(LucideIcons.check, size: 20),
                  child: const Text(
                    'Confirm Patient Received',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelinessChip(
    BuildContext ctx,
    StateSetter setDrawerState,
    ColorScheme colors, {
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.08)
                : colors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? colors.primary : colors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color:
                      isSelected ? colors.primary : colors.mutedForeground),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? colors.primary : colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final activeRequest = ref.watch(activeAmbulanceRequestProvider);
    final isArrived = activeRequest?.status == 'arrived';
    final driverName = activeRequest?.assignedDriverName ?? 'Ram Bahadur';
    final vehicleNumber =
        activeRequest?.assignedVehicleNumber ?? 'BA 1 PA 2345';
    final eta = activeRequest?.estimatedArrivalMinutes ?? 7;
    final ambulancePos = _routePoints[_ambulanceIndex];

    return SubPageScaffold(
      title: isArrived ? 'Ambulance Arrived' : 'Ambulance Dispatched',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),

            // -- Status icon --
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isArrived
                    ? colors.success.withValues(alpha: 0.12)
                    : colors.successBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isArrived ? LucideIcons.mapPinCheck : LucideIcons.circleCheck,
                color: colors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isArrived
                  ? 'Ambulance Has Arrived!'
                  : 'Ambulance Dispatched!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: colors.foreground,
                letterSpacing: -0.3,
              ),
            ),
            if (isArrived) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please confirm when patient has been received',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),

            // -- Confirm button when arrived --
            if (isArrived) ...[
              SizedBox(
                width: double.infinity,
                child: Button.primary(
                  onPressed: () => _showCompletionDialog(context),
                  leading: const Icon(LucideIcons.circleCheck, size: 22),
                  child: const Text(
                    'Confirm Patient Received',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // -- Mini map with live ambulance position --
            GestureDetector(
              onTap: () =>
                  context.push(RouteNames.serviceAmbulanceTracking),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.cardRadius,
                  boxShadow: [SurfaceTheme.ambientShadow],
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.cardRadius,
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            (ambulancePos.latitude +
                                    _destinationLatLng.latitude) /
                                2,
                            (ambulancePos.longitude +
                                    _destinationLatLng.longitude) /
                                2,
                          ),
                          initialZoom: 13.8,
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
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _routePoints,
                                strokeWidth: 3,
                                color: colors.primary
                                    .withValues(alpha: 0.3),
                              ),
                              Polyline(
                                points: _routePoints
                                    .sublist(_ambulanceIndex),
                                strokeWidth: 3,
                                color: colors.primary,
                                pattern:
                                    const StrokePattern.dotted(),
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _destinationLatLng,
                                width: 32,
                                height: 32,
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
                                      size: 16),
                                ),
                              ),
                              Marker(
                                point: ambulancePos,
                                width: 36,
                                height: 36,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.primary
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                      LucideIcons.truck,
                                      color: Colors.white,
                                      size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [SurfaceTheme.ambientShadow],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.maximize,
                                  size: 14, color: colors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'Full Map',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isArrived)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ETA ~$eta min',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (isArrived)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: colors.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Arrived',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // -- Driver card --
            Card(
              padding: const EdgeInsets.all(AppSpacing.lg),
              fillColor:
                  SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
              child: Row(
                children: [
                  Avatar(
                      initials: driverName
                          .split(' ')
                          .map((w) => w[0])
                          .take(2)
                          .join(),
                      size: 48),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driverName,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colors.foreground)),
                        const SizedBox(height: 2),
                        Text(vehicleNumber,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.mutedForeground)),
                      ],
                    ),
                  ),
                  PrimaryBadge(
                    child: const Text('ICU Equipped'),
                  ),
                ],
              ),
            ),

            if (!isArrived) ...[
              const SizedBox(height: AppSpacing.xxl),

              // -- Instructions --
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'While You Wait',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(_instructions.length, (i) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    fillColor: SurfaceTheme.colorFor(
                        SurfaceLevel.lowest, context),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: colors.primary
                                .withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text('${i + 1}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary)),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(_instructions[i],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: colors.foreground,
                                  height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: AppSpacing.xxl),

            // -- Action buttons --
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () {
                  showToast(
                    context: context,
                    builder: (ctx, overlay) => SurfaceCard(
                      child: Basic(
                        leading:
                            Icon(LucideIcons.phone, color: colors.primary),
                        title: Text('Calling $driverName...'),
                        subtitle: Text(vehicleNumber),
                      ),
                    ),
                  );
                },
                leading: const Icon(LucideIcons.phone, size: 20),
                child: const Text('Call Driver',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (!isArrived)
              SizedBox(
                width: double.infinity,
                child: Button.destructive(
                  onPressed: () => _showCancellationDialog(context),
                  child: const Text('Cancel Request',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
