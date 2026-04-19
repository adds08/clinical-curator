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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:clinical_curator_client/src/protocol/user_account.dart' as _i5;
import 'package:clinical_curator_client/src/protocol/ambulance_request.dart'
    as _i6;
import 'package:clinical_curator_client/src/protocol/appointment.dart' as _i7;
import 'package:clinical_curator_client/src/protocol/audit_event.dart' as _i8;
import 'package:clinical_curator_client/src/protocol/fhir_resource.dart' as _i9;
import 'package:clinical_curator_client/src/protocol/fhir_sync_batch.dart'
    as _i10;
import 'package:clinical_curator_client/src/protocol/health_tip.dart' as _i11;
import 'package:clinical_curator_client/src/protocol/insurance_claim.dart'
    as _i12;
import 'package:clinical_curator_client/src/protocol/lab_booking.dart' as _i13;
import 'package:clinical_curator_client/src/protocol/notification_record.dart'
    as _i14;
import 'package:clinical_curator_client/src/protocol/organization.dart' as _i15;
import 'package:clinical_curator_client/src/protocol/pharmacy_order.dart'
    as _i16;
import 'package:clinical_curator_client/src/protocol/rbac_permission.dart'
    as _i17;
import 'package:clinical_curator_client/src/protocol/schedule_slot.dart'
    as _i18;
import 'package:clinical_curator_client/src/protocol/greetings/greeting.dart'
    as _i19;
import 'protocol.dart' as _i20;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointAdmin extends _i2.EndpointRef {
  EndpointAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// List pending practitioner verifications.
  _i3.Future<List<_i5.UserAccount>> listPendingVerifications() =>
      caller.callServerEndpoint<List<_i5.UserAccount>>(
        'admin',
        'listPendingVerifications',
        {},
      );

  /// Approve a practitioner.
  _i3.Future<_i5.UserAccount> approvePractitioner(int id) =>
      caller.callServerEndpoint<_i5.UserAccount>(
        'admin',
        'approvePractitioner',
        {'id': id},
      );

  /// Reject a practitioner.
  _i3.Future<_i5.UserAccount> rejectPractitioner(int id) =>
      caller.callServerEndpoint<_i5.UserAccount>(
        'admin',
        'rejectPractitioner',
        {'id': id},
      );

  /// Get dashboard stats.
  _i3.Future<Map<String, int>> getDashboardStats() =>
      caller.callServerEndpoint<Map<String, int>>(
        'admin',
        'getDashboardStats',
        {},
      );

  /// List all verified practitioners.
  _i3.Future<List<_i5.UserAccount>> listVerifiedPractitioners() =>
      caller.callServerEndpoint<List<_i5.UserAccount>>(
        'admin',
        'listVerifiedPractitioners',
        {},
      );

  /// List all users, optionally filtered by `accountType`
  /// ('patient' | 'practitioner' | 'admin'). Pass null/empty for all.
  _i3.Future<List<_i5.UserAccount>> listAllUsers({String? accountType}) =>
      caller.callServerEndpoint<List<_i5.UserAccount>>(
        'admin',
        'listAllUsers',
        {'accountType': accountType},
      );

  /// Toggle a user's `isVerified` flag directly. Used by the admin
  /// manage-users screen for quick flips outside the verification flow.
  _i3.Future<_i5.UserAccount> setUserVerified(
    int id,
    bool isVerified,
  ) => caller.callServerEndpoint<_i5.UserAccount>(
    'admin',
    'setUserVerified',
    {
      'id': id,
      'isVerified': isVerified,
    },
  );

  /// Aggregate dashboard counts. Superset of `getDashboardStats` —
  /// includes patient/appointment/encounter counts in a single round-trip.
  _i3.Future<Map<String, int>> getAnalytics() =>
      caller.callServerEndpoint<Map<String, int>>(
        'admin',
        'getAnalytics',
        {},
      );
}

