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
import 'ambulance_request.dart' as _i2;
import 'appointment.dart' as _i3;
import 'fhir_resource.dart' as _i4;
import 'greetings/greeting.dart' as _i5;
import 'health_tip.dart' as _i6;
import 'insurance_claim.dart' as _i7;
import 'lab_booking.dart' as _i8;
import 'notification_record.dart' as _i9;
import 'organization.dart' as _i10;
import 'pharmacy_order.dart' as _i11;
import 'schedule_slot.dart' as _i12;
import 'user_account.dart' as _i13;
import 'package:clinical_curator_client/src/protocol/user_account.dart' as _i14;
import 'package:clinical_curator_client/src/protocol/ambulance_request.dart'
    as _i15;
import 'package:clinical_curator_client/src/protocol/appointment.dart' as _i16;
import 'package:clinical_curator_client/src/protocol/fhir_resource.dart'
    as _i17;
import 'package:clinical_curator_client/src/protocol/health_tip.dart' as _i18;
import 'package:clinical_curator_client/src/protocol/insurance_claim.dart'
    as _i19;
import 'package:clinical_curator_client/src/protocol/lab_booking.dart' as _i20;
import 'package:clinical_curator_client/src/protocol/notification_record.dart'
    as _i21;
import 'package:clinical_curator_client/src/protocol/organization.dart' as _i22;
import 'package:clinical_curator_client/src/protocol/pharmacy_order.dart'
    as _i23;
import 'package:clinical_curator_client/src/protocol/schedule_slot.dart'
    as _i24;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i25;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i26;
