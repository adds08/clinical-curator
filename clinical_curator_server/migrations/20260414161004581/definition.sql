BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AllergyIntolerance as table allergy_intolerances
--
CREATE TABLE "allergy_intolerances" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "code" text NOT NULL,
    "displayName" text NOT NULL,
    "clinicalStatus" text NOT NULL,
    "verificationStatus" text NOT NULL,
    "type" text NOT NULL,
    "category" text NOT NULL,
    "criticality" text NOT NULL,
    "onsetDate" timestamp without time zone,
    "reactionJson" text,
    "recorderRef" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "allergy_patient_idx" ON "allergy_intolerances" USING btree ("patientRef");
CREATE INDEX "allergy_status_idx" ON "allergy_intolerances" USING btree ("clinicalStatus");
CREATE INDEX "allergy_criticality_idx" ON "allergy_intolerances" USING btree ("criticality");

--
-- Class AmbulanceRequest as table ambulance_requests
--
CREATE TABLE "ambulance_requests" (
    "id" bigserial PRIMARY KEY,
    "patientRef" text NOT NULL,
    "patientName" text NOT NULL,
    "contactNumber" text NOT NULL,
    "emergencyType" text NOT NULL,
    "pickupLocation" text NOT NULL,
    "status" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "assignedDriverName" text,
    "assignedVehicleNumber" text,
    "estimatedArrivalMinutes" bigint,
    "notes" text,
    "cancellationReason" text,
    "timelinessRating" text,
    "helpfulnessRating" bigint,
    "feedbackNotes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "ambulance_patient_idx" ON "ambulance_requests" USING btree ("patientRef");
CREATE INDEX "ambulance_status_idx" ON "ambulance_requests" USING btree ("status");
CREATE INDEX "ambulance_created_idx" ON "ambulance_requests" USING btree ("createdAt");

--
-- Class Appointment as table appointments
--
CREATE TABLE "appointments" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "practitionerRef" text NOT NULL,
    "practitionerName" text NOT NULL,
    "patientName" text NOT NULL,
    "appointmentType" text NOT NULL,
    "status" text NOT NULL,
    "scheduledAt" timestamp without time zone NOT NULL,
    "durationMinutes" bigint NOT NULL,
    "specialty" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "appointment_patient_idx" ON "appointments" USING btree ("patientRef");
CREATE INDEX "appointment_practitioner_idx" ON "appointments" USING btree ("practitionerRef");
CREATE INDEX "appointment_scheduled_idx" ON "appointments" USING btree ("scheduledAt");
CREATE INDEX "appointment_status_idx" ON "appointments" USING btree ("status");

--
-- Class AuditEvent as table audit_events
--
CREATE TABLE "audit_events" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "type" text NOT NULL,
    "action" text NOT NULL,
    "recorded" timestamp without time zone NOT NULL,
    "agentRef" text NOT NULL,
    "agentName" text NOT NULL,
    "entityRef" text,
    "entityType" text,
    "outcome" text NOT NULL,
    "detail" text,
    "createdAt" timestamp without time zone NOT NULL,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "audit_event_type_idx" ON "audit_events" USING btree ("type");
CREATE INDEX "audit_event_action_idx" ON "audit_events" USING btree ("action");
CREATE INDEX "audit_event_agent_idx" ON "audit_events" USING btree ("agentRef");
CREATE INDEX "audit_event_recorded_idx" ON "audit_events" USING btree ("recorded");
CREATE INDEX "audit_event_entity_idx" ON "audit_events" USING btree ("entityRef");

--
-- Class CarePlan as table care_plans
--
CREATE TABLE "care_plans" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "status" text NOT NULL,
    "intent" text NOT NULL,
    "title" text NOT NULL,
    "category" text,
    "periodStart" timestamp without time zone,
    "periodEnd" timestamp without time zone,
    "activitiesJson" text,
    "goalsJson" text,
    "authorRef" text,
    "encounterRef" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "care_plan_patient_idx" ON "care_plans" USING btree ("patientRef");
CREATE INDEX "care_plan_status_idx" ON "care_plans" USING btree ("status");

--
-- Class Condition as table conditions
--
CREATE TABLE "conditions" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "code" text NOT NULL,
    "displayName" text NOT NULL,
    "clinicalStatus" text NOT NULL,
    "verificationStatus" text NOT NULL,
    "onsetDate" timestamp without time zone,
    "abatementDate" timestamp without time zone,
    "recordedDate" timestamp without time zone NOT NULL,
    "severity" text,
    "bodySite" text,
    "encounterRef" text,
    "recorderRef" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "condition_patient_idx" ON "conditions" USING btree ("patientRef");
CREATE INDEX "condition_status_idx" ON "conditions" USING btree ("clinicalStatus");
CREATE INDEX "condition_code_idx" ON "conditions" USING btree ("code");
CREATE INDEX "condition_encounter_idx" ON "conditions" USING btree ("encounterRef");

--
-- Class Encounter as table encounters
--
CREATE TABLE "encounters" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "practitionerRef" text NOT NULL,
    "status" text NOT NULL,
    "classCode" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "organizationRef" text,
    "reasonJson" text,
    "serviceType" text,
    "notes" text,
    "patientName" text,
    "practitionerName" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "encounter_patient_idx" ON "encounters" USING btree ("patientRef");
CREATE INDEX "encounter_practitioner_idx" ON "encounters" USING btree ("practitionerRef");
CREATE INDEX "encounter_status_idx" ON "encounters" USING btree ("status");
CREATE INDEX "encounter_start_idx" ON "encounters" USING btree ("startDate");
CREATE INDEX "encounter_org_idx" ON "encounters" USING btree ("organizationRef");

--
-- Class FhirResourceRecord as table fhir_resources
--
CREATE TABLE "fhir_resources" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text NOT NULL,
    "resourceType" text NOT NULL,
    "jsonData" text NOT NULL,
    "patientReference" text,
    "practitionerReference" text,
    "category" text,
    "syncVersion" bigint NOT NULL,
    "lastUpdated" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "fhir_resource_fhir_id_type_idx" ON "fhir_resources" USING btree ("fhirId", "resourceType");
CREATE INDEX "fhir_resource_type_idx" ON "fhir_resources" USING btree ("resourceType");
CREATE INDEX "fhir_resource_patient_idx" ON "fhir_resources" USING btree ("patientReference");
CREATE INDEX "fhir_resource_practitioner_idx" ON "fhir_resources" USING btree ("practitionerReference");
CREATE INDEX "fhir_resource_category_idx" ON "fhir_resources" USING btree ("category");
CREATE INDEX "fhir_resource_updated_idx" ON "fhir_resources" USING btree ("lastUpdated");

--
-- Class HealthTip as table health_tips
--
CREATE TABLE "health_tips" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "summary" text NOT NULL,
    "content" text NOT NULL,
    "category" text NOT NULL,
    "imageUrl" text,
    "author" text NOT NULL,
    "isActive" boolean NOT NULL,
    "publishedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "health_tip_category_idx" ON "health_tips" USING btree ("category");
CREATE INDEX "health_tip_active_idx" ON "health_tips" USING btree ("isActive");
CREATE INDEX "health_tip_published_idx" ON "health_tips" USING btree ("publishedAt");

--
-- Class HealthcareService as table healthcare_services
--
CREATE TABLE "healthcare_services" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "organizationRef" text NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "specialty" text,
    "availableTimeJson" text,
    "locationRef" text,
    "active" boolean NOT NULL,
    "comment" text,
    "telecom" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "healthcare_service_org_idx" ON "healthcare_services" USING btree ("organizationRef");
CREATE INDEX "healthcare_service_type_idx" ON "healthcare_services" USING btree ("type");
CREATE INDEX "healthcare_service_active_idx" ON "healthcare_services" USING btree ("active");

--
-- Class Immunization as table immunizations
--
CREATE TABLE "immunizations" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "vaccineCode" text NOT NULL,
    "vaccineName" text NOT NULL,
    "occurrenceDate" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "lotNumber" text,
    "site" text,
    "routeOfAdmin" text,
    "doseQuantity" text,
    "performerRef" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "immunization_patient_idx" ON "immunizations" USING btree ("patientRef");
CREATE INDEX "immunization_vaccine_idx" ON "immunizations" USING btree ("vaccineCode");
CREATE INDEX "immunization_date_idx" ON "immunizations" USING btree ("occurrenceDate");

--
-- Class InsuranceClaim as table insurance_claims
--
CREATE TABLE "insurance_claims" (
    "id" bigserial PRIMARY KEY,
    "patientRef" text NOT NULL,
    "claimType" text NOT NULL,
    "provider" text NOT NULL,
    "policyNumber" text NOT NULL,
    "amount" double precision NOT NULL,
    "status" text NOT NULL,
    "description" text,
    "documentsJson" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "insurance_claim_patient_idx" ON "insurance_claims" USING btree ("patientRef");
CREATE INDEX "insurance_claim_status_idx" ON "insurance_claims" USING btree ("status");

--
-- Class LabBooking as table lab_bookings
--
CREATE TABLE "lab_bookings" (
    "id" bigserial PRIMARY KEY,
    "patientRef" text NOT NULL,
    "testsJson" text NOT NULL,
    "status" text NOT NULL,
    "totalPrice" double precision NOT NULL,
    "scheduledAt" timestamp without time zone,
    "labName" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "lab_booking_patient_idx" ON "lab_bookings" USING btree ("patientRef");
CREATE INDEX "lab_booking_status_idx" ON "lab_bookings" USING btree ("status");

--
-- Class Location as table locations
--
CREATE TABLE "locations" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "description" text,
    "address" text,
    "latitude" double precision,
    "longitude" double precision,
    "organizationRef" text,
    "partOfRef" text,
    "status" text NOT NULL,
    "physicalType" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "location_org_idx" ON "locations" USING btree ("organizationRef");
CREATE INDEX "location_type_idx" ON "locations" USING btree ("type");
CREATE INDEX "location_status_idx" ON "locations" USING btree ("status");

--
-- Class MedicationRequest as table medication_requests
--
CREATE TABLE "medication_requests" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "requesterRef" text NOT NULL,
    "requesterName" text,
    "medicationCode" text NOT NULL,
    "medicationName" text NOT NULL,
    "status" text NOT NULL,
    "dosageJson" text,
    "dispenseJson" text,
    "encounterRef" text,
    "reasonJson" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "med_request_patient_idx" ON "medication_requests" USING btree ("patientRef");
CREATE INDEX "med_request_requester_idx" ON "medication_requests" USING btree ("requesterRef");
CREATE INDEX "med_request_status_idx" ON "medication_requests" USING btree ("status");

--
-- Class NotificationRecord as table notification_records
--
CREATE TABLE "notification_records" (
    "id" bigserial PRIMARY KEY,
    "userEmail" text NOT NULL,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "type" text NOT NULL,
    "isRead" boolean NOT NULL,
    "relatedResourceId" text,
    "relatedRoute" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "notification_user_idx" ON "notification_records" USING btree ("userEmail");
CREATE INDEX "notification_read_idx" ON "notification_records" USING btree ("userEmail", "isRead");
CREATE INDEX "notification_created_idx" ON "notification_records" USING btree ("createdAt");

--
-- Class Organization as table organizations
--
CREATE TABLE "organizations" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "address" text NOT NULL,
    "phone" text,
    "latitude" double precision,
    "longitude" double precision,
    "openHours" text,
    "rating" double precision,
    "hasEmergency" boolean NOT NULL,
    "isOpen24Hours" boolean NOT NULL,
    "departmentsJson" text,
    "servicesJson" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "organization_type_idx" ON "organizations" USING btree ("type");
CREATE INDEX "organization_name_idx" ON "organizations" USING btree ("name");

--
-- Class Payment as table payments
--
CREATE TABLE "payments" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "amount" double precision NOT NULL,
    "currency" text NOT NULL,
    "status" text NOT NULL,
    "method" text NOT NULL,
    "gateway" text,
    "transactionId" text,
    "appointmentRef" text,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "payment_patient_idx" ON "payments" USING btree ("patientRef");
CREATE INDEX "payment_status_idx" ON "payments" USING btree ("status");
CREATE INDEX "payment_transaction_idx" ON "payments" USING btree ("transactionId");

--
-- Class PharmacyOrder as table pharmacy_orders
--
CREATE TABLE "pharmacy_orders" (
    "id" bigserial PRIMARY KEY,
    "patientRef" text NOT NULL,
    "pharmacyName" text NOT NULL,
    "itemsJson" text NOT NULL,
    "status" text NOT NULL,
    "totalPrice" double precision NOT NULL,
    "deliveryAddress" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "pharmacy_order_patient_idx" ON "pharmacy_orders" USING btree ("patientRef");
CREATE INDEX "pharmacy_order_status_idx" ON "pharmacy_orders" USING btree ("status");

--
-- Class PractitionerRole as table practitioner_roles
--
CREATE TABLE "practitioner_roles" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "practitionerRef" text NOT NULL,
    "organizationRef" text NOT NULL,
    "code" text NOT NULL,
    "specialty" text,
    "locationRefsJson" text,
    "availableTimeJson" text,
    "active" boolean NOT NULL,
    "practitionerName" text,
    "organizationName" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "pract_role_practitioner_idx" ON "practitioner_roles" USING btree ("practitionerRef");
CREATE INDEX "pract_role_org_idx" ON "practitioner_roles" USING btree ("organizationRef");
CREATE INDEX "pract_role_specialty_idx" ON "practitioner_roles" USING btree ("specialty");
CREATE INDEX "pract_role_active_idx" ON "practitioner_roles" USING btree ("active");

--
-- Class Procedure as table procedures
--
CREATE TABLE "procedures" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "encounterRef" text,
    "code" text NOT NULL,
    "displayName" text NOT NULL,
    "status" text NOT NULL,
    "performedDate" timestamp without time zone,
    "performerRef" text,
    "performerName" text,
    "bodySite" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "procedure_patient_idx" ON "procedures" USING btree ("patientRef");
CREATE INDEX "procedure_encounter_idx" ON "procedures" USING btree ("encounterRef");
CREATE INDEX "procedure_status_idx" ON "procedures" USING btree ("status");

--
-- Class RbacPermission as table rbac_permissions
--
CREATE TABLE "rbac_permissions" (
    "id" bigserial PRIMARY KEY,
    "roleId" text NOT NULL,
    "roleName" text NOT NULL,
    "resource" text NOT NULL,
    "action" text NOT NULL,
    "isAllowed" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "rbac_role_idx" ON "rbac_permissions" USING btree ("roleId");
CREATE INDEX "rbac_resource_idx" ON "rbac_permissions" USING btree ("resource");
CREATE INDEX "rbac_role_resource_idx" ON "rbac_permissions" USING btree ("roleId", "resource");

--
-- Class ScheduleSlot as table schedule_slots
--
CREATE TABLE "schedule_slots" (
    "id" bigserial PRIMARY KEY,
    "practitionerRef" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    "slotDurationMinutes" bigint NOT NULL,
    "maxPatients" bigint NOT NULL,
    "bookedCount" bigint NOT NULL,
    "facilityName" text,
    "isEmergencyOverride" boolean NOT NULL,
    "isTelehealth" boolean NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "sched_slot_practitioner_idx" ON "schedule_slots" USING btree ("practitionerRef");
CREATE INDEX "sched_slot_date_idx" ON "schedule_slots" USING btree ("date");
CREATE INDEX "sched_slot_status_idx" ON "schedule_slots" USING btree ("status");

--
-- Class ServiceRequest as table service_requests
--
CREATE TABLE "service_requests" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "patientRef" text NOT NULL,
    "requesterRef" text NOT NULL,
    "requesterName" text,
    "code" text NOT NULL,
    "displayName" text NOT NULL,
    "status" text NOT NULL,
    "intent" text NOT NULL,
    "priority" text NOT NULL,
    "category" text,
    "encounterRef" text,
    "occurrenceDate" timestamp without time zone,
    "performerRef" text,
    "reasonJson" text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "service_request_patient_idx" ON "service_requests" USING btree ("patientRef");
CREATE INDEX "service_request_requester_idx" ON "service_requests" USING btree ("requesterRef");
CREATE INDEX "service_request_status_idx" ON "service_requests" USING btree ("status");
CREATE INDEX "service_request_category_idx" ON "service_requests" USING btree ("category");

--
-- Class Slot as table slots
--
CREATE TABLE "slots" (
    "id" bigserial PRIMARY KEY,
    "fhirId" text,
    "scheduleRef" text NOT NULL,
    "status" text NOT NULL,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "serviceType" text,
    "practitionerRef" text,
    "organizationRef" text,
    "maxPatients" bigint,
    "bookedCount" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone,
    "syncVersion" bigint NOT NULL
);

-- Indexes
CREATE INDEX "slot_schedule_idx" ON "slots" USING btree ("scheduleRef");
CREATE INDEX "slot_practitioner_idx" ON "slots" USING btree ("practitionerRef");
CREATE INDEX "slot_status_idx" ON "slots" USING btree ("status");
CREATE INDEX "slot_start_idx" ON "slots" USING btree ("startTime");

--
-- Class UserAccount as table user_accounts
--
CREATE TABLE "user_accounts" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "displayName" text NOT NULL,
    "fhirPatientId" text,
    "fhirPractitionerId" text,
    "isPractitioner" boolean NOT NULL,
    "isVerified" boolean NOT NULL,
    "practitionerType" text,
    "accountType" text NOT NULL,
    "avatarUrl" text,
    "healthId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_account_email_idx" ON "user_accounts" USING btree ("email");
CREATE INDEX "user_account_type_idx" ON "user_accounts" USING btree ("accountType");
CREATE INDEX "user_account_practitioner_idx" ON "user_accounts" USING btree ("isPractitioner", "isVerified");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR clinical_curator
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('clinical_curator', '20260414161004581', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260414161004581', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
