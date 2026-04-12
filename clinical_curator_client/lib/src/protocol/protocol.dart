/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'allergy_intolerance.dart' as _i2;
import 'ambulance_request.dart' as _i3;
import 'appointment.dart' as _i4;
import 'audit_event.dart' as _i5;
import 'care_plan.dart' as _i6;
import 'condition.dart' as _i7;
import 'encounter.dart' as _i8;
import 'fhir_resource.dart' as _i9;
import 'greetings/greeting.dart' as _i10;
import 'health_tip.dart' as _i11;
import 'healthcare_service.dart' as _i12;
import 'immunization.dart' as _i13;
import 'insurance_claim.dart' as _i14;
import 'lab_booking.dart' as _i15;
import 'location.dart' as _i16;
import 'medication_request.dart' as _i17;
import 'notification_record.dart' as _i18;
import 'organization.dart' as _i19;
import 'payment.dart' as _i20;
import 'pharmacy_order.dart' as _i21;
import 'practitioner_role.dart' as _i22;
import 'procedure.dart' as _i23;
import 'rbac_permission.dart' as _i24;
import 'schedule_slot.dart' as _i25;
import 'service_request.dart' as _i26;
import 'slot.dart' as _i27;
import 'user_account.dart' as _i28;
import 'package:clinical_curator_client/src/protocol/user_account.dart' as _i29;
import 'package:clinical_curator_client/src/protocol/ambulance_request.dart'
    as _i30;
import 'package:clinical_curator_client/src/protocol/appointment.dart' as _i31;
import 'package:clinical_curator_client/src/protocol/fhir_resource.dart'
    as _i32;
import 'package:clinical_curator_client/src/protocol/health_tip.dart' as _i33;
import 'package:clinical_curator_client/src/protocol/insurance_claim.dart'
    as _i34;
import 'package:clinical_curator_client/src/protocol/lab_booking.dart' as _i35;
import 'package:clinical_curator_client/src/protocol/notification_record.dart'
    as _i36;
import 'package:clinical_curator_client/src/protocol/organization.dart' as _i37;
import 'package:clinical_curator_client/src/protocol/pharmacy_order.dart'
    as _i38;
import 'package:clinical_curator_client/src/protocol/schedule_slot.dart'
    as _i39;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i40;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i41;