export 'ambulance_request.dart';
export 'appointment.dart';
export 'fhir_resource.dart';
export 'greetings/greeting.dart';
export 'health_tip.dart';
export 'insurance_claim.dart';
export 'lab_booking.dart';
export 'notification_record.dart';
export 'organization.dart';
export 'pharmacy_order.dart';
export 'schedule_slot.dart';
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

    if (t == _i2.AmbulanceRequest) {
      return _i2.AmbulanceRequest.fromJson(data) as T;
    }
    if (t == _i3.Appointment) {
      return _i3.Appointment.fromJson(data) as T;
    }
    if (t == _i4.FhirResourceRecord) {
      return _i4.FhirResourceRecord.fromJson(data) as T;
    }
    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.HealthTip) {
      return _i6.HealthTip.fromJson(data) as T;
    }
    if (t == _i7.InsuranceClaim) {
      return _i7.InsuranceClaim.fromJson(data) as T;
    }
    if (t == _i8.LabBooking) {
      return _i8.LabBooking.fromJson(data) as T;
    }
    if (t == _i9.NotificationRecord) {
      return _i9.NotificationRecord.fromJson(data) as T;
    }
    if (t == _i10.Organization) {
      return _i10.Organization.fromJson(data) as T;
    }
    if (t == _i11.PharmacyOrder) {
      return _i11.PharmacyOrder.fromJson(data) as T;
    }
    if (t == _i12.ScheduleSlot) {
      return _i12.ScheduleSlot.fromJson(data) as T;
    }
    if (t == _i13.UserAccount) {
      return _i13.UserAccount.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AmbulanceRequest?>()) {
      return (data != null ? _i2.AmbulanceRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Appointment?>()) {
      return (data != null ? _i3.Appointment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.FhirResourceRecord?>()) {
      return (data != null ? _i4.FhirResourceRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.HealthTip?>()) {
      return (data != null ? _i6.HealthTip.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.InsuranceClaim?>()) {
      return (data != null ? _i7.InsuranceClaim.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.LabBooking?>()) {
      return (data != null ? _i8.LabBooking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.NotificationRecord?>()) {
      return (data != null ? _i9.NotificationRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Organization?>()) {
      return (data != null ? _i10.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PharmacyOrder?>()) {
      return (data != null ? _i11.PharmacyOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ScheduleSlot?>()) {
      return (data != null ? _i12.ScheduleSlot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.UserAccount?>()) {
      return (data != null ? _i13.UserAccount.fromJson(data) : null) as T;
    }
    if (t == List<_i14.UserAccount>) {
      return (data as List)
              .map((e) => deserialize<_i14.UserAccount>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i15.AmbulanceRequest>) {
      return (data as List)
              .map((e) => deserialize<_i15.AmbulanceRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i16.Appointment>) {
      return (data as List)
              .map((e) => deserialize<_i16.Appointment>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.FhirResourceRecord>) {
      return (data as List)
              .map((e) => deserialize<_i17.FhirResourceRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.HealthTip>) {
      return (data as List).map((e) => deserialize<_i18.HealthTip>(e)).toList()
          as T;
    }
    if (t == List<_i19.InsuranceClaim>) {
      return (data as List)
              .map((e) => deserialize<_i19.InsuranceClaim>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.LabBooking>) {
      return (data as List).map((e) => deserialize<_i20.LabBooking>(e)).toList()
          as T;
    }
    if (t == List<_i21.NotificationRecord>) {
      return (data as List)
              .map((e) => deserialize<_i21.NotificationRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i22.Organization>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.PharmacyOrder>) {
      return (data as List)
              .map((e) => deserialize<_i23.PharmacyOrder>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.ScheduleSlot>) {
      return (data as List)
              .map((e) => deserialize<_i24.ScheduleSlot>(e))
              .toList()
          as T;
    }
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i26.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AmbulanceRequest => 'AmbulanceRequest',
      _i3.Appointment => 'Appointment',
      _i4.FhirResourceRecord => 'FhirResourceRecord',
      _i5.Greeting => 'Greeting',
      _i6.HealthTip => 'HealthTip',
      _i7.InsuranceClaim => 'InsuranceClaim',
      _i8.LabBooking => 'LabBooking',
      _i9.NotificationRecord => 'NotificationRecord',
      _i10.Organization => 'Organization',
      _i11.PharmacyOrder => 'PharmacyOrder',
      _i12.ScheduleSlot => 'ScheduleSlot',
      _i13.UserAccount => 'UserAccount',
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
      case _i2.AmbulanceRequest():
        return 'AmbulanceRequest';
      case _i3.Appointment():
        return 'Appointment';
      case _i4.FhirResourceRecord():
        return 'FhirResourceRecord';
      case _i5.Greeting():
        return 'Greeting';
      case _i6.HealthTip():
        return 'HealthTip';
      case _i7.InsuranceClaim():
        return 'InsuranceClaim';
      case _i8.LabBooking():
        return 'LabBooking';
      case _i9.NotificationRecord():
        return 'NotificationRecord';
      case _i10.Organization():
        return 'Organization';
      case _i11.PharmacyOrder():
        return 'PharmacyOrder';
      case _i12.ScheduleSlot():
        return 'ScheduleSlot';
      case _i13.UserAccount():
        return 'UserAccount';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i26.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AmbulanceRequest') {
      return deserialize<_i2.AmbulanceRequest>(data['data']);
    }
    if (dataClassName == 'Appointment') {
      return deserialize<_i3.Appointment>(data['data']);
    }
    if (dataClassName == 'FhirResourceRecord') {
      return deserialize<_i4.FhirResourceRecord>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'HealthTip') {
      return deserialize<_i6.HealthTip>(data['data']);
    }
    if (dataClassName == 'InsuranceClaim') {
      return deserialize<_i7.InsuranceClaim>(data['data']);
    }
    if (dataClassName == 'LabBooking') {
      return deserialize<_i8.LabBooking>(data['data']);
    }
    if (dataClassName == 'NotificationRecord') {
      return deserialize<_i9.NotificationRecord>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i10.Organization>(data['data']);
    }
    if (dataClassName == 'PharmacyOrder') {
      return deserialize<_i11.PharmacyOrder>(data['data']);
    }
    if (dataClassName == 'ScheduleSlot') {
      return deserialize<_i12.ScheduleSlot>(data['data']);
    }
    if (dataClassName == 'UserAccount') {
      return deserialize<_i13.UserAccount>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i25.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i26.Protocol().deserializeByClassName(data);
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
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i26.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
