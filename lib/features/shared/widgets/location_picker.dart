import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../../core/constants/app_radius.dart';
import '../../../core/theme/surface_theme.dart';

/// Result from the location picker.
class PickedLocation {
  final LatLng latLng;
  final String displayName;

  const PickedLocation({required this.latLng, required this.displayName});
}

/// A full-screen map location picker with search, drop-pin, and current location.
class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();

  // Kathmandu default
  static const _defaultCenter = LatLng(27.7172, 85.3240);

  late LatLng _selectedLocation;
  String _selectedAddress = '';
  List<_SearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _isLocating = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? _defaultCenter;
    _selectedAddress = widget.initialAddress ?? '';
    if (_selectedAddress.isNotEmpty) {
      _searchController.text = _selectedAddress;
    }

    // Auto-detect current location on open if no initial location
    if (widget.initialLocation == null) {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _mapController.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() => _isLocating = false);
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _selectedLocation = latLng;
          _isLocating = false;
        });
        _mapController.move(latLng, 16);
        _reverseGeocode(latLng);
      }
    } catch (_) {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': latLng.latitude,
          'lon': latLng.longitude,
          'format': 'json',
          'addressdetails': 1,
        },
        options: Options(headers: {
          'User-Agent': 'ClinicalCurator/1.0',
        }),
      );

      if (mounted && response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;
        String display;
        if (address != null) {
          final parts = <String>[];
          if (address['road'] != null) parts.add(address['road']);
          if (address['neighbourhood'] != null) {
            parts.add(address['neighbourhood']);
          }
          if (address['suburb'] != null) parts.add(address['suburb']);
          if (address['city'] != null) {
            parts.add(address['city']);
          } else if (address['town'] != null) {
            parts.add(address['town']);
          }
          display = parts.isNotEmpty ? parts.join(', ') : (data['display_name'] ?? '');
        } else {
          display = data['display_name'] ?? '';
        }
        setState(() {
          _selectedAddress = display;
          _searchController.text = display;
        });
      }
    } catch (_) {}
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 3) {
      setState(() => _searchResults = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchPlaces(query.trim());
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearching = true);
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
          'countrycodes': 'np', // Prioritize Nepal
          'addressdetails': 1,
        },
        options: Options(headers: {
          'User-Agent': 'ClinicalCurator/1.0',
        }),
      );

      if (mounted && response.statusCode == 200) {
        final data = response.data as List;
        setState(() {
          _searchResults = data
              .map((item) => _SearchResult(
                    displayName: item['display_name'] ?? '',
                    latLng: LatLng(
                      double.parse(item['lat']),
                      double.parse(item['lon']),
                    ),
                  ))
              .toList();
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectSearchResult(_SearchResult result) {
    setState(() {
      _selectedLocation = result.latLng;
      _selectedAddress = result.displayName;
      _searchController.text = result.displayName;
      _searchResults = [];
    });
    _mapController.move(result.latLng, 16);
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _searchResults = [];
    });
    _reverseGeocode(latLng);
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Material(
      color: colors.background,
      child: Stack(
        children: [
          // -- Map --
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 14.5,
                onTap: _onMapTap,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.clinicalcurator.app',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 48,
                      height: 48,
                      child: Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: colors.destructive,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.destructive
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.location_on,
                                color: Colors.white, size: 20),
                          ),
                          Container(
                            width: 4,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.destructive,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // -- Top bar: back + search --
          Positioned(
            top: topPad + 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Row(
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: colors.card,
                        shape: BoxShape.circle,
                        boxShadow: [SurfaceTheme.ambientShadow],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: colors.foreground, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Search field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: AppRadius.cardRadius,
                          boxShadow: [SurfaceTheme.ambientShadow],
                        ),
                        child: shadcn.TextField(
                          controller: _searchController,
                          placeholder:
                              const Text('Search location...'),
                          onChanged: _onSearchChanged,
                          features: [
                            shadcn.InputFeature.leading(
                              _isSearching
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.primary,
                                      ),
                                    )
                                  : Icon(Icons.search,
                                      color: colors.mutedForeground,
                                      size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Search results dropdown
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 48, top: 4),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: AppRadius.cardRadius,
                      boxShadow: [SurfaceTheme.ambientShadow],
                    ),
                    constraints:
                        const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: colors.border,
                      ),
                      itemBuilder: (_, i) {
                        final result = _searchResults[i];
                        return InkWell(
                          onTap: () => _selectSearchResult(result),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 18,
                                    color: colors.mutedForeground),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    result.displayName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.foreground,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // -- Current location FAB --
          Positioned(
            right: 16,
            bottom: bottomPad + 100,
            child: Container(
              decoration: BoxDecoration(
                color: colors.card,
                shape: BoxShape.circle,
                boxShadow: [SurfaceTheme.ambientShadow],
              ),
              child: IconButton(
                icon: _isLocating
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.primary,
                        ),
                      )
                    : Icon(Icons.my_location,
                        color: colors.primary, size: 22),
                onPressed: _isLocating ? null : _getCurrentLocation,
              ),
            ),
          ),

          // -- Bottom confirm bar --
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, bottomPad + 12),
              decoration: BoxDecoration(
                color: colors.card,
                boxShadow: [SurfaceTheme.ambientShadow],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedAddress.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: colors.destructive),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _selectedAddress,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colors.foreground,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: shadcn.Button.primary(
                      onPressed: () {
                        Navigator.of(context).pop(
                          PickedLocation(
                            latLng: _selectedLocation,
                            displayName: _selectedAddress.isNotEmpty
                                ? _selectedAddress
                                : '${_selectedLocation.latitude.toStringAsFixed(5)}, ${_selectedLocation.longitude.toStringAsFixed(5)}',
                          ),
                        );
                      },
                      child: const Text(
                        'Confirm Location',
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
        ],
      ),
    );
  }
}

class _SearchResult {
  final String displayName;
  final LatLng latLng;
  const _SearchResult({required this.displayName, required this.latLng});
}