export 'allergy_intolerance.dart';
export 'ambulance_request.dart';
export 'appointment.dart';
export 'audit_event.dart';
export 'care_plan.dart';
export 'condition.dart';
export 'encounter.dart';
export 'fhir_resource.dart';
export 'greetings/greeting.dart';
export 'health_tip.dart';
export 'healthcare_service.dart';
export 'immunization.dart';
export 'insurance_claim.dart';
export 'lab_booking.dart';
export 'location.dart';
export 'medication_request.dart';
export 'notification_record.dart';
export 'organization.dart';
export 'payment.dart';
export 'pharmacy_order.dart';
export 'practitioner_role.dart';
export 'procedure.dart';
export 'rbac_permission.dart';
export 'schedule_slot.dart';
export 'service_request.dart';
export 'slot.dart';
export 'user_account.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AllergyIntolerance) {
      return _i2.AllergyIntolerance.fromJson(data) as T;
    }
    if (t == _i3.AmbulanceRequest) {
      return _i3.AmbulanceRequest.fromJson(data) as T;
    }
    if (t == _i4.Appointment) {
      return _i4.Appointment.fromJson(data) as T;
    }
    if (t == _i5.AuditEvent) {
      return _i5.AuditEvent.fromJson(data) as T;
    }
    if (t == _i6.CarePlan) {
      return _i6.CarePlan.fromJson(data) as T;
    }
    if (t == _i7.Condition) {
      return _i7.Condition.fromJson(data) as T;
    }
    if (t == _i8.Encounter) {
      return _i8.Encounter.fromJson(data) as T;
    }
    if (t == _i9.FhirResourceRecord) {
      return _i9.FhirResourceRecord.fromJson(data) as T;
    }
    if (t == _i10.Greeting) {
      return _i10.Greeting.fromJson(data) as T;
    }
    if (t == _i11.HealthTip) {
      return _i11.HealthTip.fromJson(data) as T;
    }
    if (t == _i12.HealthcareService) {
      return _i12.HealthcareService.fromJson(data) as T;
    }
    if (t == _i13.Immunization) {
      return _i13.Immunization.fromJson(data) as T;
    }
    if (t == _i14.InsuranceClaim) {
      return _i14.InsuranceClaim.fromJson(data) as T;
    }
    if (t == _i15.LabBooking) {
      return _i15.LabBooking.fromJson(data) as T;
    }
    if (t == _i16.Location) {
      return _i16.Location.fromJson(data) as T;
    }
    if (t == _i17.MedicationRequest) {
      return _i17.MedicationRequest.fromJson(data) as T;
    }
    if (t == _i18.NotificationRecord) {
      return _i18.NotificationRecord.fromJson(data) as T;
    }
    if (t == _i19.Organization) {
      return _i19.Organization.fromJson(data) as T;
    }
    if (t == _i20.Payment) {
      return _i20.Payment.fromJson(data) as T;
    }
    if (t == _i21.PharmacyOrder) {
      return _i21.PharmacyOrder.fromJson(data) as T;
    }
    if (t == _i22.PractitionerRole) {
      return _i22.PractitionerRole.fromJson(data) as T;
    }
    if (t == _i23.Procedure) {
      return _i23.Procedure.fromJson(data) as T;
    }
    if (t == _i24.RbacPermission) {
      return _i24.RbacPermission.fromJson(data) as T;
    }
    if (t == _i25.ScheduleSlot) {
      return _i25.ScheduleSlot.fromJson(data) as T;
    }
    if (t == _i26.ServiceRequest) {
      return _i26.ServiceRequest.fromJson(data) as T;
    }
    if (t == _i27.Slot) {
      return _i27.Slot.fromJson(data) as T;
    }
    if (t == _i28.UserAccount) {
      return _i28.UserAccount.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AllergyIntolerance?>()) {
      return (data != null ? _i2.AllergyIntolerance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AmbulanceRequest?>()) {
      return (data != null ? _i3.AmbulanceRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Appointment?>()) {
      return (data != null ? _i4.Appointment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuditEvent?>()) {
      return (data != null ? _i5.AuditEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CarePlan?>()) {
      return (data != null ? _i6.CarePlan.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Condition?>()) {
      return (data != null ? _i7.Condition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Encounter?>()) {
      return (data != null ? _i8.Encounter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.FhirResourceRecord?>()) {
      return (data != null ? _i9.FhirResourceRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Greeting?>()) {
      return (data != null ? _i10.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.HealthTip?>()) {
      return (data != null ? _i11.HealthTip.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.HealthcareService?>()) {
      return (data != null ? _i12.HealthcareService.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Immunization?>()) {
      return (data != null ? _i13.Immunization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.InsuranceClaim?>()) {
      return (data != null ? _i14.InsuranceClaim.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.LabBooking?>()) {
      return (data != null ? _i15.LabBooking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Location?>()) {
      return (data != null ? _i16.Location.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MedicationRequest?>()) {
      return (data != null ? _i17.MedicationRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.NotificationRecord?>()) {
      return (data != null ? _i18.NotificationRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.Organization?>()) {
      return (data != null ? _i19.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Payment?>()) {
      return (data != null ? _i20.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PharmacyOrder?>()) {
      return (data != null ? _i21.PharmacyOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PractitionerRole?>()) {
      return (data != null ? _i22.PractitionerRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Procedure?>()) {
      return (data != null ? _i23.Procedure.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.RbacPermission?>()) {
      return (data != null ? _i24.RbacPermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ScheduleSlot?>()) {
      return (data != null ? _i25.ScheduleSlot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ServiceRequest?>()) {
      return (data != null ? _i26.ServiceRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Slot?>()) {
      return (data != null ? _i27.Slot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.UserAccount?>()) {
      return (data != null ? _i28.UserAccount.fromJson(data) : null) as T;
    }
    if (t == List<_i29.UserAccount>) {
      return (data as List)
              .map((e) => deserialize<_i29.UserAccount>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i30.AmbulanceRequest>) {
      return (data as List)
              .map((e) => deserialize<_i30.AmbulanceRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.Appointment>) {
      return (data as List)
              .map((e) => deserialize<_i31.Appointment>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.FhirResourceRecord>) {
      return (data as List)
              .map((e) => deserialize<_i32.FhirResourceRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.HealthTip>) {
      return (data as List).map((e) => deserialize<_i33.HealthTip>(e)).toList()
          as T;
    }
    if (t == List<_i34.InsuranceClaim>) {
      return (data as List)
              .map((e) => deserialize<_i34.InsuranceClaim>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.LabBooking>) {
      return (data as List).map((e) => deserialize<_i35.LabBooking>(e)).toList()
          as T;
    }
    if (t == List<_i36.NotificationRecord>) {
      return (data as List)
              .map((e) => deserialize<_i36.NotificationRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i37.Organization>(e))
              .toList()
          as T;
    }
    if (t == List<_i38.PharmacyOrder>) {
      return (data as List)
              .map((e) => deserialize<_i38.PharmacyOrder>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.ScheduleSlot>) {
      return (data as List)
              .map((e) => deserialize<_i39.ScheduleSlot>(e))
              .toList()
          as T;
    }
    try {
      return _i40.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i41.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AllergyIntolerance => 'AllergyIntolerance',
      _i3.AmbulanceRequest => 'AmbulanceRequest',
      _i4.Appointment => 'Appointment',
      _i5.AuditEvent => 'AuditEvent',
      _i6.CarePlan => 'CarePlan',
      _i7.Condition => 'Condition',
      _i8.Encounter => 'Encounter',
      _i9.FhirResourceRecord => 'FhirResourceRecord',
      _i10.Greeting => 'Greeting',
      _i11.HealthTip => 'HealthTip',
      _i12.HealthcareService => 'HealthcareService',
      _i13.Immunization => 'Immunization',
      _i14.InsuranceClaim => 'InsuranceClaim',
      _i15.LabBooking => 'LabBooking',
      _i16.Location => 'Location',
      _i17.MedicationRequest => 'MedicationRequest',
      _i18.NotificationRecord => 'NotificationRecord',
      _i19.Organization => 'Organization',
      _i20.Payment => 'Payment',
      _i21.PharmacyOrder => 'PharmacyOrder',
      _i22.PractitionerRole => 'PractitionerRole',
      _i23.Procedure => 'Procedure',
      _i24.RbacPermission => 'RbacPermission',
      _i25.ScheduleSlot => 'ScheduleSlot',
      _i26.ServiceRequest => 'ServiceRequest',
      _i27.Slot => 'Slot',
      _i28.UserAccount => 'UserAccount',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'clinical_curator.',
        '',
      );
    }

    switch (data) {
      case _i2.AllergyIntolerance():
        return 'AllergyIntolerance';
      case _i3.AmbulanceRequest():
        return 'AmbulanceRequest';
      case _i4.Appointment():
        return 'Appointment';
      case _i5.AuditEvent():
        return 'AuditEvent';
      case _i6.CarePlan():
        return 'CarePlan';
      case _i7.Condition():
        return 'Condition';
      case _i8.Encounter():
        return 'Encounter';
      case _i9.FhirResourceRecord():
        return 'FhirResourceRecord';
      case _i10.Greeting():
        return 'Greeting';
      case _i11.HealthTip():
        return 'HealthTip';
      case _i12.HealthcareService():
        return 'HealthcareService';
      case _i13.Immunization():
        return 'Immunization';
      case _i14.InsuranceClaim():
        return 'InsuranceClaim';
      case _i15.LabBooking():
        return 'LabBooking';
      case _i16.Location():
        return 'Location';
      case _i17.MedicationRequest():
        return 'MedicationRequest';
      case _i18.NotificationRecord():
        return 'NotificationRecord';
      case _i19.Organization():
        return 'Organization';
      case _i20.Payment():
        return 'Payment';
      case _i21.PharmacyOrder():
        return 'PharmacyOrder';
      case _i22.PractitionerRole():
        return 'PractitionerRole';
      case _i23.Procedure():
        return 'Procedure';
      case _i24.RbacPermission():
        return 'RbacPermission';
      case _i25.ScheduleSlot():
        return 'ScheduleSlot';
      case _i26.ServiceRequest():
        return 'ServiceRequest';
      case _i27.Slot():
        return 'Slot';
      case _i28.UserAccount():
        return 'UserAccount';
    }
    className = _i40.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i41.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AllergyIntolerance') {
      return deserialize<_i2.AllergyIntolerance>(data['data']);
    }
    if (dataClassName == 'AmbulanceRequest') {
      return deserialize<_i3.AmbulanceRequest>(data['data']);
    }
    if (dataClassName == 'Appointment') {
      return deserialize<_i4.Appointment>(data['data']);
    }
    if (dataClassName == 'AuditEvent') {
      return deserialize<_i5.AuditEvent>(data['data']);
    }
    if (dataClassName == 'CarePlan') {
      return deserialize<_i6.CarePlan>(data['data']);
    }
    if (dataClassName == 'Condition') {
      return deserialize<_i7.Condition>(data['data']);
    }
    if (dataClassName == 'Encounter') {
      return deserialize<_i8.Encounter>(data['data']);
    }
    if (dataClassName == 'FhirResourceRecord') {
      return deserialize<_i9.FhirResourceRecord>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i10.Greeting>(data['data']);
    }
    if (dataClassName == 'HealthTip') {
      return deserialize<_i11.HealthTip>(data['data']);
    }
    if (dataClassName == 'HealthcareService') {
      return deserialize<_i12.HealthcareService>(data['data']);
    }
    if (dataClassName == 'Immunization') {
      return deserialize<_i13.Immunization>(data['data']);
    }
    if (dataClassName == 'InsuranceClaim') {
      return deserialize<_i14.InsuranceClaim>(data['data']);
    }
    if (dataClassName == 'LabBooking') {
      return deserialize<_i15.LabBooking>(data['data']);
    }
    if (dataClassName == 'Location') {
      return deserialize<_i16.Location>(data['data']);
    }
    if (dataClassName == 'MedicationRequest') {
      return deserialize<_i17.MedicationRequest>(data['data']);
    }
    if (dataClassName == 'NotificationRecord') {
      return deserialize<_i18.NotificationRecord>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i19.Organization>(data['data']);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i20.Payment>(data['data']);
    }
    if (dataClassName == 'PharmacyOrder') {
      return deserialize<_i21.PharmacyOrder>(data['data']);
    }
    if (dataClassName == 'PractitionerRole') {
      return deserialize<_i22.PractitionerRole>(data['data']);
    }
    if (dataClassName == 'Procedure') {
      return deserialize<_i23.Procedure>(data['data']);
    }
    if (dataClassName == 'RbacPermission') {
      return deserialize<_i24.RbacPermission>(data['data']);
    }
    if (dataClassName == 'ScheduleSlot') {
      return deserialize<_i25.ScheduleSlot>(data['data']);
    }
    if (dataClassName == 'ServiceRequest') {
      return deserialize<_i26.ServiceRequest>(data['data']);
    }
    if (dataClassName == 'Slot') {
      return deserialize<_i27.Slot>(data['data']);
    }
    if (dataClassName == 'UserAccount') {
      return deserialize<_i28.UserAccount>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i40.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i41.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i40.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i41.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
