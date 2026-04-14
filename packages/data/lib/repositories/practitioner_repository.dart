import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class PractitionerRepository extends BaseRepository<fhir.Practitioner> {
  PractitionerRepository() : super(resourceType: 'Practitioner');

  List<fhir.Practitioner> searchByName(String query) {
    if (query.isEmpty) return parseLocalResources();
    final lowerQuery = query.toLowerCase();
    return parseLocalResources().where((p) {
      final names = p.name ?? [];
      return names.any((n) {
        final full =
            '${n.given?.join(' ') ?? ''} ${n.family ?? ''}'.toLowerCase();
        return full.contains(lowerQuery);
      });
    }).toList();
  }
}

final practitionerRepositoryProvider =
    Provider<PractitionerRepository>((ref) {
  return PractitionerRepository();
});
