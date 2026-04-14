import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'base_repository.dart';

class DiagnosticReportRepository
    extends BaseRepository<fhir.DiagnosticReport> {
  DiagnosticReportRepository() : super(resourceType: 'DiagnosticReport');
}

final diagnosticReportRepositoryProvider =
    Provider<DiagnosticReportRepository>((ref) {
  return DiagnosticReportRepository();
});
