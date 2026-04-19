BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION ALTER TABLE
--
DROP INDEX "slot_practitioner_idx";
DROP INDEX "slot_date_idx";
DROP INDEX "slot_status_idx";
CREATE INDEX "sched_slot_practitioner_idx" ON "schedule_slots" USING btree ("practitionerRef");
CREATE INDEX "sched_slot_date_idx" ON "schedule_slots" USING btree ("date");
CREATE INDEX "sched_slot_status_idx" ON "schedule_slots" USING btree ("status");
--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
