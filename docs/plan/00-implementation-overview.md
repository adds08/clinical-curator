# Clinical Curator — Implementation Overview

**Updated:** 2026-06-24
**Supersedes:** Legacy docs 01-11 (deprecated)

## Architecture

A FHIR R4-native EMR + patient portal for Nepal. Offline-first patient app, online primary clinician app, shared FHIR REST API backend.

```
Patient App (Flutter)
  ├── Hive cache (offline-first)
  ├── FhirSyncService (delta sync via _since)
  └── PIN/JWT auth (works offline)

Clinician App (Flutter)
  ├── Patient chart with 9 tabs
  ├── SOAP note editor, order entry, CDS
  └── Direct API calls (online primary)

Admin Console (Flutter)
  ├── Practitioner verification
  ├── Organization/RBAC management
  └── Direct API calls (online only)

FHIR REST API (Serverpod 3.4.10)
  ├── JSONB + GIN indexed PostgreSQL
  ├── _search, _history, Bundle, metadata
  └── SMART on FHIR OAuth2, Bulk Export

Shared Server
  ├── One PostgreSQL serves all orgs
  ├── Multi-tenant via Organization scoping
  └── AuditEvent + Provenance for every action
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.11+ / shadcn_flutter |
| State | flutter_riverpod 3.x |
| Routing | go_router 17.x |
| Local cache | Hive CE (1 class, manual adapter) |
| Backend | Serverpod 3.4.10 |
| Server DB | PostgreSQL 16 + JSONB + GIN |
| FHIR | fhir ^0.12.1 |
| Maps | flutter_map 7.x |
| Tables | ultimate_grid |
| Chat | Guff Messenger (plugin) |

## Implementation Phases

| # | Phase | Weeks | Deliverable |
|---|-------|-------|-------------|
| 1 | FHIR Foundation | 1-3 | JSONB schema + `FhirStoreService` + FHIR REST API |
| 2 | Sync + Cache | 4-5 | Single `FhirCacheEntry` + `FhirSyncService` |
| 3 | Patient Chart | 6-9 | 9-tab chart, SOAP notes, order entry, CDS |
| 4 | Patient Portal | 10-12 | My Health Record, booking, refills, self-vitals |
| 5 | Medical Services | 13-15 | Lab workflow, pharmacy, referrals, immunizations, ambulance |
| 6 | Interop + Security | 16-18 | SMART OAuth2, bulk export, audit trail, validation |
| 7 | UI Modernization | 19-20 | ultimate_grid tables, dashboards, responsive |
| 8 | Guff Integration | 21-22 | Chat replacement with Guff Messenger |

## Plan Docs

| Doc | Status |
|-----|--------|
| 00-overview | ✅ This file |
| 01-11 | 🔴 Deprecated |
| 12-fhir-storage-layer | 📄 Ready |
| 13-emr-patient-chart | 📄 Ready |
| 14-patient-portal | 📄 Ready |
| 15-fhir-interoperability | 📄 Ready |
| 16-ui-modernization | 📄 Ready |
| 17-backend-hardening | 📄 Ready |
| 18-nepal-complete-system | 📄 Master reference |
| 19-guff-messaging-integration | 📄 Ready |
| 20-local-development | 📄 Ready |
| 21-sync-auth-safety | 📄 Ready |