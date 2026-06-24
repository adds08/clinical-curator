-- FHIR Resource Store: JSONB-based storage for all FHIR R4 resources
-- This replaces the 27 flat Hive collection classes

CREATE TABLE fhir_resource (
  id              SERIAL PRIMARY KEY,
  fhir_id         UUID NOT NULL DEFAULT gen_random_uuid(),
  resource_type   VARCHAR(64) NOT NULL,
  resource_json   JSONB NOT NULL,
  search_params   JSONB NOT NULL DEFAULT '{}'::JSONB,
  version_id      INTEGER NOT NULL DEFAULT 1,
  last_updated    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_deleted      BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(fhir_id, resource_type)
);

-- GIN index for FHIR search parameters (fast JSONB path queries)
CREATE INDEX idx_fhir_search ON fhir_resource USING GIN (search_params jsonb_path_ops);

-- Lookup by type + last_updated (for _since sync)
CREATE INDEX idx_fhir_type_updated ON fhir_resource (resource_type, last_updated);

-- Lookup by type + fhir_id (for direct reads)
CREATE INDEX idx_fhir_type_fhir_id ON fhir_resource (resource_type, fhir_id);

-- Full-text search on resource JSON
CREATE INDEX idx_fhir_json_gin ON fhir_resource USING GIN (resource_json);

-- Version history for every FHIR resource change
CREATE TABLE fhir_resource_history (
  id              SERIAL PRIMARY KEY,
  fhir_id         UUID NOT NULL,
  resource_type   VARCHAR(64) NOT NULL,
  resource_json   JSONB NOT NULL,
  version_id      INTEGER NOT NULL,
  recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fhir_history_lookup ON fhir_resource_history (fhir_id, resource_type, version_id);

-- Audit log for fast querying (HIPAA-compliant)
CREATE TABLE fhir_audit_log (
  id                SERIAL PRIMARY KEY,
  action            CHAR(1) NOT NULL,
  resource_type     VARCHAR(64) NOT NULL,
  resource_fhir_id  UUID NOT NULL,
  user_id           VARCHAR(256) NOT NULL,
  patient_fhir_id   UUID,
  outcome           CHAR(1) NOT NULL,
  detail            JSONB DEFAULT '{}'::JSONB,
  recorded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_user ON fhir_audit_log (user_id, recorded_at DESC);
CREATE INDEX idx_audit_type ON fhir_audit_log (resource_type, recorded_at DESC);
CREATE INDEX idx_audit_action ON fhir_audit_log (action, recorded_at DESC);
CREATE INDEX idx_audit_recorded ON fhir_audit_log (recorded_at DESC);