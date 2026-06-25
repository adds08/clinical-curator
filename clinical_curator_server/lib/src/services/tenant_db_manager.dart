/// Stub for multi-tenancy support.
/// In production this manages per-facility database connections.
class TenantDatabaseManager {
  /// Get module mask for a facility. Returns 0 if no mask set.
  Future<int> getModuleMask(int organizationId) async {
    // Placeholder — organization_databases table needs a migration first.
    // Returns 0 meaning "all modules disabled by default."
    return 0;
  }

  /// Register facility database (stub).
  Future<void> registerFacilityDatabase(int organizationId, String slug) async {
    // Placeholder — requires organization_databases table migration.
  }
}

/// Facility module bitmask constants.
class FacilityModules {
  static const int opd = 1;
  static const int pharmacy = 2;
  static const int lab = 4;
  static const int immunization = 8;
  static const int maternalHealth = 16;
  static const int ncd = 32;
  static const int referral = 64;
  static const int telemedicine = 128;
  static const int ambulance = 256;
  static const int insurance = 512;
}
