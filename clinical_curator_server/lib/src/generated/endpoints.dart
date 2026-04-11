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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/admin_endpoint.dart' as _i4;
import '../endpoints/ambulance_endpoint.dart' as _i5;
import '../endpoints/appointment_endpoint.dart' as _i6;
import '../endpoints/auth_endpoint.dart' as _i7;
import '../endpoints/fhir_resource_endpoint.dart' as _i8;
import '../endpoints/health_tip_endpoint.dart' as _i9;
import '../endpoints/insurance_endpoint.dart' as _i10;
import '../endpoints/lab_booking_endpoint.dart' as _i11;
import '../endpoints/notification_endpoint.dart' as _i12;
import '../endpoints/organization_endpoint.dart' as _i13;
import '../endpoints/pharmacy_endpoint.dart' as _i14;
import '../endpoints/schedule_endpoint.dart' as _i15;
import '../greetings/greeting_endpoint.dart' as _i16;
import 'package:clinical_curator_server/src/generated/ambulance_request.dart'
    as _i17;
import 'package:clinical_curator_server/src/generated/appointment.dart' as _i18;
import 'package:clinical_curator_server/src/generated/user_account.dart'
    as _i19;
import 'package:clinical_curator_server/src/generated/fhir_resource.dart'
    as _i20;
import 'package:clinical_curator_server/src/generated/health_tip.dart' as _i21;
import 'package:clinical_curator_server/src/generated/insurance_claim.dart'
    as _i22;
import 'package:clinical_curator_server/src/generated/lab_booking.dart' as _i23;
import 'package:clinical_curator_server/src/generated/notification_record.dart'
    as _i24;
import 'package:clinical_curator_server/src/generated/organization.dart'
    as _i25;
import 'package:clinical_curator_server/src/generated/pharmacy_order.dart'
    as _i26;