/// {@category Endpoint}
class EndpointAmbulance extends _i2.EndpointRef {
  EndpointAmbulance(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ambulance';

  /// Request an ambulance.
  _i3.Future<_i6.AmbulanceRequest> request(_i6.AmbulanceRequest request) =>
      caller.callServerEndpoint<_i6.AmbulanceRequest>(
        'ambulance',
        'request',
        {'request': request},
      );

  /// Update ambulance request status.
  _i3.Future<_i6.AmbulanceRequest> updateStatus(
    int id,
    String status, {
    String? driverName,
    String? vehicleNumber,
    int? estimatedMinutes,
    double? latitude,
    double? longitude,
  }) => caller.callServerEndpoint<_i6.AmbulanceRequest>(
    'ambulance',
    'updateStatus',
    {
      'id': id,
      'status': status,
      'driverName': driverName,
      'vehicleNumber': vehicleNumber,
      'estimatedMinutes': estimatedMinutes,
      'latitude': latitude,
      'longitude': longitude,
    },
  );

  /// Cancel an ambulance request with a reason.
  _i3.Future<_i6.AmbulanceRequest> cancelWithReason(
    int id,
    String reason,
  ) => caller.callServerEndpoint<_i6.AmbulanceRequest>(
    'ambulance',
    'cancelWithReason',
    {
      'id': id,
      'reason': reason,
    },
  );

  /// Complete an ambulance request with rating and feedback.
  _i3.Future<_i6.AmbulanceRequest> completeWithRating(
    int id,
    String timelinessRating,
    int helpfulnessRating, {
    String? feedbackNotes,
  }) => caller.callServerEndpoint<_i6.AmbulanceRequest>(
    'ambulance',
    'completeWithRating',
    {
      'id': id,
      'timelinessRating': timelinessRating,
      'helpfulnessRating': helpfulnessRating,
      'feedbackNotes': feedbackNotes,
    },
  );

  /// Get an ambulance request by ID.
  _i3.Future<_i6.AmbulanceRequest?> getById(int id) =>
      caller.callServerEndpoint<_i6.AmbulanceRequest?>(
        'ambulance',
        'getById',
        {'id': id},
      );

  /// List ambulance requests for a patient.
  _i3.Future<List<_i6.AmbulanceRequest>> listForPatient(String patientRef) =>
      caller.callServerEndpoint<List<_i6.AmbulanceRequest>>(
        'ambulance',
        'listForPatient',
        {'patientRef': patientRef},
      );

  /// List active ambulance requests (including arrived, awaiting confirmation).
  _i3.Future<List<_i6.AmbulanceRequest>> listActive() =>
      caller.callServerEndpoint<List<_i6.AmbulanceRequest>>(
        'ambulance',
        'listActive',
        {},
      );
}

/// {@category Endpoint}
class EndpointAppointment extends _i2.EndpointRef {
  EndpointAppointment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appointment';

  /// Book a new appointment.
  _i3.Future<_i7.Appointment> book(_i7.Appointment appointment) =>
      caller.callServerEndpoint<_i7.Appointment>(
        'appointment',
        'book',
        {'appointment': appointment},
      );

  /// Cancel an appointment by ID.
  _i3.Future<_i7.Appointment> cancel(int id) =>
      caller.callServerEndpoint<_i7.Appointment>(
        'appointment',
        'cancel',
        {'id': id},
      );

  /// Complete an appointment.
  _i3.Future<_i7.Appointment> complete(int id) =>
      caller.callServerEndpoint<_i7.Appointment>(
        'appointment',
        'complete',
        {'id': id},
      );

  /// List appointments for a patient.
  _i3.Future<List<_i7.Appointment>> listForPatient(String patientRef) =>
      caller.callServerEndpoint<List<_i7.Appointment>>(
        'appointment',
        'listForPatient',
        {'patientRef': patientRef},
      );

