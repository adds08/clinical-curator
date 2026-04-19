import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';
import 'package:cc_fhir_models/collections/organization_collection.dart';
import 'package:cc_fhir_models/collections/rbac_permission_collection.dart';

/// Minimal reference-data seed for non-mock builds.
///
/// Loaded when `ENV=dev|staging|prod` (see [apps/clinical/lib/main.dart]).
/// Unlike [MockSeed], this does NOT create phantom patients, practitioners,
/// observations, reports, medications, allergies, encounters, or audit rows.
///
/// It seeds the bare minimum required for a real-world first-run environment:
///   1. admin account (credentials from README)
///   2. RBAC permissions for patient/doctor/nurse/admin roles
///   3. Nepal specialty list (exposed via [kNepalSpecialties])
///   4. The five flagship hospitals as Organization rows.
class ReferenceSeed {
  ReferenceSeed._();

  /// Public list of specialties offered in Nepal. Consumed by booking UI,
  /// doctor registration flows, etc. Not backed by a FHIR CodeSystem (yet).
  static const List<String> kNepalSpecialties = [
    'Cardiology',
    'Internal Medicine',
    'Pediatrics',
    'OB/GYN',
    'Orthopedics',
    'Psychiatry',
    'Pulmonology',
    'Neurology',
    'Oncology',
    'Dermatology',
    'ENT',
    'Ophthalmology',
    'General Surgery',
    'Emergency Medicine',
    'Family Medicine',
  ];

  static Future<void> seedIfEmpty() async {
    final userBox = DatabaseService.userAccounts;
    final now = DateTime.now();

    // Admin account
    if (userBox.values.every((u) => u.email != 'admin@example.com')) {
      await userBox.add(UserAccount()
        ..email = 'admin@example.com'
        ..passwordHash = 'admin123'
        ..displayName = 'Admin User'
        ..isPractitioner = false
        ..isVerified = true
        ..accountType = 'admin'
        ..createdAt = now);
    }

    // Reference hospitals (5 flagship facilities)
    final orgBox = DatabaseService.organizations;
    if (orgBox.isEmpty) {
      final hospitals = <OrganizationLocal>[
        OrganizationLocal()
          ..fhirId = 'org-bir-hospital'
          ..name = 'Bir Hospital'
          ..type = 'hospital'
          ..address = 'Mahaboudha, Kathmandu'
          ..phone = '+977-1-4221119'
          ..latitude = 27.7035
          ..longitude = 85.3141
          ..openHours = '24/7'
          ..hasEmergency = true
          ..isOpen24Hours = true
          ..createdAt = now
          ..syncStatus = 0,
        OrganizationLocal()
          ..fhirId = 'org-tuth'
          ..name = 'Tribhuvan University Teaching Hospital'
          ..type = 'hospital'
          ..address = 'Maharajgunj, Kathmandu'
          ..phone = '+977-1-4412303'
          ..latitude = 27.7362
          ..longitude = 85.3310
          ..openHours = '24/7'
          ..hasEmergency = true
          ..isOpen24Hours = true
          ..createdAt = now
          ..syncStatus = 0,
        OrganizationLocal()
          ..fhirId = 'org-patan-hospital'
          ..name = 'Patan Hospital'
          ..type = 'hospital'
          ..address = 'Lagankhel, Lalitpur'
          ..phone = '+977-1-5522266'
          ..latitude = 27.6686
          ..longitude = 85.3188
          ..openHours = '24/7'
          ..hasEmergency = true
          ..isOpen24Hours = true
          ..createdAt = now
          ..syncStatus = 0,
        OrganizationLocal()
          ..fhirId = 'org-grande-hospital'
          ..name = 'Grande International Hospital'
          ..type = 'hospital'
          ..address = 'Dhapasi, Kathmandu'
          ..phone = '+977-1-5159266'
          ..latitude = 27.7440
          ..longitude = 85.3380
          ..openHours = '24/7'
          ..hasEmergency = true
          ..isOpen24Hours = true
          ..createdAt = now
          ..syncStatus = 0,
        OrganizationLocal()
          ..fhirId = 'org-norvic'
          ..name = 'Norvic International Hospital'
          ..type = 'hospital'
          ..address = 'Thapathali, Kathmandu'
          ..phone = '+977-1-4258554'
          ..latitude = 27.6929
          ..longitude = 85.3184
          ..openHours = '24/7'
          ..hasEmergency = true
          ..isOpen24Hours = true
          ..createdAt = now
          ..syncStatus = 0,
      ];
      for (final o in hospitals) {
        await orgBox.add(o);
      }
    }

    // RBAC permissions (single source of truth copied from mock_seed)
    await _seedRbacPermissions(now);
    await _seedClinicalActionPermissions(now);
  }

