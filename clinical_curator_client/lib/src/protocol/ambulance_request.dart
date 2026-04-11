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

/// Ambulance dispatch request with tracking status.
abstract class AmbulanceRequest implements _i1.SerializableModel {
  AmbulanceRequest._({
    this.id,
    required this.patientRef,
    required this.patientName,
    required this.contactNumber,
    required this.emergencyType,
    required this.pickupLocation,
    required this.status,
    this.latitude,
    this.longitude,
    this.assignedDriverName,
    this.assignedVehicleNumber,
    this.estimatedArrivalMinutes,
    this.notes,
    this.cancellationReason,
    this.timelinessRating,
    this.helpfulnessRating,
    this.feedbackNotes,
    required this.createdAt,
    this.updatedAt,
  });

  factory AmbulanceRequest({
    int? id,
    required String patientRef,
    required String patientName,
    required String contactNumber,
    required String emergencyType,
    required String pickupLocation,
    required String status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AmbulanceRequestImpl;

  factory AmbulanceRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return AmbulanceRequest(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      patientName: jsonSerialization['patientName'] as String,
      contactNumber: jsonSerialization['contactNumber'] as String,
      emergencyType: jsonSerialization['emergencyType'] as String,
      pickupLocation: jsonSerialization['pickupLocation'] as String,
      status: jsonSerialization['status'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      assignedDriverName: jsonSerialization['assignedDriverName'] as String?,
      assignedVehicleNumber:
          jsonSerialization['assignedVehicleNumber'] as String?,
      estimatedArrivalMinutes:
          jsonSerialization['estimatedArrivalMinutes'] as int?,
      notes: jsonSerialization['notes'] as String?,
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      timelinessRating: jsonSerialization['timelinessRating'] as String?,
      helpfulnessRating: jsonSerialization['helpfulnessRating'] as int?,
      feedbackNotes: jsonSerialization['feedbackNotes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String patientRef;

  String patientName;

  String contactNumber;

  String emergencyType;

  String pickupLocation;

  String status;

  double? latitude;

  double? longitude;

  String? assignedDriverName;

  String? assignedVehicleNumber;

  int? estimatedArrivalMinutes;

  String? notes;

  String? cancellationReason;

  String? timelinessRating;

  int? helpfulnessRating;

  String? feedbackNotes;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [AmbulanceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AmbulanceRequest copyWith({
    int? id,
    String? patientRef,
    String? patientName,
    String? contactNumber,
    String? emergencyType,
    String? pickupLocation,
    String? status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AmbulanceRequest',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'emergencyType': emergencyType,
      'pickupLocation': pickupLocation,
      'status': status,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (assignedDriverName != null) 'assignedDriverName': assignedDriverName,
      if (assignedVehicleNumber != null)
        'assignedVehicleNumber': assignedVehicleNumber,
      if (estimatedArrivalMinutes != null)
        'estimatedArrivalMinutes': estimatedArrivalMinutes,
      if (notes != null) 'notes': notes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (timelinessRating != null) 'timelinessRating': timelinessRating,
      if (helpfulnessRating != null) 'helpfulnessRating': helpfulnessRating,
      if (feedbackNotes != null) 'feedbackNotes': feedbackNotes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AmbulanceRequestImpl extends AmbulanceRequest {
  _AmbulanceRequestImpl({
    int? id,
    required String patientRef,
    required String patientName,
    required String contactNumber,
    required String emergencyType,
    required String pickupLocation,
    required String status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         patientName: patientName,
         contactNumber: contactNumber,
         emergencyType: emergencyType,
         pickupLocation: pickupLocation,
         status: status,
         latitude: latitude,
         longitude: longitude,
         assignedDriverName: assignedDriverName,
         assignedVehicleNumber: assignedVehicleNumber,
         estimatedArrivalMinutes: estimatedArrivalMinutes,
         notes: notes,
         cancellationReason: cancellationReason,
         timelinessRating: timelinessRating,
         helpfulnessRating: helpfulnessRating,
         feedbackNotes: feedbackNotes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AmbulanceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AmbulanceRequest copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? patientName,
    String? contactNumber,
    String? emergencyType,
    String? pickupLocation,
    String? status,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? assignedDriverName = _Undefined,
    Object? assignedVehicleNumber = _Undefined,
    Object? estimatedArrivalMinutes = _Undefined,
    Object? notes = _Undefined,
    Object? cancellationReason = _Undefined,
    Object? timelinessRating = _Undefined,
    Object? helpfulnessRating = _Undefined,
    Object? feedbackNotes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return AmbulanceRequest(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      patientName: patientName ?? this.patientName,
      contactNumber: contactNumber ?? this.contactNumber,
      emergencyType: emergencyType ?? this.emergencyType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      status: status ?? this.status,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      assignedDriverName: assignedDriverName is String?
          ? assignedDriverName
          : this.assignedDriverName,
      assignedVehicleNumber: assignedVehicleNumber is String?
          ? assignedVehicleNumber
          : this.assignedVehicleNumber,
      estimatedArrivalMinutes: estimatedArrivalMinutes is int?
          ? estimatedArrivalMinutes
          : this.estimatedArrivalMinutes,
      notes: notes is String? ? notes : this.notes,
      cancellationReason: cancellationReason is String?
          ? cancellationReason
          : this.cancellationReason,
      timelinessRating: timelinessRating is String?
          ? timelinessRating
          : this.timelinessRating,
      helpfulnessRating: helpfulnessRating is int?
          ? helpfulnessRating
          : this.helpfulnessRating,
      feedbackNotes: feedbackNotes is String?
          ? feedbackNotes
          : this.feedbackNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
