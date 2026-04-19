import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';

import '../services/audit_logger.dart';

/// Returns all FHIR Consent resources for a given patient reference.
final patientConsentsProvider =
    Provider.family<List<fhir.Consent>, String>((ref, patientRef) {
  final box = DatabaseService.fhirResources;
  final consents = <fhir.Consent>[];

  for (final r in box.values) {
    if (r.resourceType == 'Consent' && r.patientReference == patientRef) {
      try {
        final resource =
            fhir.Resource.fromJson(jsonDecode(r.jsonData) as Map<String, dynamic>);
        if (resource is fhir.Consent) {
          consents.add(resource);
        }
      } catch (_) {}
    }
  }

  return consents;
});

/// Toggles a Consent resource between active and inactive status in Hive.
/// Pass [agentEmail]/[agentName] to emit the corresponding AuditEvent.
Future<void> toggleConsentStatus(
  String consentId,
  bool activate, {
  String? agentEmail,
  String? agentName,
}) async {
  final box = DatabaseService.fhirResources;

  for (int i = 0; i < box.length; i++) {
    final r = box.getAt(i);
    if (r != null && r.fhirId == consentId && r.resourceType == 'Consent') {
      try {
        final json = jsonDecode(r.jsonData) as Map<String, dynamic>;
        json['status'] = activate ? 'active' : 'inactive';
        r.jsonData = jsonEncode(json);
        r.lastUpdated = DateTime.now();
        r.syncStatus = 1; // pendingUpload
        await r.save();

        final agentRef = 'User/${agentEmail ?? 'unknown'}';
        final who = agentName ?? (agentEmail ?? 'unknown');
        if (activate) {
          await AuditLogger.consentGranted(
            consentRef: 'Consent/$consentId',
            agentRef: agentRef,
            agentName: who,
          );
        } else {
          await AuditLogger.consentRevoked(
            consentRef: 'Consent/$consentId',
            agentRef: agentRef,
            agentName: who,
          );
        }
      } catch (_) {}
      break;
    }
  }
}

/// Warning message for UI when attempting consent with an unverified practitioner.
String consentWarningForUnverified(String practitionerName) =>
    'Dr. $practitionerName is not yet verified. '
    'Consent sharing is restricted until their identity is verified by an administrator.';

/// Creates a new FHIR Consent resource and stores it in Hive.
/// Throws [StateError] if the practitioner is not verified.
Future<void> createConsent({
  required String patientRef,
  required String practitionerRef,
  required bool isPractitionerVerified,
  String? agentEmail,
  String? agentName,
}) async {
  if (!isPractitionerVerified) {
    throw StateError(
      'Cannot create consent for unverified practitioner. '
      'Practitioner must be verified before receiving patient data.',
    );
  }

  final now = DateTime.now();
  final id = 'consent-${now.millisecondsSinceEpoch}';

  final c = fhir.Consent(
    fhirId: id,
    status: fhir.FhirCode('active'),
    scope: fhir.CodeableConcept(coding: [
      fhir.Coding(
        system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentscope'),
        code: fhir.FhirCode('patient-privacy'),
        display: 'Privacy Consent',
      ),
    ]),
    category: [
      fhir.CodeableConcept(coding: [
        fhir.Coding(
          system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentcategorycodes'),
          code: fhir.FhirCode('59284-0'),
          display: 'Consent Document',
        ),
      ]),
    ],
    patient: fhir.Reference(reference: patientRef),
    dateTime: fhir.FhirDateTime(now),
    performer: [fhir.Reference(reference: patientRef)],
    provision: fhir.ConsentProvision(
      type: fhir.FhirCode('permit'),
      actor: [
        fhir.ConsentActor(
          role: fhir.CodeableConcept(coding: [
            fhir.Coding(
              system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/v3-ParticipationType'),
              code: fhir.FhirCode('PRCP'),
              display: 'Primary information recipient',
            ),
          ]),
          reference: fhir.Reference(reference: practitionerRef),
        ),
      ],
      action: [
        fhir.CodeableConcept(coding: [
          fhir.Coding(
            system: fhir.FhirUri('http://terminology.hl7.org/CodeSystem/consentaction'),
            code: fhir.FhirCode('access'),
          ),
        ]),
      ],
    ),
  );

  final resource = FhirResource()
    ..fhirId = id
    ..resourceType = 'Consent'
    ..jsonData = jsonEncode(c.toJson())
    ..patientReference = patientRef
    ..practitionerReference = practitionerRef
    ..syncStatus = 1
    ..isDownloadedOffline = true
    ..lastUpdated = now
    ..createdAt = now;

  await DatabaseService.fhirResources.add(resource);

  await AuditLogger.consentGranted(
    consentRef: 'Consent/$id',
    agentRef: 'User/${agentEmail ?? 'unknown'}',
    agentName: agentName ?? (agentEmail ?? 'unknown'),
  );
}
