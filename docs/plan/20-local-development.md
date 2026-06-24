# Local Development Guide

## Prerequisites

```bash
dart --version       # SDK 3.11+
flutter --version    # 3.27+
melos --version      # 8.0+ (activated via: dart pub global activate melos)
docker compose version
```

## Quick Start

```bash
# 1. Start infrastructure
docker compose up -d              # PostgreSQL (port 8090) + Redis (port 8091)

# 2. Bootstrap workspace
cd clinical-curator
dart run melos bootstrap

# 3. Run database migrations
cd clinical_curator_server
dart run serverpod migrate       # Creates FHIR resource tables
dart run bin/seed.dart            # Seeds reference data

# 4. Start server
dart run bin/main.dart            # Serverpod on ports 8080-8082

# 5. Run Flutter apps (in separate terminals)
cd apps/clinical
flutter run                       # Patient + Clinician app

cd apps/admin
flutter run                       # Admin console

# 6. (Optional) Generate FHIR client SDK
cd clinical_curator_server
dart run serverpod generate       # Regenerates clinical_curator_client/
```

## Environment Variables

```env
# .env (repo root)
ENV=dev
SERVERPOD_URL=http://localhost:8080
SERVERPOD_HOST=localhost
SERVERPOD_PORT=8080
GOOGLE_CLIENT_ID=                    # Optional — for Drive backup
```

## Useful Commands

```bash
melos analyze       # Dart analysis across all packages
melos test          # Run unit + integration tests
melos format        # Format all Dart code
melos clean         # Clean build artifacts
docker compose logs # View Postgres/Redis logs
```

## Testing the FHIR API

```bash
# Create a patient
curl -X POST http://localhost:8080/fhir/Patient \
  -H 'Content-Type: application/fhir+json' \
  -d '{"resourceType":"Patient","name":[{"family":"Maharjan","given":["Arjun"]}],"gender":"male","birthDate":"1990-03-15"}'

# Search patients
curl 'http://localhost:8080/fhir/Patient?gender=male&_count=10'

# Read FHIR CapabilityStatement
curl http://localhost:8080/fhir/metadata
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `melos: command not found` | `dart pub global activate melos` |
| Server won't start | Check PostgreSQL is running: `docker compose ps` |
| Database error | Run `dart run serverpod database create` |
| App can't connect to server | Check `SERVERPOD_URL` in `.env` |
| Sync not working | Check `connectivity_plus` permissions on device |