import 'dart:convert';

/// Extracts FHIR search parameters from a resource JSON for GIN indexing.
/// Each FHIR resource type defines its own searchable fields.
Map<String, dynamic> extractSearchParams(Map<String, dynamic> resource) {
  final params = <String, dynamic>{};
  final type = resource['resourceType'] as String? ?? '';

  switch (type) {
    case 'Patient':
      params['name'] = _extractNames(resource);
      params['identifier'] = _extractIdentifiers(resource);
      params['gender'] = resource['gender'];
      params['birthdate'] = resource['birthDate'];
      params['phone'] = _extractTelecom(resource, 'phone');
      params['email'] = _extractTelecom(resource, 'email');
      break;
    case 'Practitioner':
      params['name'] = _extractNames(resource);
      params['identifier'] = _extractIdentifiers(resource);
      params['nmc'] = _extractNmcNumber(resource);
      break;
    case 'Patient':
    case 'Encounter':
      params['patient'] = _extractRef(resource, 'subject');
      params['date'] = _extractPath(resource, 'period.start');
      params['status'] = resource['status'];
      params['class'] = _extractPath(resource, 'class.code');
      params['practitioner'] = _extractParticipants(resource);
      params['location'] = _extractLocation(resource);
      params['type'] = _encodeCodeableRef(resource['type']);
      break;
    case 'Observation':
      params['patient'] = _extractRef(resource, 'subject');
      params['code'] = _encodeCodeableRef(resource['code']);
      params['date'] = resource['effectiveDateTime'] ?? resource['effectivePeriod']?['start'];
      params['status'] = resource['status'];
      params['category'] = _encodeCodeableRef(resource['category']);
      params['value'] = resource['valueQuantity']?['value'];
      params['unit'] = resource['valueQuantity']?['unit'];
      break;
    case 'Condition':
      params['patient'] = _extractRef(resource, 'subject');
      params['code'] = _encodeCodeableRef(resource['code']);
      params['clinicalStatus'] = _extractPath(resource, 'clinicalStatus.coding.0.code');
      params['onsetDate'] = resource['onsetDateTime'] ?? resource['onsetPeriod']?['start'];
      params['category'] = _encodeCodeableRef(resource['category']);
      break;
    case 'MedicationRequest':
      params['patient'] = _extractRef(resource, 'subject');
      params['medication'] = _encodeCodeableRef(resource['medicationCodeableConcept']);
      params['status'] = resource['status'];
      params['intent'] = resource['intent'];
      params['authoredon'] = resource['authoredOn'];
      params['requester'] = _extractRef(resource, 'requester');
      break;
    case 'AllergyIntolerance':
      params['patient'] = _extractRef(resource, 'patient');
      params['code'] = _encodeCodeableRef(resource['code']);
      params['clinicalStatus'] = _extractPath(resource, 'clinicalStatus.coding.0.code');
      params['type'] = resource['type'];
      params['category'] = resource['category'];
      break;
    case 'Immunization':
      params['patient'] = _extractRef(resource, 'patient');
      params['vaccineCode'] = _encodeCodeableRef(resource['vaccineCode']);
      params['date'] = resource['occurrenceDateTime'];
      params['status'] = resource['status'];
      break;
    case 'DiagnosticReport':
      params['patient'] = _extractRef(resource, 'subject');
      params['code'] = _encodeCodeableRef(resource['code']);
      params['date'] = resource['effectiveDateTime'];
      params['status'] = resource['status'];
      params['category'] = _encodeCodeableRef(resource['category']);
      params['performer'] = _extractRefs(resource, 'performer');
      break;
    case 'Consent':
      params['patient'] = _extractRef(resource, 'patient');
      params['status'] = resource['status'];
      params['category'] = _encodeCodeableRef(resource['category']);
      params['date'] = resource['dateTime'];
      break;
    case 'Appointment':
      params['patient'] = _extractParticipantRef(resource, 'Patient');
      params['practitioner'] = _extractParticipantRef(resource, 'Practitioner');
      params['date'] = resource['start'];
      params['status'] = resource['status'];
      params['serviceType'] = _encodeCodeableRef(resource['serviceType']);
      break;
    case 'ServiceRequest':
      params['patient'] = _extractRef(resource, 'subject');
      params['code'] = _encodeCodeableRef(resource['code']);
      params['status'] = resource['status'];
      params['date'] = resource['occurrenceDateTime'];
      params['requester'] = _extractRef(resource, 'requester');
      params['performer'] = _extractRef(resource, 'performer');
      break;
    case 'Communication':
      params['patient'] = _extractRef(resource, 'subject');
      params['sender'] = _extractRef(resource, 'sender');
      params['sent'] = resource['sent'];
      params['status'] = resource['status'];
      break;
    case 'Composition':
      params['patient'] = _extractRef(resource, 'subject');
      params['date'] = resource['date'];
      params['type'] = _encodeCodeableRef(resource['type']);
      params['status'] = resource['status'];
      params['author'] = _extractRefs(resource, 'author');
      break;
    case 'DocumentReference':
      params['patient'] = _extractRef(resource, 'subject');
      params['type'] = _encodeCodeableRef(resource['type']);
      params['date'] = resource['date'];
      params['status'] = resource['status'];
      break;
    case 'Provenance':
      params['target'] = _extractRefs(resource, 'target');
      params['recorded'] = resource['recorded'];
      params['agent'] = _extractRefs(resource, 'agent');
      break;
    case 'AuditEvent':
      params['action'] = resource['action'];
      params['recorded'] = resource['recorded'];
      params['outcome'] = resource['outcome'];
      params['agent'] = _extractRefs(resource, 'agent');
      break;
    case 'Organization':
      params['name'] = resource['name'];
      params['type'] = _encodeCodeableRef(resource['type']);
      params['address'] = resource['address']?[0]?['text'];
      params['phone'] = _extractTelecom(resource, 'phone');
      break;
    case 'Location':
      params['name'] = resource['name'];
      params['type'] = _encodeCodeableRef(resource['type']);
      params['organization'] = _extractRef(resource, 'managingOrganization');
      break;
    case 'Slot':
      params['schedule'] = _extractRef(resource, 'schedule');
      params['status'] = resource['status'];
      params['start'] = resource['start'];
      params['end'] = resource['end'];
      break;
    case 'CarePlan':
      params['patient'] = _extractRef(resource, 'subject');
      params['status'] = resource['status'];
      params['category'] = _encodeCodeableRef(resource['category']);
      params['date'] = resource['period']?['start'];
      break;
  }

  return params;
}

