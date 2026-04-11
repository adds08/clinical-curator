import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/practitioner_role_collection.dart';

class DoctorSearchState {
  final String query;
  final String? specialtyFilter;
  final String? orgFilter;
  final bool telehealthOnly;
  final List<PractitionerRoleLocal> results;

  const DoctorSearchState({
    this.query = '',
    this.specialtyFilter,
    this.orgFilter,
    this.telehealthOnly = false,
    this.results = const [],
  });

  DoctorSearchState copyWith({
    String? query,
    String? specialtyFilter,
    String? orgFilter,
    bool? telehealthOnly,
    List<PractitionerRoleLocal>? results,
    bool clearSpecialty = false,
    bool clearOrg = false,
  }) {
    return DoctorSearchState(
      query: query ?? this.query,
      specialtyFilter: clearSpecialty ? null : (specialtyFilter ?? this.specialtyFilter),
      orgFilter: clearOrg ? null : (orgFilter ?? this.orgFilter),
      telehealthOnly: telehealthOnly ?? this.telehealthOnly,
      results: results ?? this.results,
    );
  }
}

class DoctorSearchNotifier extends StateNotifier<DoctorSearchState> {
  DoctorSearchNotifier() : super(const DoctorSearchState()) {
    search();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
    search();
  }

  void setSpecialtyFilter(String? specialty) {
    if (specialty == null) {
      state = state.copyWith(clearSpecialty: true);
    } else {
      state = state.copyWith(specialtyFilter: specialty);
    }
    search();
  }

  void setOrgFilter(String? orgRef) {
    if (orgRef == null) {
      state = state.copyWith(clearOrg: true);
    } else {
      state = state.copyWith(orgFilter: orgRef);
    }
    search();
  }

  void setTelehealthOnly(bool value) {
    state = state.copyWith(telehealthOnly: value);
    search();
  }

  void search() {
    final box = DatabaseService.practitionerRoles;
    final queryLower = state.query.toLowerCase();

    var results = box.values.where((r) => r.active && r.syncStatus != 2).toList();

    if (queryLower.isNotEmpty) {
      results = results.where((r) {
        final name = (r.practitionerName ?? '').toLowerCase();
        final spec = (r.specialty ?? '').toLowerCase();
        return name.contains(queryLower) || spec.contains(queryLower);
      }).toList();
    }

    if (state.specialtyFilter != null) {
      results = results.where((r) => r.specialty == state.specialtyFilter).toList();
    }

    if (state.orgFilter != null) {
      results = results.where((r) => r.organizationRef == state.orgFilter).toList();
    }

    // Deduplicate by practitionerRef (show each practitioner once in search results)
    final seen = <String>{};
    final deduplicated = <PractitionerRoleLocal>[];
    for (final r in results) {
      if (seen.add(r.practitionerRef)) {
        deduplicated.add(r);
      }
    }

    state = state.copyWith(results: deduplicated);
  }

  void reset() {
    state = const DoctorSearchState();
    search();
  }
}

final doctorSearchProvider =
    StateNotifierProvider<DoctorSearchNotifier, DoctorSearchState>((ref) {
  return DoctorSearchNotifier();
});

/// All distinct specialties across active practitioner roles.
final allSpecialtiesProvider = Provider<List<String>>((ref) {
  final box = DatabaseService.practitionerRoles;
  final specialties = box.values
      .where((r) => r.active && r.syncStatus != 2 && r.specialty != null)
      .map((r) => r.specialty!)
      .toSet()
      .toList()
    ..sort();
  return specialties;
});
