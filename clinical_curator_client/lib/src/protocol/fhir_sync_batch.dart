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
import 'fhir_resource.dart' as _i2;
import 'package:clinical_curator_client/src/protocol/protocol.dart' as _i3;

/// DTO returned by FhirSyncEndpoint.since. Non-persisted — pure transport shape.
abstract class FhirSyncBatchDto implements _i1.SerializableModel {
  FhirSyncBatchDto._({
    required this.resources,
    required this.nextSince,
    required this.hasMore,
  });

  factory FhirSyncBatchDto({
    required List<_i2.FhirResourceRecord> resources,
    required DateTime nextSince,
    required bool hasMore,
  }) = _FhirSyncBatchDtoImpl;

  factory FhirSyncBatchDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return FhirSyncBatchDto(
      resources: _i3.Protocol().deserialize<List<_i2.FhirResourceRecord>>(
        jsonSerialization['resources'],
      ),
      nextSince: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['nextSince'],
      ),
      hasMore: _i1.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
    );
  }

  List<_i2.FhirResourceRecord> resources;

  DateTime nextSince;

  bool hasMore;

  /// Returns a shallow copy of this [FhirSyncBatchDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FhirSyncBatchDto copyWith({
    List<_i2.FhirResourceRecord>? resources,
    DateTime? nextSince,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FhirSyncBatchDto',
      'resources': resources.toJson(valueToJson: (v) => v.toJson()),
      'nextSince': nextSince.toJson(),
      'hasMore': hasMore,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FhirSyncBatchDtoImpl extends FhirSyncBatchDto {
  _FhirSyncBatchDtoImpl({
    required List<_i2.FhirResourceRecord> resources,
    required DateTime nextSince,
    required bool hasMore,
  }) : super._(
         resources: resources,
         nextSince: nextSince,
         hasMore: hasMore,
       );

  /// Returns a shallow copy of this [FhirSyncBatchDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FhirSyncBatchDto copyWith({
    List<_i2.FhirResourceRecord>? resources,
    DateTime? nextSince,
    bool? hasMore,
  }) {
    return FhirSyncBatchDto(
      resources:
          resources ?? this.resources.map((e0) => e0.copyWith()).toList(),
      nextSince: nextSince ?? this.nextSince,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