import 'package:clinical_curator_server/src/generated/schedule_slot.dart'
    as _i27;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i28;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i29;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'admin': _i4.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'ambulance': _i5.AmbulanceEndpoint()
        ..initialize(
          server,
          'ambulance',
          null,
        ),
      'appointment': _i6.AppointmentEndpoint()
        ..initialize(
          server,
          'appointment',
          null,
        ),
      'auth': _i7.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'fhirResource': _i8.FhirResourceEndpoint()
        ..initialize(
          server,
          'fhirResource',
          null,
        ),
      'healthTip': _i9.HealthTipEndpoint()
        ..initialize(
          server,
          'healthTip',
          null,
        ),
      'insurance': _i10.InsuranceEndpoint()
        ..initialize(
          server,
          'insurance',
          null,
        ),
      'labBooking': _i11.LabBookingEndpoint()
        ..initialize(
          server,
          'labBooking',
          null,
        ),
      'notification': _i12.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'organization': _i13.OrganizationEndpoint()
        ..initialize(
          server,
          'organization',
          null,
        ),
      'pharmacy': _i14.PharmacyEndpoint()
        ..initialize(
          server,
          'pharmacy',
          null,
        ),
      'schedule': _i15.ScheduleEndpoint()
        ..initialize(
          server,
          'schedule',
          null,
        ),
      'greeting': _i16.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'listPendingVerifications': _i1.MethodConnector(
          name: 'listPendingVerifications',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .listPendingVerifications(session),
        ),
        'approvePractitioner': _i1.MethodConnector(
          name: 'approvePractitioner',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).approvePractitioner(
                    session,
                    params['id'],
                  ),
        ),
        'rejectPractitioner': _i1.MethodConnector(
          name: 'rejectPractitioner',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i4.AdminEndpoint).rejectPractitioner(
                    session,
                    params['id'],
                  ),
        ),
        'getDashboardStats': _i1.MethodConnector(
          name: 'getDashboardStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .getDashboardStats(session),
        ),
        'listVerifiedPractitioners': _i1.MethodConnector(
          name: 'listVerifiedPractitioners',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i4.AdminEndpoint)
                  .listVerifiedPractitioners(session),
        ),
      },
    );
    connectors['ambulance'] = _i1.EndpointConnector(
      name: 'ambulance',
      endpoint: endpoints['ambulance']!,
      methodConnectors: {
        'request': _i1.MethodConnector(
          name: 'request',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i17.AmbulanceRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ambulance'] as _i5.AmbulanceEndpoint).request(
                    session,
                    params['request'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'driverName': _i1.ParameterDescription(
              name: 'driverName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'vehicleNumber': _i1.ParameterDescription(
              name: 'vehicleNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'estimatedMinutes': _i1.ParameterDescription(
              name: 'estimatedMinutes',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ambulance'] as _i5.AmbulanceEndpoint)
                  .updateStatus(
                    session,
                    params['id'],
                    params['status'],
                    driverName: params['driverName'],
                    vehicleNumber: params['vehicleNumber'],
                    estimatedMinutes: params['estimatedMinutes'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                  ),
        ),
        'cancelWithReason': _i1.MethodConnector(
          name: 'cancelWithReason',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ambulance'] as _i5.AmbulanceEndpoint)
                  .cancelWithReason(
                    session,
                    params['id'],
                    params['reason'],
                  ),
        ),
        'completeWithRating': _i1.MethodConnector(
          name: 'completeWithRating',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'timelinessRating': _i1.ParameterDescription(
              name: 'timelinessRating',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'helpfulnessRating': _i1.ParameterDescription(
              name: 'helpfulnessRating',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'feedbackNotes': _i1.ParameterDescription(
              name: 'feedbackNotes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ambulance'] as _i5.AmbulanceEndpoint)
                  .completeWithRating(
                    session,
                    params['id'],
                    params['timelinessRating'],
                    params['helpfulnessRating'],
                    feedbackNotes: params['feedbackNotes'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ambulance'] as _i5.AmbulanceEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
        'listForPatient': _i1.MethodConnector(
          name: 'listForPatient',
          params: {
            'patientRef': _i1.ParameterDescription(
              name: 'patientRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ambulance'] as _i5.AmbulanceEndpoint)
                  .listForPatient(
                    session,
                    params['patientRef'],
                  ),
        ),
        'listActive': _i1.MethodConnector(
          name: 'listActive',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ambulance'] as _i5.AmbulanceEndpoint)
                  .listActive(session),
        ),
      },
    );
    connectors['appointment'] = _i1.EndpointConnector(
      name: 'appointment',
      endpoint: endpoints['appointment']!,
      methodConnectors: {
        'book': _i1.MethodConnector(
          name: 'book',
          params: {
            'appointment': _i1.ParameterDescription(
              name: 'appointment',
              type: _i1.getType<_i18.Appointment>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appointment'] as _i6.AppointmentEndpoint).book(
                    session,
                    params['appointment'],
                  ),
        ),
        'cancel': _i1.MethodConnector(
          name: 'cancel',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appointment'] as _i6.AppointmentEndpoint).cancel(
                    session,
                    params['id'],
                  ),
        ),
        'complete': _i1.MethodConnector(
          name: 'complete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appointment'] as _i6.AppointmentEndpoint)
                  .complete(
                    session,
                    params['id'],
                  ),
        ),
        'listForPatient': _i1.MethodConnector(
          name: 'listForPatient',
          params: {
            'patientRef': _i1.ParameterDescription(
              name: 'patientRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appointment'] as _i6.AppointmentEndpoint)
                  .listForPatient(
                    session,
                    params['patientRef'],
                  ),
        ),
        'listForPractitioner': _i1.MethodConnector(
          name: 'listForPractitioner',
          params: {
            'practitionerRef': _i1.ParameterDescription(
              name: 'practitionerRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appointment'] as _i6.AppointmentEndpoint)
                  .listForPractitioner(
                    session,
                    params['practitionerRef'],
                  ),
        ),
        'listTodayForPractitioner': _i1.MethodConnector(
          name: 'listTodayForPractitioner',
          params: {
            'practitionerRef': _i1.ParameterDescription(
              name: 'practitionerRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appointment'] as _i6.AppointmentEndpoint)
                  .listTodayForPractitioner(
                    session,
                    params['practitionerRef'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appointment'] as _i6.AppointmentEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i7.AuthEndpoint).login(
                session,
                params['email'],
                params['password'],
              ),
        ),
        'signup': _i1.MethodConnector(
          name: 'signup',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'displayName': _i1.ParameterDescription(
              name: 'displayName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i7.AuthEndpoint).signup(
                session,
                params['email'],
                params['password'],
                params['displayName'],
              ),
        ),
        'registerPractitioner': _i1.MethodConnector(
          name: 'registerPractitioner',
          params: {
            'userAccountId': _i1.ParameterDescription(
              name: 'userAccountId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'practitionerType': _i1.ParameterDescription(
              name: 'practitionerType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'licenseNumber': _i1.ParameterDescription(
              name: 'licenseNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'specialization': _i1.ParameterDescription(
              name: 'specialization',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i7.AuthEndpoint).registerPractitioner(
                    session,
                    params['userAccountId'],
                    params['practitionerType'],
                    params['licenseNumber'],
                    params['specialization'],
                  ),
        ),
        'getByEmail': _i1.MethodConnector(
          name: 'getByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i7.AuthEndpoint).getByEmail(
                session,
                params['email'],
              ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i7.AuthEndpoint).getById(
                session,
                params['id'],
              ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'account': _i1.ParameterDescription(
              name: 'account',
              type: _i1.getType<_i19.UserAccount>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i7.AuthEndpoint).updateProfile(
                session,
                params['account'],
              ),
        ),
      },
    );
    connectors['fhirResource'] = _i1.EndpointConnector(
      name: 'fhirResource',
      endpoint: endpoints['fhirResource']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'resource': _i1.ParameterDescription(
              name: 'resource',
              type: _i1.getType<_i20.FhirResourceRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .create(
                    session,
                    params['resource'],
                  ),
        ),
        'read': _i1.MethodConnector(
          name: 'read',
          params: {
            'fhirId': _i1.ParameterDescription(
              name: 'fhirId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'resourceType': _i1.ParameterDescription(
              name: 'resourceType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['fhirResource'] as _i8.FhirResourceEndpoint).read(
                    session,
                    params['fhirId'],
                    params['resourceType'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'resource': _i1.ParameterDescription(
              name: 'resource',
              type: _i1.getType<_i20.FhirResourceRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .update(
                    session,
                    params['resource'],
                  ),
        ),
        'deleteById': _i1.MethodConnector(
          name: 'deleteById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .deleteById(
                    session,
                    params['id'],
                  ),
        ),
        'searchByType': _i1.MethodConnector(
          name: 'searchByType',
          params: {
            'resourceType': _i1.ParameterDescription(
              name: 'resourceType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .searchByType(
                    session,
                    params['resourceType'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'searchByPatient': _i1.MethodConnector(
          name: 'searchByPatient',
          params: {
            'patientReference': _i1.ParameterDescription(
              name: 'patientReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'resourceType': _i1.ParameterDescription(
              name: 'resourceType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .searchByPatient(
                    session,
                    params['patientReference'],
                    resourceType: params['resourceType'],
                    limit: params['limit'],
                  ),
        ),
        'searchByPractitioner': _i1.MethodConnector(
          name: 'searchByPractitioner',
          params: {
            'practitionerReference': _i1.ParameterDescription(
              name: 'practitionerReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'resourceType': _i1.ParameterDescription(
              name: 'resourceType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .searchByPractitioner(
                    session,
                    params['practitionerReference'],
                    resourceType: params['resourceType'],
                    limit: params['limit'],
                  ),
        ),
        'getChangesSince': _i1.MethodConnector(
          name: 'getChangesSince',
          params: {
            'since': _i1.ParameterDescription(
              name: 'since',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fhirResource'] as _i8.FhirResourceEndpoint)
                  .getChangesSince(
                    session,
                    params['since'],
                  ),
        ),
      },
    );
    connectors['healthTip'] = _i1.EndpointConnector(
      name: 'healthTip',
      endpoint: endpoints['healthTip']!,
      methodConnectors: {
        'listAll': _i1.MethodConnector(
          name: 'listAll',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['healthTip'] as _i9.HealthTipEndpoint).listAll(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'listByCategory': _i1.MethodConnector(
          name: 'listByCategory',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['healthTip'] as _i9.HealthTipEndpoint)
                  .listByCategory(
                    session,
                    params['category'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['healthTip'] as _i9.HealthTipEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'tip': _i1.ParameterDescription(
              name: 'tip',
              type: _i1.getType<_i21.HealthTip>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['healthTip'] as _i9.HealthTipEndpoint).create(
                    session,
                    params['tip'],
                  ),
        ),
      },
    );
    connectors['insurance'] = _i1.EndpointConnector(
      name: 'insurance',
      endpoint: endpoints['insurance']!,
      methodConnectors: {
        'submitClaim': _i1.MethodConnector(
          name: 'submitClaim',
          params: {
            'claim': _i1.ParameterDescription(
              name: 'claim',
              type: _i1.getType<_i22.InsuranceClaim>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insurance'] as _i10.InsuranceEndpoint)
                  .submitClaim(
                    session,
                    params['claim'],
                  ),
        ),
        'listClaims': _i1.MethodConnector(
          name: 'listClaims',
          params: {
            'patientRef': _i1.ParameterDescription(
              name: 'patientRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insurance'] as _i10.InsuranceEndpoint).listClaims(
                    session,
                    params['patientRef'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['insurance'] as _i10.InsuranceEndpoint)
                  .updateStatus(
                    session,
                    params['id'],
                    params['status'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insurance'] as _i10.InsuranceEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['labBooking'] = _i1.EndpointConnector(
      name: 'labBooking',
      endpoint: endpoints['labBooking']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'booking': _i1.ParameterDescription(
              name: 'booking',
              type: _i1.getType<_i23.LabBooking>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['labBooking'] as _i11.LabBookingEndpoint).create(
                    session,
                    params['booking'],
                  ),
        ),
        'listForPatient': _i1.MethodConnector(
          name: 'listForPatient',
          params: {
            'patientRef': _i1.ParameterDescription(
              name: 'patientRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['labBooking'] as _i11.LabBookingEndpoint)
                  .listForPatient(
                    session,
                    params['patientRef'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['labBooking'] as _i11.LabBookingEndpoint)
                  .updateStatus(
                    session,
                    params['id'],
                    params['status'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['labBooking'] as _i11.LabBookingEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'notification': _i1.ParameterDescription(
              name: 'notification',
              type: _i1.getType<_i24.NotificationRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i12.NotificationEndpoint)
                      .create(
                        session,
                        params['notification'],
                      ),
        ),
        'listForUser': _i1.MethodConnector(
          name: 'listForUser',
          params: {
            'userEmail': _i1.ParameterDescription(
              name: 'userEmail',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i12.NotificationEndpoint)
                      .listForUser(
                        session,
                        params['userEmail'],
                      ),
        ),
        'markAsRead': _i1.MethodConnector(
          name: 'markAsRead',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i12.NotificationEndpoint)
                      .markAsRead(
                        session,
                        params['id'],
                      ),
        ),
        'markAllAsRead': _i1.MethodConnector(
          name: 'markAllAsRead',
          params: {
            'userEmail': _i1.ParameterDescription(
              name: 'userEmail',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i12.NotificationEndpoint)
                      .markAllAsRead(
                        session,
                        params['userEmail'],
                      ),
        ),
        'getUnreadCount': _i1.MethodConnector(
          name: 'getUnreadCount',
          params: {
            'userEmail': _i1.ParameterDescription(
              name: 'userEmail',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i12.NotificationEndpoint)
                      .getUnreadCount(
                        session,
                        params['userEmail'],
                      ),
        ),
      },
    );
    connectors['organization'] = _i1.EndpointConnector(
      name: 'organization',
      endpoint: endpoints['organization']!,
      methodConnectors: {
        'listHospitals': _i1.MethodConnector(
          name: 'listHospitals',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['organization'] as _i13.OrganizationEndpoint)
                      .listHospitals(session),
        ),
        'listPharmacies': _i1.MethodConnector(
          name: 'listPharmacies',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['organization'] as _i13.OrganizationEndpoint)
                      .listPharmacies(session),
        ),
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['organization'] as _i13.OrganizationEndpoint)
                      .search(
                        session,
                        params['query'],
                      ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['organization'] as _i13.OrganizationEndpoint)
                      .getById(
                        session,
                        params['id'],
                      ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'org': _i1.ParameterDescription(
              name: 'org',
              type: _i1.getType<_i25.Organization>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['organization'] as _i13.OrganizationEndpoint)
                      .create(
                        session,
                        params['org'],
                      ),
        ),
      },
    );
    connectors['pharmacy'] = _i1.EndpointConnector(
      name: 'pharmacy',
      endpoint: endpoints['pharmacy']!,
      methodConnectors: {
        'createOrder': _i1.MethodConnector(
          name: 'createOrder',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i26.PharmacyOrder>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pharmacy'] as _i14.PharmacyEndpoint).createOrder(
                    session,
                    params['order'],
                  ),
        ),
        'listOrders': _i1.MethodConnector(
          name: 'listOrders',
          params: {
            'patientRef': _i1.ParameterDescription(
              name: 'patientRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pharmacy'] as _i14.PharmacyEndpoint).listOrders(
                    session,
                    params['patientRef'],
                  ),
        ),
        'updateStatus': _i1.MethodConnector(
          name: 'updateStatus',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pharmacy'] as _i14.PharmacyEndpoint).updateStatus(
                    session,
                    params['id'],
                    params['status'],
                  ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['pharmacy'] as _i14.PharmacyEndpoint).getById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['schedule'] = _i1.EndpointConnector(
      name: 'schedule',
      endpoint: endpoints['schedule']!,
      methodConnectors: {
        'createSlot': _i1.MethodConnector(
          name: 'createSlot',
          params: {
            'slot': _i1.ParameterDescription(
              name: 'slot',
              type: _i1.getType<_i27.ScheduleSlot>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i15.ScheduleEndpoint).createSlot(
                    session,
                    params['slot'],
                  ),
        ),
        'updateSlot': _i1.MethodConnector(
          name: 'updateSlot',
          params: {
            'slot': _i1.ParameterDescription(
              name: 'slot',
              type: _i1.getType<_i27.ScheduleSlot>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i15.ScheduleEndpoint).updateSlot(
                    session,
                    params['slot'],
                  ),
        ),
        'deleteSlot': _i1.MethodConnector(
          name: 'deleteSlot',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i15.ScheduleEndpoint).deleteSlot(
                    session,
                    params['id'],
                  ),
        ),
        'listSlots': _i1.MethodConnector(
          name: 'listSlots',
          params: {
            'practitionerRef': _i1.ParameterDescription(
              name: 'practitionerRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i15.ScheduleEndpoint).listSlots(
                    session,
                    params['practitionerRef'],
                  ),
        ),
        'listAvailableSlots': _i1.MethodConnector(
          name: 'listAvailableSlots',
          params: {
            'practitionerRef': _i1.ParameterDescription(
              name: 'practitionerRef',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i15.ScheduleEndpoint)
                  .listAvailableSlots(
                    session,
                    params['practitionerRef'],
                    params['date'],
                  ),
        ),
        'bookSlot': _i1.MethodConnector(
          name: 'bookSlot',
          params: {
            'slotId': _i1.ParameterDescription(
              name: 'slotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i15.ScheduleEndpoint).bookSlot(
                    session,
                    params['slotId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i16.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i28.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i29.Endpoints()
      ..initializeEndpoints(server);
  }
}
