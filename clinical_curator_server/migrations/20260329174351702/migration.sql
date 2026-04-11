BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
CREATE INDEX "slot_practitioner_idx" ON "schedule_slots" USING btree ("practitionerRef");
CREATE INDEX "slot_date_idx" ON "schedule_slots" USING btree ("date");
CREATE INDEX "slot_status_idx" ON "schedule_slots" USING btree ("status");

--
-- ACTION CREATE TABLE
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
-- MIGRATION VERSION FOR clinical_curator
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('clinical_curator', '20260329174351702', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260329174351702', "timestamp" = now();

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
