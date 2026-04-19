import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/collections/organization_collection.dart';
import 'package:cc_data/providers/organization_provider.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';

class _Hospital {
  final String name;
  final String address;
  final String distance;
  final String type;
  final double rating;
  final bool isOpen;
  final String phone;
  final List<String> services;
  final LatLng location;

  const _Hospital({
    required this.name,
    required this.address,
    required this.distance,
    required this.type,
    required this.rating,
    required this.isOpen,
    required this.phone,
    required this.location,
    this.services = const [],
  });

  static _Hospital fromOrg(OrganizationLocal org) {
    List<String> services = [];
    if (org.servicesJson != null) {
      try {
        services = (jsonDecode(org.servicesJson!) as List).cast<String>();
      } catch (_) {}
    }
    if (services.isEmpty && org.departmentsJson != null) {
      try {
        services = (jsonDecode(org.departmentsJson!) as List).cast<String>();
      } catch (_) {}
    }
    return _Hospital(
      name: org.name,
      address: org.address,
      distance: '',
      type: org.hasEmergency ? 'Emergency' : 'General',
      rating: org.rating ?? 0,
      isOpen: org.isOpen24Hours,
      phone: org.phone ?? '',
      location: LatLng(org.latitude ?? 27.71, org.longitude ?? 85.32),
      services: services,
    );
  }
}

class HospitalsScreen extends ConsumerStatefulWidget {
  const HospitalsScreen({super.key});

  @override
  ConsumerState<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends ConsumerState<HospitalsScreen> {
  String _filter = 'All';
  final _searchController = TextEditingController();
  bool _showMap = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Hospital> _filtered(List<OrganizationLocal> orgs) {
    var list = orgs.map(_Hospital.fromOrg).toList();
    if (_filter == 'Emergency') {
      list = list.where((h) => h.type == 'Emergency').toList();
    }
    if (_filter == 'Open Now') {
      list = list.where((h) => h.isOpen).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((h) =>
              h.name.toLowerCase().contains(q) ||
              h.address.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orgs = ref.watch(hospitalsProvider);
    final results = _filtered(orgs);

    return SubPageScaffold(
      title: 'Hospitals',
      trailing: [
        IconButton.ghost(
          icon: Icon(
            _showMap ? LucideIcons.list : LucideIcons.map,
            size: 22,
          ),
          onPressed: () => setState(() => _showMap = !_showMap),
        ),
      ],
      child: Column(
        children: [
          // Search + filters
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  placeholder: const Text('Search hospitals...'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        ['All', 'Emergency', 'Open Now'].map((f) {
                      final active = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: active
                                  ? colors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: active
                                      ? colors.primary
                                      : colors.border),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : colors.foreground)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Map or List view
          Expanded(
            child: _showMap
                ? _buildMapView(context, results)
                : _buildListView(context, results),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(BuildContext context, List<_Hospital> hospitals) {
    final colors = Theme.of(context).colorScheme;

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(27.7100, 85.3200), // Kathmandu center
        initialZoom: 12.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.clinicalcurator.app',
          maxZoom: 19,
        ),
        MarkerLayer(
          markers: hospitals.map((h) {
            return Marker(
              point: h.location,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showDetail(context, h),
                child: Container(
                  decoration: BoxDecoration(
                    color: h.isOpen
                        ? const Color(0xFF0D9488)
                        : colors.destructive,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(LucideIcons.hospital,
                      color: Colors.white, size: 20),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, List<_Hospital> hospitals) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${hospitals.length} hospitals found',
              style: TextStyle(
                  fontSize: 13, color: colors.mutedForeground)),
          const SizedBox(height: 12),
          ...hospitals.map((h) => _HospitalCard(
                hospital: h,
                onTap: () => _showDetail(context, h),
              )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, _Hospital hospital) {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hospital.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground)),
            const SizedBox(height: 4),
            Text(hospital.address,
                style: TextStyle(
                    fontSize: 14, color: colors.mutedForeground)),
            const SizedBox(height: 12),

            // Mini map
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 150,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: hospital.location,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.clinicalcurator.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: hospital.location,
                          width: 36,
                          height: 36,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                                LucideIcons.hospital,
                                color: Colors.white,
                                size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(children: [
              Icon(LucideIcons.phone,
                  size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Text(hospital.phone,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.primary)),
              const SizedBox(width: 16),
              Icon(LucideIcons.star,
                  size: 16, color: const Color(0xFFFACC15)),
              const SizedBox(width: 4),
              Text('${hospital.rating}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hospital.isOpen
                      ? colors.success.withValues(alpha: 0.1)
                      : colors.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hospital.isOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: hospital.isOpen
                          ? colors.success
                          : colors.destructive),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Text('Services',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: hospital.services
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: colors.muted,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(s,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colors.foreground)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () => closeDrawer(ctx),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final _Hospital hospital;
  final VoidCallback onTap;
  const _HospitalCard({required this.hospital, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.hospital,
                      color: Color(0xFF0D9488), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hospital.name,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.foreground),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(hospital.address,
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                    icon: LucideIcons.mapPin,
                    label: hospital.distance),
                const SizedBox(width: 8),
                _InfoChip(
                    icon: LucideIcons.star,
                    label: '${hospital.rating}'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: hospital.isOpen
                        ? colors.success.withValues(alpha: 0.1)
                        : colors.destructive.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    hospital.isOpen ? 'Open' : 'Closed',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: hospital.isOpen
                            ? colors.success
                            : colors.destructive),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: colors.muted,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(hospital.type,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.mutedForeground)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colors.mutedForeground),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.mutedForeground)),
      ],
    );
  }
}