// ---- extraction helpers ----

String? _extractRef(Map<String, dynamic>? parent, String field) {
  return parent?[field]?['reference'] as String?;
}

List<String> _extractRefs(Map<String, dynamic>? parent, String field) {
  final items = parent?[field] as List?;
  if (items == null) return [];
  return items.map((e) => e is Map ? e['reference']?.toString() ?? '' : e.toString()).where((s) => s.isNotEmpty).toList();
}

List<String> _extractNames(Map<String, dynamic> r) {
  final names = r['name'] as List?;
  if (names == null) return [];
  return names.map((n) {
    final given = (n['given'] as List?)?.join(' ') ?? '';
    final family = n['family'] as String? ?? '';
    return '$given $family'.trim().toLowerCase();
  }).toList();
}

List<String> _extractIdentifiers(Map<String, dynamic> r) {
  final ids = r['identifier'] as List?;
  if (ids == null) return [];
  return ids.map((i) => '${i['system']}|${i['value']}').toList();
}

String? _extractTelecom(Map<String, dynamic> r, String system) {
  final telecoms = r['telecom'] as List?;
  if (telecoms == null) return null;
  final match = telecoms.cast<Map<String, dynamic>>().firstWhere((t) => t['system'] == system, orElse: () => {});
  return match['value'] as String?;
}

String? _extractNmcNumber(Map<String, dynamic> r) {
  final qual = r['qualification'] as List?;
  if (qual == null) return null;
  for (final q in qual) {
    final ids = q['identifier'] as List?;
    if (ids == null) continue;
    for (final id in ids) {
      if (id['system']?.toString().contains('nmc') == true) {
        return id['value'] as String?;
      }
    }
  }
  return null;
}

List<String>? _extractParticipants(Map<String, dynamic> r) {
  final participants = r['participant'] as List?;
  if (participants == null) return null;
  return participants.map((p) => p['individual']?['reference'] as String?).where((s) => s != null).cast<String>().toList();
}

String? _extractLocation(Map<String, dynamic> r) {
  final locations = r['location'] as List?;
  if (locations == null || locations.isEmpty) return null;
  final ref = locations.first['location']?['reference'];
  if (ref != null) return ref as String;
  final display = locations.first['location']?['display'];
  return display?.toString();
}

String? _extractPath(Map<String, dynamic> r, String path) {
  final parts = path.split('.');
  dynamic current = r;
  for (final part in parts) {
    if (current is Map && current.containsKey(part)) {
      current = current[part];
    } else if (current is List && int.tryParse(part) != null) {
      final index = int.parse(part);
      if (index < current.length)
        current = current[index];
      else
        return null;
    } else {
      return null;
    }
  }
  return current?.toString();
}

String? _encodeCodeableRef(dynamic coding) {
  if (coding == null) return null;
  if (coding is List) {
    return coding.map((c) => _encodeCodeableRef(c)).where((s) => s != null).join(',');
  }
  if (coding is! Map) return null;
  final codings = coding['coding'] as List?;
  if (codings == null || codings.isEmpty) return null;
  return codings.map((c) => '${c['system']}|${c['code']}').join(' ');
}

String? _extractParticipantRef(Map<String, dynamic> r, String type) {
  final participants = r['participant'] as List?;
  if (participants == null) return null;
  for (final p in participants) {
    final ref = p['actor']?['reference'] as String?;
    if (ref != null && ref.startsWith('$type/')) return ref;
  }
  return null;
}

/// Parse a FHIR _since timestamp. Returns earliest possible date if null.
DateTime parseSince(String? since) {
  if (since == null) return DateTime.fromMillisecondsSinceEpoch(0);
  return DateTime.tryParse(since) ?? DateTime.fromMillisecondsSinceEpoch(0);
}
