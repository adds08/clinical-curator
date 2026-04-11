# Feature 06 — Hospital Management

## Overview

Build comprehensive hospital/facility management including department views, staff assignment via FHIR PractitionerRole, physical locations within facilities, healthcare services, and bed/capacity tracking. This transforms the existing hospital list into a full facility management system.

## Dependencies

- Feature 03 (FHIR Resources) — needs Location, HealthcareService, PractitionerRole repositories
- Feature 05 (Admin Dashboard) — admin access for facility management

## What Already Exists

### Organization Data
- `lib/data/collections/organization_collection.dart` — `OrganizationLocal` (TypeId 9) with fields: name, type, address, latitude, longitude, phone, email, departments (JSON string), services (JSON string), bedCount, icuCount, emergencyCapacity, equipmentJson, operatingHours, accreditation, active, syncStatus
- `lib/domain/providers/organization_provider.dart` — `OrganizationNotifier` with CRUD, list, search

### Hospital Screens
- `lib/features/hospitals/screens/hospitals_screen.dart` — list view with map integration (`flutter_map`), search/filter, organization cards
- `lib/features/admin/screens/manage_organizations_screen.dart` — admin CRUD for organizations

### Server
- `clinical_curator_server/lib/src/endpoints/organization_endpoint.dart` — server CRUD for organizations
- `clinical_curator_server/lib/src/models/organization.spy.yaml` — server model

### Maps Dependencies
- `flutter_map: ^7.0.2` and `latlong2` in `pubspec.yaml`
- `geolocator` for device location

## What Needs to Be Built

### 1. Hospital Detail Screen — `lib/features/hospitals/screens/hospital_detail_screen.dart` (new)

Full hospital profile view:
- **Header:** Hospital name, type badge (government/private/community), accreditation status, logo
- **Location section:** Map showing precise location, address, distance from user
- **Contact section:** Phone, email, operating hours
- **Departments tab:** List of departments with head practitioner, bed count, current occupancy
- **Staff tab:** Practitioners assigned via PractitionerRole, grouped by specialty
- **Services tab:** Healthcare services offered with availability indicators
- **Capacity tab:** Real-time bed occupancy, ICU availability, ER status

### 2. Department Management

Extend `OrganizationLocal` or create a helper model:
- Parse `departments` JSON field into structured data
- Department detail view: name, head practitioner, specialty, bed count, equipment list
- Admin edit: add/remove departments, assign department head

### 3. Staff Roster Screen — `lib/features/hospitals/screens/staff_roster_screen.dart` (new)

- List practitioners assigned to this facility via `PractitionerRoleLocal`
- Group by specialty (Cardiology, Pediatrics, General Medicine, etc.)
- Each practitioner card: name, specialty, qualification, schedule availability
- Admin actions: assign practitioner to facility, update role, remove assignment
- Link to practitioner's schedule (Feature 08)

### 4. Location Management — `lib/features/hospitals/screens/location_management_screen.dart` (new)

Using `LocationLocal` (TypeId 17):
- Physical locations within a hospital: wings, floors, rooms, beds
- Location hierarchy tree view
- Status indicators (available, occupied, maintenance)
- Admin CRUD for locations

### 5. Healthcare Service Management — `lib/features/hospitals/screens/service_management_screen.dart` (new)

Using `HealthcareServiceLocal` (TypeId 18):
- Services offered by each organization
- Service details: name, type, specialty, availability schedule
- Service categories: Emergency, Outpatient, Inpatient, Laboratory, Radiology, Pharmacy
- Admin CRUD for services

### 6. Capacity Dashboard — `lib/features/hospitals/screens/capacity_dashboard_screen.dart` (new)

- **Overview cards:** Total beds / occupied / available, ICU beds, ER status
- **Department breakdown:** Occupancy per department (horizontal bar chart via `fl_chart`)
- **Trend chart:** Occupancy trend over last 7 days
- **Alerts:** Departments at >90% capacity highlighted
- Auto-refresh or pull-to-refresh

### 7. New Providers — `lib/domain/providers/`

| File | Key Providers |
|------|---------------|
| `hospital_detail_provider.dart` (new) | `hospitalDetailProvider(orgId)` — aggregated hospital data |
| `staff_roster_provider.dart` (new) | `staffByOrgProvider(orgRef)` — practitioners via PractitionerRole |
| `hospital_capacity_provider.dart` (new) | `capacityByOrgProvider(orgRef)` — bed/ICU/ER stats |

Reuse from Feature 03:
- `location_provider.dart` — `locationsByOrgProvider(orgRef)`
- `healthcare_service_provider.dart` — `servicesByOrgProvider(orgRef)`
- `practitioner_role_provider.dart` — `rolesByOrgProvider(orgRef)`

### 8. Mock Seed Extension

Add to `lib/data/mock/mock_seed.dart`:
- 3 hospitals with department data (Kathmandu Medical College, Patan Hospital, community health center)
- 5-8 locations per hospital (ER, ICU, General Ward, OPD, Lab, Radiology)
- 4-6 healthcare services per hospital
- PractitionerRole records linking demo doctors to hospitals

### 9. Navigation Updates

- From hospitals list → tap hospital → hospital detail screen
- From hospital detail → staff tab → staff roster
- From hospital detail → capacity tab → capacity dashboard
- Admin: manage locations, services within a facility

## Implementation Order

1. Ensure Feature 03 providers exist (Location, HealthcareService, PractitionerRole)
2. Create `hospital_detail_provider.dart`, `staff_roster_provider.dart`, `hospital_capacity_provider.dart`
3. Create `hospital_detail_screen.dart` with tabbed layout
4. Create `staff_roster_screen.dart`
5. Create `location_management_screen.dart` (admin)
6. Create `service_management_screen.dart` (admin)
7. Create `capacity_dashboard_screen.dart`
8. Extend mock seed with hospital data
9. Update router with new routes

## Acceptance Criteria

- [ ] Each hospital has a full profile with departments, staff, services, locations
- [ ] `PractitionerRole` correctly links practitioners to organizations with specialty
- [ ] Staff roster shows practitioners grouped by specialty
- [ ] Admin can manage hospital details, departments, staff assignments
- [ ] Capacity indicators show bed/ICU/ER availability (mock data)
- [ ] Map integration shows hospital location with distance from user
- [ ] Location hierarchy (wing → floor → room) displays correctly
- [ ] Healthcare services list with availability status
- [ ] Navigation flows smoothly: list → detail → sub-screens

## FHIR Compliance Notes

- **Organization** — hospital/facility profiles
- **Location** — physical locations within facilities (FHIR Location with partOf references for hierarchy)
- **HealthcareService** — services provided, linked to Organization and Location
- **PractitionerRole** — practitioner-to-organization assignments with specialty codes

## Mock Data Requirements

- 3 organizations with detailed department JSON
- 8+ LocationLocal records with hierarchy (e.g., Patan Hospital → ICU Wing → Room 101)
- 6+ HealthcareServiceLocal records (Emergency, Cardiology OPD, Lab Services, etc.)
- 4+ PractitionerRoleLocal records linking demo practitioners to organizations

## Complexity Estimate

**High** — multiple new screens with complex data relationships (Organization → Location → HealthcareService, PractitionerRole linking practitioners). Map integration and capacity charts add UI complexity. However, data layer is handled by Feature 03 repositories.