  static Future<void> _seedRbacPermissions(DateTime now) async {
    final box = DatabaseService.rbacPermissions;
    if (box.isNotEmpty) return;

    const resources = ['patients', 'encounters', 'appointments', 'organizations', 'users', 'audit_log', 'settings', 'reports'];
    const actions = ['read', 'create', 'update', 'delete', 'export'];

    const rolePermissions = {
      'patient': {
        'patients': ['read'],
        'encounters': ['read'],
        'appointments': ['read', 'create', 'update'],
        'organizations': ['read'],
        'reports': ['read', 'export'],
      },
      'doctor': {
        'patients': ['read', 'create', 'update'],
        'encounters': ['read', 'create', 'update'],
        'appointments': ['read', 'create', 'update', 'delete'],
        'organizations': ['read'],
        'reports': ['read', 'create', 'export'],
      },
      'nurse': {
        'patients': ['read', 'update'],
        'encounters': ['read', 'create', 'update'],
        'appointments': ['read', 'update'],
        'organizations': ['read'],
        'reports': ['read'],
      },
      'admin': {
        'patients': ['read', 'create', 'update', 'delete', 'export'],
        'encounters': ['read', 'create', 'update', 'delete', 'export'],
        'appointments': ['read', 'create', 'update', 'delete', 'export'],
        'organizations': ['read', 'create', 'update', 'delete'],
        'users': ['read', 'create', 'update', 'delete'],
        'audit_log': ['read', 'export'],
        'settings': ['read', 'update'],
        'reports': ['read', 'create', 'update', 'delete', 'export'],
      },
    };

    for (final role in rolePermissions.entries) {
      final roleId = role.key;
      final roleName = roleId[0].toUpperCase() + roleId.substring(1);
      final allowed = role.value;
      for (final resource in resources) {
        for (final action in actions) {
          final isAllowed = allowed[resource]?.contains(action) ?? false;
          await box.add(RbacPermissionLocal()
            ..roleId = roleId
            ..roleName = roleName
            ..resource = resource
            ..action = action
            ..isAllowed = isAllowed
            ..createdAt = now);
        }
      }
    }
  }

  static Future<void> _seedClinicalActionPermissions(DateTime now) async {
    final box = DatabaseService.rbacPermissions;
    const matrix = <String, Map<String, bool>>{
      'encounter.sign':      {'doctor': true,  'nurse': false},
      'encounter.finalize':  {'doctor': true,  'nurse': false},
      'prescription.issue':  {'doctor': true,  'nurse': false},
      'order.lab':           {'doctor': true,  'nurse': false},
      'order.imaging':       {'doctor': true,  'nurse': false},
      'vitals.record':       {'doctor': true,  'nurse': true},
      'triage.update':       {'doctor': true,  'nurse': true},
    };
    bool exists(String roleId, String resource, String action) {
      return box.values.any((p) =>
          p.roleId == roleId && p.resource == resource && p.action == action);
    }
    for (final entry in matrix.entries) {
      final parts = entry.key.split('.');
      final resource = parts[0];
      final action = parts[1];
      for (final role in entry.value.entries) {
        if (exists(role.key, resource, action)) continue;
        await box.add(RbacPermissionLocal()
          ..roleId = role.key
          ..roleName = role.key[0].toUpperCase() + role.key.substring(1)
          ..resource = resource
          ..action = action
          ..isAllowed = role.value
          ..createdAt = now);
      }
    }
  }
}
