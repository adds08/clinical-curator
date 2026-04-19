import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';

/// Kathmandu-area coordinates for simulation.
const _destinationLatLng = LatLng(27.7172, 85.3240); // Kathmandu center

/// Simulated ambulance route points (Kathmandu area).
const _routePoints = [
  LatLng(27.7050, 85.3131), // Start: Bir Hospital area
  LatLng(27.7070, 85.3150),
  LatLng(27.7090, 85.3175),
  LatLng(27.7110, 85.3190),
  LatLng(27.7130, 85.3210),
  LatLng(27.7150, 85.3225),
  LatLng(27.7172, 85.3240), // Destination
];

class AmbulanceTrackingScreen extends StatefulWidget {
  const AmbulanceTrackingScreen({super.key});

  @override
  State<AmbulanceTrackingScreen> createState() =>
      _AmbulanceTrackingScreenState();
}

class _AmbulanceTrackingScreenState extends State<AmbulanceTrackingScreen> {
  final MapController _mapController = MapController();
  late Timer _timer;
  int _currentPointIndex = 0;
  String _status = 'En Route';
  int _etaMinutes = 8;
  double _distanceKm = 1.4;

  @override
  void initState() {
    super.initState();
    // Simulate ambulance movement every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentPointIndex < _routePoints.length - 1) {
        setState(() {
          _currentPointIndex++;
          _etaMinutes = (_routePoints.length - 1 - _currentPointIndex) * 2;
          _distanceKm =
              ((_routePoints.length - 1 - _currentPointIndex) * 0.23);

          if (_currentPointIndex >= _routePoints.length - 1) {
            _status = 'Arrived';
            _etaMinutes = 0;
            _distanceKm = 0;
          } else if (_currentPointIndex >= _routePoints.length - 3) {
            _status = 'Almost There';
          }
        });

        // Pan map to follow ambulance
        _mapController.move(
          _routePoints[_currentPointIndex],
          _mapController.camera.zoom,
        );
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;
    final ambulancePos = _routePoints[_currentPointIndex];

    return Container(
      color: colors.background,
      child: Stack(
        children: [
          // -- Full-screen Leaflet map (OpenStreetMap) --
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _routePoints[0],
                initialZoom: 14.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                // OpenStreetMap tiles
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.clinicalcurator.app',
                  maxZoom: 19,
                ),

                // Route polyline (remaining path)
                PolylineLayer(
                  polylines: [
                    // Full route (faded)
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4,
                      color: colors.primary.withValues(alpha: 0.25),
                    ),
                    // Remaining route (dashed)
                    Polyline(
                      points:
                          _routePoints.sublist(_currentPointIndex),
                      strokeWidth: 4,
                      color: colors.primary,
                      pattern: const StrokePattern.dotted(),
                    ),
                  ],
                ),

                // Markers
                MarkerLayer(
                  markers: [
                    // Destination marker
                    Marker(
                      point: _destinationLatLng,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.destructive,
                          shape: BoxShape.circle,
                          boxShadow: [SurfaceTheme.ambientShadow],
                          border: Border.all(
                              color: Colors.white, width: 2),
                        ),
                        child: const Icon(LucideIcons.mapPin,
                            color: Colors.white, size: 22),
                      ),
                    ),
                    // Ambulance marker (animated position)
                    Marker(
                      point: ambulancePos,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            SurfaceTheme.ambientShadow,
                            BoxShadow(
                              color:
                                  colors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                              color: Colors.white, width: 2),
                        ),
                        child: const Icon(LucideIcons.truck,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // -- Back button --
          Positioned(
            top: topPad + AppSpacing.sm,
            left: AppSpacing.lg,
            child: Container(
              decoration: BoxDecoration(
                color: colors.card,
                shape: BoxShape.circle,
                boxShadow: [SurfaceTheme.ambientShadow],
              ),
              child: IconButton.ghost(
                icon: Icon(LucideIcons.arrowLeft,
                    color: colors.foreground, size: 22),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // -- Floating ETA badge --
          Positioned(
            top: topPad + AppSpacing.sm,
            right: AppSpacing.lg,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: _status == 'Arrived'
                    ? colors.success
                    : colors.primary,
                borderRadius: AppRadius.cardRadius,
                boxShadow: [SurfaceTheme.ambientShadow],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _status == 'Arrived'
                        ? LucideIcons.circleCheck
                        : LucideIcons.timer,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _status == 'Arrived'
                        ? 'Arrived!'
                        : '$_etaMinutes mins',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (_status != 'Arrived') ...[
                    const SizedBox(width: AppSpacing.xs),
                    const Text('\u2022',
                        style: TextStyle(
                            color: Color(0xB3FFFFFF), fontSize: 14)),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${_distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xCCFFFFFF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // -- Floating driver card --
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: bottomPad + AppSpacing.xl,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: AppRadius.cardRadius,
                boxShadow: [SurfaceTheme.ambientShadow],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Avatar(initials: 'RB', size: 48),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ram Bahadur',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colors.foreground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(LucideIcons.star,
                                    color: Color(0xFFFACC15), size: 14),
                                const SizedBox(width: 3),
                                Text('4.8',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colors.mutedForeground)),
                                const SizedBox(width: 8),
                                Text('BA 1 PA 2345',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: colors.mutedForeground)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _status == 'Arrived'
                              ? colors.successBackground
                              : colors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.chipRadius,
                        ),
                        child: Text(
                          _status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _status == 'Arrived'
                                ? colors.success
                                : colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Button.primary(
                          onPressed: () {
                            showToast(
                              context: context,
                              builder: (ctx, overlay) =>
                                  SurfaceCard(
                                child: Basic(
                                  leading: Icon(LucideIcons.phone,
                                      color: colors.primary),
                                  title: const Text('Calling driver...'),
                                  subtitle: const Text(
                                      'Ram Bahadur - BA 1 PA 2345'),
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.phone, size: 18),
                              SizedBox(width: AppSpacing.sm),
                              Text('Call Driver'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Button.outline(
                          onPressed: () {
                            showToast(
                              context: context,
                              builder: (ctx, overlay) =>
                                  SurfaceCard(
                                child: Basic(
                                  leading: Icon(LucideIcons.messageCircle,
                                      color: colors.primary),
                                  title: const Text('Opening chat...'),
                                  subtitle:
                                      const Text('Messaging Ram Bahadur'),
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.messageCircle, size: 18),
                              SizedBox(width: AppSpacing.sm),
                              Text('Message'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
