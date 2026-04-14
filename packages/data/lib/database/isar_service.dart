import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';
import 'package:cc_fhir_models/collections/fhir_resource_collection.dart';
import 'package:cc_fhir_models/collections/ambulance_request_collection.dart';
import 'package:cc_fhir_models/collections/appointment_collection.dart';
import 'package:cc_fhir_models/collections/schedule_slot_collection.dart';
import 'package:cc_fhir_models/collections/pharmacy_order_collection.dart';
import 'package:cc_fhir_models/collections/insurance_claim_collection.dart';
import 'package:cc_fhir_models/collections/notification_record_collection.dart';
import 'package:cc_fhir_models/collections/health_tip_collection.dart';
import 'package:cc_fhir_models/collections/organization_collection.dart';
import 'package:cc_fhir_models/collections/lab_booking_collection.dart';
import 'package:cc_fhir_models/collections/encounter_collection.dart';
import 'package:cc_fhir_models/collections/condition_collection.dart';
import 'package:cc_fhir_models/collections/procedure_collection.dart';
import 'package:cc_fhir_models/collections/care_plan_collection.dart';
import 'package:cc_fhir_models/collections/service_request_collection.dart';
import 'package:cc_fhir_models/collections/medication_request_collection.dart';
import 'package:cc_fhir_models/collections/location_collection.dart';
import 'package:cc_fhir_models/collections/healthcare_service_collection.dart';
import 'package:cc_fhir_models/collections/practitioner_role_collection.dart';
import 'package:cc_fhir_models/collections/slot_collection.dart';
import 'package:cc_fhir_models/collections/immunization_collection.dart';
import 'package:cc_fhir_models/collections/allergy_intolerance_collection.dart';
import 'package:cc_fhir_models/collections/audit_event_collection.dart';
import 'package:cc_fhir_models/collections/rbac_permission_collection.dart';
import 'package:cc_fhir_models/collections/payment_collection.dart';
import 'package:cc_fhir_models/collections/provenance_collection.dart';
import 'package:cc_fhir_models/collections/composition_collection.dart';

/// Database service using Hive CE.
/// Works on mobile, desktop, AND web.
class DatabaseService {
  static bool _initialized = false;

  // Original boxes (TypeIds 0-10)
  static const String userAccountsBox = 'user_accounts';
  static const String fhirResourcesBox = 'fhir_resources';
  static const String ambulanceRequestsBox = 'ambulance_requests';
  static const String appointmentsBox = 'appointments';
  static const String scheduleSlotsBox = 'schedule_slots';
  static const String pharmacyOrdersBox = 'pharmacy_orders';
  static const String insuranceClaimsBox = 'insurance_claims';
  static const String notificationRecordsBox = 'notification_records';
  static const String healthTipsBox = 'health_tips';
  static const String organizationsBox = 'organizations';
  static const String labBookingsBox = 'lab_bookings';

  // New boxes (TypeIds 11-25)
  static const String encountersBox = 'encounters';
  static const String conditionsBox = 'conditions';
  static const String proceduresBox = 'procedures';
  static const String carePlansBox = 'care_plans';
  static const String serviceRequestsBox = 'service_requests';
  static const String medicationRequestsBox = 'medication_requests';
  static const String locationsBox = 'locations';
  static const String healthcareServicesBox = 'healthcare_services';
  static const String practitionerRolesBox = 'practitioner_roles';
  static const String slotsBox = 'slots';
  static const String immunizationsBox = 'immunizations';
  static const String allergyIntolerancesBox = 'allergy_intolerances';
  static const String auditEventsBox = 'audit_events';
  static const String rbacPermissionsBox = 'rbac_permissions';
  static const String paymentsBox = 'payments';

  // FHIR audit trail (TypeIds 26-27)
  static const String provenancesBox = 'provenances';
  static const String compositionsBox = 'compositions';