  /// List appointments for a practitioner.
  _i3.Future<List<_i7.Appointment>> listForPractitioner(
    String practitionerRef,
  ) => caller.callServerEndpoint<List<_i7.Appointment>>(
    'appointment',
    'listForPractitioner',
    {'practitionerRef': practitionerRef},
  );

  /// List today's appointments for a practitioner.
  _i3.Future<List<_i7.Appointment>> listTodayForPractitioner(
    String practitionerRef,
  ) => caller.callServerEndpoint<List<_i7.Appointment>>(
    'appointment',
    'listTodayForPractitioner',
    {'practitionerRef': practitionerRef},
  );

  /// Get appointment by ID.
  _i3.Future<_i7.Appointment?> getById(int id) =>
      caller.callServerEndpoint<_i7.Appointment?>(
        'appointment',
        'getById',
        {'id': id},
      );
}

/// Audit trail read/write. Admin app uses this for the audit-log screen
/// and to record admin actions (e.g. demo-data purges, verification
/// approvals that go beyond `admin.approvePractitioner`).
/// {@category Endpoint}
class EndpointAudit extends _i2.EndpointRef {
  EndpointAudit(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'audit';

  /// List audit events, newest first. Supports optional action filter.
  _i3.Future<List<_i8.AuditEvent>> list({
    String? action,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i8.AuditEvent>>(
    'audit',
    'list',
    {
      'action': action,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Recent N events — used by dashboard "Recent Activity" panel.
  _i3.Future<List<_i8.AuditEvent>> recent({required int limit}) =>
      caller.callServerEndpoint<List<_i8.AuditEvent>>(
        'audit',
        'recent',
        {'limit': limit},
      );

  /// Record a new audit event.
  _i3.Future<_i8.AuditEvent> record(_i8.AuditEvent event) =>
      caller.callServerEndpoint<_i8.AuditEvent>(
        'audit',
        'record',
        {'event': event},
      );
}

/// {@category Endpoint}
class EndpointAuth extends _i2.EndpointRef {
  EndpointAuth(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Login with email and password. Returns the UserAccount on success.
  _i3.Future<_i5.UserAccount?> login(
    String email,
    String password,
  ) => caller.callServerEndpoint<_i5.UserAccount?>(
    'auth',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Register a new patient account with bcrypt-hashed password.
  _i3.Future<_i5.UserAccount> signup(
    String email,
    String password,
    String displayName,
  ) => caller.callServerEndpoint<_i5.UserAccount>(
    'auth',
    'signup',
    {
      'email': email,
      'password': password,
      'displayName': displayName,
    },
  );

  /// Register as a practitioner (doctor/nurse). Creates a pending verification.
  _i3.Future<_i5.UserAccount> registerPractitioner(
    int userAccountId,
    String practitionerType,
    String licenseNumber,
    String specialization,
  ) => caller.callServerEndpoint<_i5.UserAccount>(
    'auth',
    'registerPractitioner',
    {
      'userAccountId': userAccountId,
      'practitionerType': practitionerType,
      'licenseNumber': licenseNumber,
      'specialization': specialization,
    },
  );

  /// Get user account by email.
  _i3.Future<_i5.UserAccount?> getByEmail(String email) =>
      caller.callServerEndpoint<_i5.UserAccount?>(
        'auth',
        'getByEmail',
        {'email': email},
      );

  /// Get user account by ID.
  _i3.Future<_i5.UserAccount?> getById(int id) =>
      caller.callServerEndpoint<_i5.UserAccount?>(
        'auth',
        'getById',
        {'id': id},
      );

  /// Update user profile fields.
  _i3.Future<_i5.UserAccount> updateProfile(_i5.UserAccount account) =>
      caller.callServerEndpoint<_i5.UserAccount>(
        'auth',
        'updateProfile',
        {'account': account},
      );

  /// Change password — hashes with bcrypt.
  _i3.Future<bool> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) => caller.callServerEndpoint<bool>(
    'auth',
    'changePassword',
    {
      'userId': userId,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );
}

/// {@category Endpoint}
class EndpointFhirResource extends _i2.EndpointRef {
  EndpointFhirResource(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'fhirResource';

  /// Create a new FHIR resource record.
  _i3.Future<_i9.FhirResourceRecord> create(_i9.FhirResourceRecord resource) =>
      caller.callServerEndpoint<_i9.FhirResourceRecord>(
        'fhirResource',
        'create',
        {'resource': resource},
      );

  /// Read a single FHIR resource by fhirId and resourceType.
  _i3.Future<_i9.FhirResourceRecord?> read(
    String fhirId,
    String resourceType,
  ) => caller.callServerEndpoint<_i9.FhirResourceRecord?>(
    'fhirResource',
    'read',
    {
      'fhirId': fhirId,
      'resourceType': resourceType,
    },
  );

  /// Update an existing FHIR resource (matched by fhirId + resourceType).
  _i3.Future<_i9.FhirResourceRecord> update(_i9.FhirResourceRecord resource) =>
      caller.callServerEndpoint<_i9.FhirResourceRecord>(
        'fhirResource',
        'update',
        {'resource': resource},
      );

  /// Delete a FHIR resource by its database ID.
  _i3.Future<void> deleteById(int id) => caller.callServerEndpoint<void>(
    'fhirResource',
    'deleteById',
    {'id': id},
  );

  /// Search FHIR resources by resource type.
  _i3.Future<List<_i9.FhirResourceRecord>> searchByType(
    String resourceType, {
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i9.FhirResourceRecord>>(
    'fhirResource',
    'searchByType',
    {
      'resourceType': resourceType,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Search FHIR resources by patient reference.
  _i3.Future<List<_i9.FhirResourceRecord>> searchByPatient(
    String patientReference, {
    String? resourceType,
    int? limit,
  }) => caller.callServerEndpoint<List<_i9.FhirResourceRecord>>(
    'fhirResource',
    'searchByPatient',
    {
      'patientReference': patientReference,
      'resourceType': resourceType,
      'limit': limit,
    },
  );

  /// Search FHIR resources by practitioner reference.
  _i3.Future<List<_i9.FhirResourceRecord>> searchByPractitioner(
    String practitionerReference, {
    String? resourceType,
    int? limit,
  }) => caller.callServerEndpoint<List<_i9.FhirResourceRecord>>(
    'fhirResource',
    'searchByPractitioner',
    {
      'practitionerReference': practitionerReference,
      'resourceType': resourceType,
      'limit': limit,
    },
  );

  /// Get all resources modified after a given timestamp (for sync).
  _i3.Future<List<_i9.FhirResourceRecord>> getChangesSince(DateTime since) =>
      caller.callServerEndpoint<List<_i9.FhirResourceRecord>>(
        'fhirResource',
        'getChangesSince',
        {'since': since},
      );
}

/// FHIR offline/online sync endpoint.
///
/// Implements a simple `_since` timestamp pattern over Serverpod. Clients
/// persist `lastSyncTimestamp_<resourceType>` locally; on each tick they
/// call [since] to pull server-side changes, then [push] to upload their
/// local dirty set. Server-side conflict resolution is last-write-wins
/// by comparing `meta.lastUpdated` in the embedded JSON.
/// {@category Endpoint}
class EndpointFhirSync extends _i2.EndpointRef {
  EndpointFhirSync(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'fhirSync';

  /// Returns resources of [resourceType] with `lastUpdated > since`,
  /// capped at [limit]. `nextSince` is the max `lastUpdated` in the
  /// returned batch (or the input `since` if the batch is empty).
  _i3.Future<_i10.FhirSyncBatchDto> since(
    String resourceType,
    DateTime since, {
    required int limit,
  }) => caller.callServerEndpoint<_i10.FhirSyncBatchDto>(
    'fhirSync',
    'since',
    {
      'resourceType': resourceType,
      'since': since,
      'limit': limit,
    },
  );

  /// Upserts a batch of resources by `fhirId`+`resourceType`. Last-write-wins
  /// on `meta.lastUpdated` inside the JSON payload. Resources whose server
  /// copy is newer are skipped.
  _i3.Future<void> push(List<_i9.FhirResourceRecord> resources) =>
      caller.callServerEndpoint<void>(
        'fhirSync',
        'push',
        {'resources': resources},
      );

  /// Admin-only. Deletes every FhirResourceRecord whose `patientReference`
  /// matches one of the demo patient ids. The optional [adminEmail] is
  /// cross-checked against `UserAccount.accountType == 'admin'` — if the
  /// caller isn't an admin, the call throws. Pass `null` to bypass (trust
  /// the transport, e.g. a local dev tool). Real RBAC middleware should
  /// replace this once Serverpod Auth is fully wired.
  _i3.Future<int> purgeDemoData({String? adminEmail}) =>
      caller.callServerEndpoint<int>(
        'fhirSync',
        'purgeDemoData',
        {'adminEmail': adminEmail},
      );
}

/// {@category Endpoint}
class EndpointHealthTip extends _i2.EndpointRef {
  EndpointHealthTip(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'healthTip';

  /// List active health tips.
  _i3.Future<List<_i11.HealthTip>> listAll({
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i11.HealthTip>>(
    'healthTip',
    'listAll',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Admin view: list every health tip regardless of `isActive`.
  _i3.Future<List<_i11.HealthTip>> listAllAdmin() =>
      caller.callServerEndpoint<List<_i11.HealthTip>>(
        'healthTip',
        'listAllAdmin',
        {},
      );

  _i3.Future<List<_i11.HealthTip>> listByCategory(
    String category, {
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i11.HealthTip>>(
    'healthTip',
    'listByCategory',
    {
      'category': category,
      'limit': limit,
      'offset': offset,
    },
  );

  _i3.Future<_i11.HealthTip?> getById(int id) =>
      caller.callServerEndpoint<_i11.HealthTip?>(
        'healthTip',
        'getById',
        {'id': id},
      );

  _i3.Future<_i11.HealthTip> create(_i11.HealthTip tip) =>
      caller.callServerEndpoint<_i11.HealthTip>(
        'healthTip',
        'create',
        {'tip': tip},
      );

  _i3.Future<_i11.HealthTip> update(_i11.HealthTip tip) =>
      caller.callServerEndpoint<_i11.HealthTip>(
        'healthTip',
        'update',
        {'tip': tip},
      );

  _i3.Future<bool> delete(int id) => caller.callServerEndpoint<bool>(
    'healthTip',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointInsurance extends _i2.EndpointRef {
  EndpointInsurance(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insurance';

  /// Submit a new insurance claim.
  _i3.Future<_i12.InsuranceClaim> submitClaim(_i12.InsuranceClaim claim) =>
      caller.callServerEndpoint<_i12.InsuranceClaim>(
        'insurance',
        'submitClaim',
        {'claim': claim},
      );

  /// List claims for a patient.
  _i3.Future<List<_i12.InsuranceClaim>> listClaims(String patientRef) =>
      caller.callServerEndpoint<List<_i12.InsuranceClaim>>(
        'insurance',
        'listClaims',
        {'patientRef': patientRef},
      );

  /// Update claim status.
  _i3.Future<_i12.InsuranceClaim> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i12.InsuranceClaim>(
    'insurance',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Get claim by ID.
  _i3.Future<_i12.InsuranceClaim?> getById(int id) =>
      caller.callServerEndpoint<_i12.InsuranceClaim?>(
        'insurance',
        'getById',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointLabBooking extends _i2.EndpointRef {
  EndpointLabBooking(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'labBooking';

  /// Create a lab booking.
  _i3.Future<_i13.LabBooking> create(_i13.LabBooking booking) =>
      caller.callServerEndpoint<_i13.LabBooking>(
        'labBooking',
        'create',
        {'booking': booking},
      );

  /// List bookings for a patient.
  _i3.Future<List<_i13.LabBooking>> listForPatient(String patientRef) =>
      caller.callServerEndpoint<List<_i13.LabBooking>>(
        'labBooking',
        'listForPatient',
        {'patientRef': patientRef},
      );

  /// Update booking status.
  _i3.Future<_i13.LabBooking> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i13.LabBooking>(
    'labBooking',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Get booking by ID.
  _i3.Future<_i13.LabBooking?> getById(int id) =>
      caller.callServerEndpoint<_i13.LabBooking?>(
        'labBooking',
        'getById',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointNotification extends _i2.EndpointRef {
  EndpointNotification(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Create a notification.
  _i3.Future<_i14.NotificationRecord> create(
    _i14.NotificationRecord notification,
  ) => caller.callServerEndpoint<_i14.NotificationRecord>(
    'notification',
    'create',
    {'notification': notification},
  );

  /// List notifications for a user.
  _i3.Future<List<_i14.NotificationRecord>> listForUser(String userEmail) =>
      caller.callServerEndpoint<List<_i14.NotificationRecord>>(
        'notification',
        'listForUser',
        {'userEmail': userEmail},
      );

  /// Mark a notification as read.
  _i3.Future<_i14.NotificationRecord> markAsRead(int id) =>
      caller.callServerEndpoint<_i14.NotificationRecord>(
        'notification',
        'markAsRead',
        {'id': id},
      );

  /// Mark all notifications as read for a user.
  _i3.Future<void> markAllAsRead(String userEmail) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markAllAsRead',
        {'userEmail': userEmail},
      );

  /// Get unread count for a user.
  _i3.Future<int> getUnreadCount(String userEmail) =>
      caller.callServerEndpoint<int>(
        'notification',
        'getUnreadCount',
        {'userEmail': userEmail},
      );
}

/// {@category Endpoint}
class EndpointOrganization extends _i2.EndpointRef {
  EndpointOrganization(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'organization';

  _i3.Future<List<_i15.Organization>> listAll() =>
      caller.callServerEndpoint<List<_i15.Organization>>(
        'organization',
        'listAll',
        {},
      );

  _i3.Future<List<_i15.Organization>> listHospitals() =>
      caller.callServerEndpoint<List<_i15.Organization>>(
        'organization',
        'listHospitals',
        {},
      );

  _i3.Future<List<_i15.Organization>> listPharmacies() =>
      caller.callServerEndpoint<List<_i15.Organization>>(
        'organization',
        'listPharmacies',
        {},
      );

  _i3.Future<List<_i15.Organization>> search(String query) =>
      caller.callServerEndpoint<List<_i15.Organization>>(
        'organization',
        'search',
        {'query': query},
      );

  _i3.Future<_i15.Organization?> getById(int id) =>
      caller.callServerEndpoint<_i15.Organization?>(
        'organization',
        'getById',
        {'id': id},
      );

  _i3.Future<_i15.Organization> create(_i15.Organization org) =>
      caller.callServerEndpoint<_i15.Organization>(
        'organization',
        'create',
        {'org': org},
      );

  _i3.Future<_i15.Organization> update(_i15.Organization org) =>
      caller.callServerEndpoint<_i15.Organization>(
        'organization',
        'update',
        {'org': org},
      );

  _i3.Future<bool> delete(int id) => caller.callServerEndpoint<bool>(
    'organization',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointPharmacy extends _i2.EndpointRef {
  EndpointPharmacy(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pharmacy';

  /// Create a pharmacy order.
  _i3.Future<_i16.PharmacyOrder> createOrder(_i16.PharmacyOrder order) =>
      caller.callServerEndpoint<_i16.PharmacyOrder>(
        'pharmacy',
        'createOrder',
        {'order': order},
      );

  /// List orders for a patient.
  _i3.Future<List<_i16.PharmacyOrder>> listOrders(String patientRef) =>
      caller.callServerEndpoint<List<_i16.PharmacyOrder>>(
        'pharmacy',
        'listOrders',
        {'patientRef': patientRef},
      );

  /// Update order status.
  _i3.Future<_i16.PharmacyOrder> updateStatus(
    int id,
    String status,
  ) => caller.callServerEndpoint<_i16.PharmacyOrder>(
    'pharmacy',
    'updateStatus',
    {
      'id': id,
      'status': status,
    },
  );

  /// Get order by ID.
  _i3.Future<_i16.PharmacyOrder?> getById(int id) =>
      caller.callServerEndpoint<_i16.PharmacyOrder?>(
        'pharmacy',
        'getById',
        {'id': id},
      );
}

/// Role-based access control read/write. Admin app manages the
/// permission matrix here.
/// {@category Endpoint}
class EndpointRbac extends _i2.EndpointRef {
  EndpointRbac(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rbac';

  /// List every RBAC permission entry (all roles).
  _i3.Future<List<_i17.RbacPermission>> listAll() =>
      caller.callServerEndpoint<List<_i17.RbacPermission>>(
        'rbac',
        'listAll',
        {},
      );

  /// List permissions scoped to one role.
  _i3.Future<List<_i17.RbacPermission>> listForRole(String roleId) =>
      caller.callServerEndpoint<List<_i17.RbacPermission>>(
        'rbac',
        'listForRole',
        {'roleId': roleId},
      );

  /// Upsert a permission. Matches on (roleId, resource, action) and
  /// updates `isAllowed` if found, otherwise inserts.
  _i3.Future<_i17.RbacPermission> setPermission(
    String roleId,
    String roleName,
    String resource,
    String action,
    bool isAllowed,
  ) => caller.callServerEndpoint<_i17.RbacPermission>(
    'rbac',
    'setPermission',
    {
      'roleId': roleId,
      'roleName': roleName,
      'resource': resource,
      'action': action,
      'isAllowed': isAllowed,
    },
  );

  /// Delete a permission entry.
  _i3.Future<bool> deletePermission(int id) => caller.callServerEndpoint<bool>(
    'rbac',
    'deletePermission',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointSchedule extends _i2.EndpointRef {
  EndpointSchedule(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'schedule';

  /// Create a new schedule slot.
  _i3.Future<_i18.ScheduleSlot> createSlot(_i18.ScheduleSlot slot) =>
      caller.callServerEndpoint<_i18.ScheduleSlot>(
        'schedule',
        'createSlot',
        {'slot': slot},
      );

  /// Update a schedule slot.
  _i3.Future<_i18.ScheduleSlot> updateSlot(_i18.ScheduleSlot slot) =>
      caller.callServerEndpoint<_i18.ScheduleSlot>(
        'schedule',
        'updateSlot',
        {'slot': slot},
      );

  /// Delete a schedule slot.
  _i3.Future<void> deleteSlot(int id) => caller.callServerEndpoint<void>(
    'schedule',
    'deleteSlot',
    {'id': id},
  );

  /// List schedule slots for a practitioner.
  _i3.Future<List<_i18.ScheduleSlot>> listSlots(String practitionerRef) =>
      caller.callServerEndpoint<List<_i18.ScheduleSlot>>(
        'schedule',
        'listSlots',
        {'practitionerRef': practitionerRef},
      );

  /// List available slots for a practitioner on a given date.
  _i3.Future<List<_i18.ScheduleSlot>> listAvailableSlots(
    String practitionerRef,
    DateTime date,
  ) => caller.callServerEndpoint<List<_i18.ScheduleSlot>>(
    'schedule',
    'listAvailableSlots',
    {
      'practitionerRef': practitionerRef,
      'date': date,
    },
  );

  /// Increment booked count for a slot.
  _i3.Future<_i18.ScheduleSlot> bookSlot(int slotId) =>
      caller.callServerEndpoint<_i18.ScheduleSlot>(
        'schedule',
        'bookSlot',
        {'slotId': slotId},
      );
}

/// Minimal in-memory WebRTC signaling relay.
///
/// Three message types are relayed between peers sharing a `roomId`:
///   - 'offer'       : SDP offer
///   - 'answer'      : SDP answer
///   - 'ice'         : ICE candidate
///
/// Clients `subscribe(roomId)` to receive a stream of messages, and call
/// `send(roomId, type, payload)` to broadcast. Peer identity is the session
/// id — no authn wired here; secure via Serverpod's auth before prod use.
///
/// NOTE(webrtc): this is a skeleton — for production we'd persist messages
/// to Postgres with TTL, enforce peer allow-lists, and add TURN credentials.
/// {@category Endpoint}
class EndpointWebrtcSignaling extends _i2.EndpointRef {
  EndpointWebrtcSignaling(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'webrtcSignaling';

  /// Stream of signaling messages for a room. Sends are broadcast to all
  /// other listeners in the same room (not back to the sender).
  _i3.Stream<Map<String, dynamic>> subscribe(String roomId) =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<Map<String, dynamic>>,
        Map<String, dynamic>
      >(
        'webrtcSignaling',
        'subscribe',
        {'roomId': roomId},
        {},
      );

  /// Broadcast a signaling message to peers in [roomId] (excluding sender).
  _i3.Future<void> send(
    String roomId,
    String type,
    String payload,
  ) => caller.callServerEndpoint<void>(
    'webrtcSignaling',
    'send',
    {
      'roomId': roomId,
      'type': type,
      'payload': payload,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i19.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i19.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i20.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    admin = EndpointAdmin(this);
    ambulance = EndpointAmbulance(this);
    appointment = EndpointAppointment(this);
    audit = EndpointAudit(this);
    auth = EndpointAuth(this);
    fhirResource = EndpointFhirResource(this);
    fhirSync = EndpointFhirSync(this);
    healthTip = EndpointHealthTip(this);
    insurance = EndpointInsurance(this);
    labBooking = EndpointLabBooking(this);
    notification = EndpointNotification(this);
    organization = EndpointOrganization(this);
    pharmacy = EndpointPharmacy(this);
    rbac = EndpointRbac(this);
    schedule = EndpointSchedule(this);
    webrtcSignaling = EndpointWebrtcSignaling(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdmin admin;

  late final EndpointAmbulance ambulance;

  late final EndpointAppointment appointment;

  late final EndpointAudit audit;

  late final EndpointAuth auth;

  late final EndpointFhirResource fhirResource;

  late final EndpointFhirSync fhirSync;

  late final EndpointHealthTip healthTip;

  late final EndpointInsurance insurance;

  late final EndpointLabBooking labBooking;

  late final EndpointNotification notification;

  late final EndpointOrganization organization;

  late final EndpointPharmacy pharmacy;

  late final EndpointRbac rbac;

  late final EndpointSchedule schedule;

  late final EndpointWebrtcSignaling webrtcSignaling;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'admin': admin,
    'ambulance': ambulance,
    'appointment': appointment,
    'audit': audit,
    'auth': auth,
    'fhirResource': fhirResource,
    'fhirSync': fhirSync,
    'healthTip': healthTip,
    'insurance': insurance,
    'labBooking': labBooking,
    'notification': notification,
    'organization': organization,
    'pharmacy': pharmacy,
    'rbac': rbac,
    'schedule': schedule,
    'webrtcSignaling': webrtcSignaling,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