  static Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register adapters (TypeIds 0-10)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAccountAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FhirResourceAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AmbulanceRequestLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AppointmentLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ScheduleSlotLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PharmacyOrderLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(InsuranceClaimLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(NotificationRecordLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(HealthTipLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(OrganizationLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(LabBookingLocalAdapter());
    }

    // Register adapters (TypeIds 11-25)
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(EncounterLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(ConditionLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(ProcedureLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(CarePlanLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(ServiceRequestLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(MedicationRequestLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(17)) {
      Hive.registerAdapter(LocationLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(18)) {
      Hive.registerAdapter(HealthcareServiceLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(19)) {
      Hive.registerAdapter(PractitionerRoleLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(SlotLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(ImmunizationLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(AllergyIntoleranceLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(AuditEventLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(RbacPermissionLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(PaymentLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(ProvenanceLocalAdapter());
    }
    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(CompositionLocalAdapter());
    }

    // Open boxes (TypeIds 0-10)
    await Hive.openBox<UserAccount>(userAccountsBox);
    await Hive.openBox<FhirResource>(fhirResourcesBox);
    await Hive.openBox<AmbulanceRequestLocal>(ambulanceRequestsBox);
    await Hive.openBox<AppointmentLocal>(appointmentsBox);
    await Hive.openBox<ScheduleSlotLocal>(scheduleSlotsBox);
    await Hive.openBox<PharmacyOrderLocal>(pharmacyOrdersBox);
    await Hive.openBox<InsuranceClaimLocal>(insuranceClaimsBox);
    await Hive.openBox<NotificationRecordLocal>(notificationRecordsBox);
    await Hive.openBox<HealthTipLocal>(healthTipsBox);
    await Hive.openBox<OrganizationLocal>(organizationsBox);
    await Hive.openBox<LabBookingLocal>(labBookingsBox);

    // Open boxes (TypeIds 11-25)
    await Hive.openBox<EncounterLocal>(encountersBox);
    await Hive.openBox<ConditionLocal>(conditionsBox);
    await Hive.openBox<ProcedureLocal>(proceduresBox);
    await Hive.openBox<CarePlanLocal>(carePlansBox);
    await Hive.openBox<ServiceRequestLocal>(serviceRequestsBox);
    await Hive.openBox<MedicationRequestLocal>(medicationRequestsBox);
    await Hive.openBox<LocationLocal>(locationsBox);
    await Hive.openBox<HealthcareServiceLocal>(healthcareServicesBox);
    await Hive.openBox<PractitionerRoleLocal>(practitionerRolesBox);
    await Hive.openBox<SlotLocal>(slotsBox);
    await Hive.openBox<ImmunizationLocal>(immunizationsBox);
    await Hive.openBox<AllergyIntoleranceLocal>(allergyIntolerancesBox);
    await Hive.openBox<AuditEventLocal>(auditEventsBox);
    await Hive.openBox<RbacPermissionLocal>(rbacPermissionsBox);
    await Hive.openBox<PaymentLocal>(paymentsBox);
    await Hive.openBox<ProvenanceLocal>(provenancesBox);
    await Hive.openBox<CompositionLocal>(compositionsBox);

    _initialized = true;
  }

  // Getters (TypeIds 0-10)
  static Box<UserAccount> get userAccounts =>
      Hive.box<UserAccount>(userAccountsBox);

  static Box<FhirResource> get fhirResources =>
      Hive.box<FhirResource>(fhirResourcesBox);

  static Box<AmbulanceRequestLocal> get ambulanceRequests =>
      Hive.box<AmbulanceRequestLocal>(ambulanceRequestsBox);

  static Box<AppointmentLocal> get appointments =>
      Hive.box<AppointmentLocal>(appointmentsBox);

  static Box<ScheduleSlotLocal> get scheduleSlots =>
      Hive.box<ScheduleSlotLocal>(scheduleSlotsBox);

  static Box<PharmacyOrderLocal> get pharmacyOrders =>
      Hive.box<PharmacyOrderLocal>(pharmacyOrdersBox);

  static Box<InsuranceClaimLocal> get insuranceClaims =>
      Hive.box<InsuranceClaimLocal>(insuranceClaimsBox);

  static Box<NotificationRecordLocal> get notificationRecords =>
      Hive.box<NotificationRecordLocal>(notificationRecordsBox);

  static Box<HealthTipLocal> get healthTips =>
      Hive.box<HealthTipLocal>(healthTipsBox);

  static Box<OrganizationLocal> get organizations =>
      Hive.box<OrganizationLocal>(organizationsBox);

  static Box<LabBookingLocal> get labBookings =>
      Hive.box<LabBookingLocal>(labBookingsBox);

  // Getters (TypeIds 11-25)
  static Box<EncounterLocal> get encounters =>
      Hive.box<EncounterLocal>(encountersBox);

  static Box<ConditionLocal> get conditions =>
      Hive.box<ConditionLocal>(conditionsBox);

  static Box<ProcedureLocal> get procedures =>
      Hive.box<ProcedureLocal>(proceduresBox);

  static Box<CarePlanLocal> get carePlans =>
      Hive.box<CarePlanLocal>(carePlansBox);

  static Box<ServiceRequestLocal> get serviceRequests =>
      Hive.box<ServiceRequestLocal>(serviceRequestsBox);

  static Box<MedicationRequestLocal> get medicationRequests =>
      Hive.box<MedicationRequestLocal>(medicationRequestsBox);

  static Box<LocationLocal> get locations =>
      Hive.box<LocationLocal>(locationsBox);

  static Box<HealthcareServiceLocal> get healthcareServices =>
      Hive.box<HealthcareServiceLocal>(healthcareServicesBox);

  static Box<PractitionerRoleLocal> get practitionerRoles =>
      Hive.box<PractitionerRoleLocal>(practitionerRolesBox);

  static Box<SlotLocal> get slots =>
      Hive.box<SlotLocal>(slotsBox);

  static Box<ImmunizationLocal> get immunizations =>
      Hive.box<ImmunizationLocal>(immunizationsBox);

  static Box<AllergyIntoleranceLocal> get allergyIntolerances =>
      Hive.box<AllergyIntoleranceLocal>(allergyIntolerancesBox);

  static Box<AuditEventLocal> get auditEvents =>
      Hive.box<AuditEventLocal>(auditEventsBox);

  static Box<RbacPermissionLocal> get rbacPermissions =>
      Hive.box<RbacPermissionLocal>(rbacPermissionsBox);

  static Box<PaymentLocal> get payments =>
      Hive.box<PaymentLocal>(paymentsBox);

  static Box<ProvenanceLocal> get provenances =>
      Hive.box<ProvenanceLocal>(provenancesBox);

  static Box<CompositionLocal> get compositions =>
      Hive.box<CompositionLocal>(compositionsBox);

  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
