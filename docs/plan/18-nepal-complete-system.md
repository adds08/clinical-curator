# Clinical Curator — Nepal Complete System Design

**Document type:** Master architecture + implementation blueprint
**Status:** 🔴 Not started
**Last updated:** 2026-06-24
**Supersedes:** All plan docs 00-11 (legacy), 12-17 (detailed pseudocode)

---

## Table of Contents

1. [Nepal Healthcare Context](#1-nepal-healthcare-context)
2. [System Architecture](#2-system-architecture)
3. [Complete FHIR R4 Resource Catalog](#3-complete-fhir-r4-resource-catalog)
4. [Medical Workflows](#4-medical-workflows)
5. [Offline-First Design for Nepal](#5-offline-first-design-for-nepal)
6. [Nepal-Specific Features](#6-nepal-specific-features)
7. [Implementation Roadmap](#7-implementation-roadmap)
8. [Technical Specifications](#8-technical-specifications)

---

## 1. Nepal Healthcare Context

### 1.1 The Landscape

```text
Federal Level
└── Ministry of Health & Population (MoHP)
    ├── Department of Health Services (DoHS)
    ├── NMC (Nepal Medical Council) — practitioner registry
    ├── DDA (Department of Drug Administration) — drug registry
    └── NHSS (Nepal Health Sector Strategy) 2023-2033

Provincial Level (7 provinces)
├── Provincial Health Directorate
├── Provincial Hospitals (25+ bed)
└── Provincial Public Health Labs

Local Level (753 municipalities)
├── Primary Health Care Centers (PHCCs)
├── Health Posts (3-5 beds, basic care)
├── Community Health Units (CHUs)
└── Female Community Health Volunteers (FCHVs) — 50,000+ nationwide

Private Sector
├── Private Hospitals (Bir, Grande, Norvic, Mediciti, etc.)
├── Private Clinics/GP practices
├── Diagnostic Labs (Pathology, Radiology)
├── Pharmacies (licensed + unlicensed)
└── Nursing Homes
```

### 1.2 Key Challenges This System Addresses

| Challenge | System Response |
|-----------|----------------|
| **Internet connectivity** — 60% rural, 2G/EDGE common, frequent outages | Offline-first Hive cache + sync queue. App works fully offline. Syncs when connectivity available, even on 2G. |
| **Paper records dominant** — most health posts use paper registers | Digital FHIR resources replace paper. FHIR Patient, Observation, Encounter are the digital equivalents of paper forms. |
| **No unique patient ID** — patients visit multiple facilities with no shared record | FHIR Patient.identifier with MRN system. Bulk export enables national health data exchange when policy catches up. |
| **Practitioner verification** — fake doctors a known problem | NMC verification via practitioner registration workflow (already built). FHIR Practitioner.qualification captures NMC number. |
| **Pharmacy without prescription** — common, leads to antibiotic resistance | FHIR MedicationRequest required for dispensation. Pharmacist app checks for active prescription before dispensing. |
| **Lab results lost** — patients carry paper reports, often misplaced | Digital FHIR DiagnosticReport + Observation. Results attached to patient record forever. Patient can access via portal. |
| **Referral fragmentation** — no standard referral process between facilities | FHIR ServiceRequest for referrals. FHIR Encounter tracks referral source. FHIR DocumentReference for referral letters. |
| **Language** — 123 languages, Devanagari script dominant | Noto Sans Devanagari font (already in shadcn theme). UI in Nepali + English. FHIR resources store both (HumanName with `use` = official/nickname). |

### 1.3 Nepal Health System Data Model

```text
Patient (Patient)
  ├── Demographics (name, DOB, gender, address, phone, MRN)
  ├── Identifiers (NID, citizenship, insurance, MRN)
  ├── Contacts (family, emergency)
  └── Communication (preferred language: 'ne' or 'en')

Encounter (Encounter)
  ├── Type (OPD visit, Inpatient admission, Emergency, Home visit, Teleconsult)
  ├── Location (Health Post, PHCC, Hospital, Clinic)
  ├── Referral (referred from/to another facility)
  ├── Diagnosis (primary + secondary)
  ├── Vitals captured (BP, HR, Temp, SpO2, Weight, Height)
  ├── Lab orders placed
  ├── Medications prescribed
  ├── Procedures performed
  └── Notes (SOAP format, in Nepali or English)

Observation (Observation)
  ├── Vital Signs (BP, HR, Temp, SpO2, RR, Weight, Height, BMI)
  ├── Lab Results (CBC, LFT, RFT, Lipid, HbA1c, Thyroid, etc.)
  ├── Imaging Results (X-ray, USG, CT, MRI — narrative + DICOM link)
  └── Social History (smoking, alcohol, occupation)

MedicationRequest (MedicationRequest)
  ├── Drug (RxNorm code or Nepal-specific drug code)
  ├── Dosage (strength, frequency, route, duration)
  ├── Prescriber (Practitioner reference)
  ├── Status (active, completed, stopped, on-hold)
  └── Dispensation (Pharmacy dispensation record)
```

---

## 2. System Architecture

### 2.1 Complete Data Flow

```text
┌─────────────────────────────────────────────────────────────────────┐
│                         CLINICAL CURATOR                             │
│                                                                     │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐ │
│  │  Patient App     │  │  Clinician App    │  │  Admin Console   │ │
│  │  (Flutter)       │  │  (Flutter)       │  │  (Flutter)       │ │
│  │                  │  │                  │  │                  │ │
│  │  OFFLINE-FIRST   │  │  ONLINE-PRIMARY  │  │  ONLINE-ONLY     │ │
│  │  Hive cache      │  │  Direct API      │  │  Direct API      │ │
│  │  sync queue      │  │                  │  │                  │ │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘ │
│           │                     │                      │           │
│           │  sync when online   │  always online       │ always    │
│           ▼                     ▼                      ▼           │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    FHIR R4 REST API                          │  │
│  │  ┌────────────┐ ┌──────────────┐ ┌────────────┐ ┌─────────┐│  │
│  │  │Patient     │ │Observation   │ │Encounter   │ │Consent  ││  │
│  │  │POST/GET/PUT│ │POST/GET      │ │POST/GET/PUT│ │CRUD     ││  │
│  │  ├────────────┤ ├──────────────┤ ├────────────┤ ├─────────┤│  │
│  │  │Condition   │ │MedReq        │ │DiagReport  │ │ServReq  ││  │
│  │  │CRUD        │ │CRUD          │ │CRUD        │ │CRUD     ││  │
│  │  ├────────────┤ ├──────────────┤ ├────────────┤ ├─────────┤│  │
│  │  │AllergyIntol│ │Immunization  │ │Provenance  │ │AuditEvent││  │
│  │  │CRUD        │ │CRUD          │ │read-only   │ │read-only││  │
│  │  ├────────────┤ ├──────────────┤ ├────────────┤ ├─────────┤│  │
│  │  │Appointment │ │Slot          │ │Practitioner│ │Organizat││  │
│  │  │CRUD        │ │CRUD          │ │CRUD        │ │CRUD     ││  │
│  │  ├────────────┤ ├──────────────┤ ├────────────┤ ├─────────┤│  │
│  │  │Composition │ │Device        │ │Location    │ │CarePlan ││  │
│  │  │CRUD        │ │CRUD          │ │CRUD        │ │CRUD     ││  │
│  │  └────────────┘ └──────────────┘ └────────────┘ └─────────┘│  │
│  └──────────────────────┬───────────────────────────────────────┘  │
│                         │                                          │
│  ┌──────────────────────┴───────────────────────────────────────┐  │
│  │              PostgreSQL (pgvector on pg16)                    │  │
│  │                                                               │  │
│  │  fhir_resource (JSONB)      — All FHIR resources             │  │
│  │  fhir_resource_history      — Version history                │  │
│  │  fhir_audit_log             — Access audit trail             │  │
│  │  fhir_export_jobs           — Bulk export tracking           │  │
│  │  fhir_smart_auth            — SMART OAuth2 sessions          │  │
│  │  serverpod_*                — Serverpod framework tables     │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────┐           ┌──────────────────┐              │
│  │  Redis            │           │  MinIO / S3      │              │
│  │  (sessions/cache) │           │  (Documents,     │              │
│  └──────────────────┘           │   DICOM, NDJSON) │              │
│                                 └──────────────────┘              │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Deployment Model

```text
Production:  clinicalcurator.com (Docker on cloud VM)
  ├── Serverpod API   → port 8080 (TLS)
  ├── Insights        → port 8081 (internal)
  ├── Web server      → port 8082 (TLS)
  ├── PostgreSQL      → port 5432 (internal)
  ├── Redis            → port 6379 (internal)
  └── MinIO            → port 9000 (internal)

Development: localhost
  ├── Serverpod API   → port 8080
  ├── PostgreSQL      → port 8090 (docker-compose)
  ├── Redis            → port 8091 (docker-compose)
  └── Flutter apps     → run on emulator/device
```

---

## 3. Complete FHIR R4 Resource Catalog

### 3.1 Core Clinical Resources

| FHIR Resource | Use in Clinical Curator | Key Fields |
|---------------|------------------------|------------|
| **`Patient`** | Every user. Stores demographics, identifiers, contacts, preferred language. | `name` (HumanName[]), `gender`, `birthDate`, `identifier` (MRN, NID), `telecom`, `address`, `maritalStatus`, `contact`, `communication.language` (ne/en), `generalPractitioner` |
| **`Practitioner`** | Every verified doctor/nurse. Links to NMC registration. | `name`, `identifier` (NMC number), `qualification`, `telecom`, `address` |
| **`PractitionerRole`** | What a practitioner does at a specific location. | `practitioner`, `organization`, `code` (specialty), `specialty`, `location`, `telecom`, `availableTime` |
| **`Encounter`** | Every patient visit. OPD, IPD, Emergency, Home visit, Teleconsult. | `status`, `class` (AMB/IMP/EMER/HH/VIRTUAL), `type`, `subject` (Patient), `participant` (Practitioners), `period`, `reasonCode`, `diagnosis`, `hospitalization`, `location`, `serviceProvider` (Organization) |
| **`Observation`** | Vital signs, lab results, clinical findings. | `status`, `category` (vital-signs/laboratory/imaging/social-history), `code` (LOINC), `subject` (Patient), `effectiveDateTime`, `valueQuantity`/`valueString`/`valueCodeableConcept`, `referenceRange`, `interpretation` (H/L), `component` (for panel observations like BP) |
| **`Condition`** | Diagnoses, problems, chief complaints. | `clinicalStatus`, `verificationStatus`, `category` (problem-list-item/encounter-diagnosis), `code` (SNOMED/ICD-10), `subject` (Patient), `onsetDateTime`, `recorder` (Practitioner), `note` |
| **`MedicationRequest`** | Prescriptions. Every drug order. | `status` (active/on-hold/stopped/completed), `intent` (order/plan), `medicationCodeableConcept` (RxNorm), `subject` (Patient), `encounter`, `authoredOn`, `requester` (Practitioner), `dosageInstruction`, `dispenseRequest`, `note` |
| **`MedicationDispense`** | Pharmacy dispensation. Links prescription to actual drug given. | `status`, `medicationReference`, `subject` (Patient), `authorizingPrescription` (MedicationRequest), `whenHandedOver`, `quantity`, `performer` (Pharmacist/Organization), `note` |
| **`AllergyIntolerance`** | Drug allergies, food allergies, environmental. | `clinicalStatus`, `type` (allergy/intolerance), `category` (medication/food/environment), `code` (SNOMED/RxNorm), `patient` (Patient), `onsetDateTime`, `reaction`, `criticality` |
| **`Immunization`** | Vaccination records. Critical for Nepal's immunization program. | `status`, `vaccineCode` (CVX), `patient` (Patient), `occurrenceDateTime`, `lotNumber`, `performer` (Practitioner), `note`, `protocolApplied` |
| **`DiagnosticReport`** | Lab reports, imaging reports, pathology. | `status`, `category` (LAB/RAD), `code` (LOINC panel code), `subject` (Patient), `effectiveDateTime`, `performer` (Organization), `result` (Observations), `conclusion`, `presentedForm` (PDF attachment) |
| **`Procedure`** | Clinical procedures performed. | `status`, `code` (SNOMED), `subject` (Patient), `performedDateTime`, `performer` (Practitioner), `bodySite`, `outcome`, `note` |

### 3.2 Operational Resources

| FHIR Resource | Use in Clinical Curator | Key Fields |
|---------------|------------------------|------------|
| **`Appointment`** | Scheduling. Patient ↔ Practitioner at a slot. | `status` (proposed/pending/booked/arrived/fulfilled/cancelled/noshow), `serviceType`, `start`/`end`, `participant[]`, `slot`, `comment` |
| **`Slot`** | A time window a practitioner is available. | `schedule`, `status` (free/busy), `start`/`end` |
| **`Schedule`** | A collection of slots for a practitioner at a location. | `actor`, `planningHorizon`, `serviceType` |
| **`ServiceRequest`** | Lab orders, imaging orders, referrals. | `status`, `intent` (order), `code` (what is being requested), `subject` (Patient), `occurrenceDateTime`, `requester` (Practitioner), `performer` (target lab/imaging/referral), `reasonCode`, `note` |
| **`CarePlan`** | Treatment plan. Follow-ups, medication schedule, lifestyle advice. | `status`, `intent`, `category`, `subject` (Patient), `period`, `activity` |
| **`CareTeam`** | Who is involved in a patient's care. | `status`, `subject` (Patient), `participant[]` |
| **`Composition`** | Clinical documents (discharge summary, referral letter). | `status`, `type` (LOINC doc type), `subject` (Patient), `date`, `author` (Practitioner), `section[]`, `custodian` (Organization) |
| **`DocumentReference`** | References to external documents (PDFs, images). | `status`, `type`, `subject` (Patient), `date`, `author`, `content[]` (attachment URLs) |
| **`Communication`** | Secure messaging between patient and care team. | `status`, `subject` (Patient), `sender`, `recipient[]`, `sent`, `payload[]` |

### 3.3 Administrative & Compliance Resources

| FHIR Resource | Use in Clinical Curator | Key Fields |
|---------------|------------------------|------------|
| **`Organization`** | Hospitals, clinics, health posts, pharmacies, labs. | `name`, `type`, `address`, `telecom`, `partOf` (parent org) |
| **`Location`** | Physical location. Ward, room, bed. | `status`, `name`, `type`, `address`, `managingOrganization`, `partOf` |
| **`Consent`** | Patient consent for data sharing. Core to privacy. | `status`, `scope`, `category`, `patient` (Patient), `performer`, `provision` (who can do what) |
| **`Provenance`** | Who changed what and when. Every resource change logged. | `target[]`, `recorded`, `activity`, `agent[]` (who + role), `entity[]` |
| **`AuditEvent`** | Every API call logged. Who accessed what. | `type`, `subtype`, `action` (C/R/U/D/E), `recorded`, `outcome`, `agent[]`, `source`, `entity[]` |
| **`Device`** | Medical devices that produce data. | `status`, `type` (device type), `manufacturer`, `modelNumber`, `location`, `patient` |
| **`HealthcareService`** | Services offered by an organization. | `location` (Organization), `type`, `specialty`, `availableTime`, `notAvailable` |

### 3.4 Nepal-Specific Code Systems & Extensions

| Code System | Usage | Source |
|-------------|-------|--------|
| **LOINC** | Lab tests, vital signs, clinical documents | `http://loinc.org` |
| **SNOMED CT** | Diagnoses, procedures, allergies | `http://snomed.info/sct` |
| **RxNorm** | Medications (with Nepal-specific subset) | `https://www.nlm.nih.gov/research/umls/rxnorm/` |
| **ICD-10** | Disease classification (used by MoHP reporting) | `http://hl7.org/fhir/sid/icd-10` |
| **CVX** | Vaccines (Nepal EPI schedule) | `http://hl7.org/fhir/sid/cvx` |
| **NMC Identifier** | Nepal Medical Council registration | `https://nmc.org.np/identifiers/practitioner` (custom system URI) |
| **NHSS Facility Code** | Nepal Health Sector facility codes | Custom system URI for MoHP facility registry |
| **Nepal EPI Schedule** | Immunization schedule per national policy | Custom extension on Immunization |

### Nepal Immunization Schedule (EPI)

```text
Birth:       BCG, OPV-0, HepB-0
6 weeks:     DPT-HepB-Hib-1, OPV-1, PCV-1, Rota-1
10 weeks:    DPT-HepB-Hib-2, OPV-2, PCV-2, Rota-2
14 weeks:    DPT-HepB-Hib-3, OPV-3, PCV-3, IPV
9 months:    Measles-Rubella-1, JE (in endemic districts)
12 months:   (none)
15 months:   Measles-Rubella-2
5 years:     Td booster
```

---

## 4. Medical Workflows

### 4.1 Patient Registration & Triage

```text
PATIENT WALK-IN (Health Post / Hospital OPD)

1. Registration Desk
   ├── Check if patient exists: GET /fhir/Patient?identifier=MRN|value
   ├── If new:
   │   ├── POST /fhir/Patient (name, DOB, gender, address, phone, MRN=auto)
   │   └── POST /fhir/Consent (default privacy consent)
   └── If existing: GET /fhir/Patient/{id} (verify demographics)

2. Vitals Check (Nurse/Health Assistant)
   ├── POST /fhir/Observation (BP, HR, Temp, SpO2, Weight, Height)
   │   All tagged with category=vital-signs, LOINC codes
   └── POST /fhir/Encounter
       ├── class=AMB (outpatient)
       ├── status=arrived → triaged
       ├── location=Health Post X
       └── participant={nurse who took vitals}

3. Queue
   ├── GET /fhir/Encounter?status=triaged&location={facility}
   └── Doctor sees queue in dashboard (ultimate_grid)

4. Doctor Consultation
   ├── GET /fhir/Encounter/{id} (current encounter)
   ├── GET /fhir/Observation?encounter={id}&category=vital-signs
   ├── GET /fhir/Condition?patient={id}&clinical-status=active (problem list)
   ├── GET /fhir/MedicationRequest?patient={id}&status=active
   ├── GET /fhir/AllergyIntolerance?patient={id} (allergy check)
   ├── Doctor adds findings:
   │   ├── POST /fhir/Condition (new diagnosis, SNOMED coded)
   │   ├── POST /fhir/Observation (clinical findings)
   │   ├── POST /fhir/ServiceRequest (lab order)
   │   ├── POST /fhir/MedicationRequest (prescription)
   │   └── PUT /fhir/Encounter/{id} (add SOAP notes, diagnosis, status=finished)
   └── POST /fhir/Provenance (record all changes)

5. Post-Consultation
   ├── Lab: GET /fhir/ServiceRequest?patient={id}&status=active&category=laboratory
   ├── Pharmacy: GET /fhir/MedicationRequest?patient={id}&status=active
   └── Follow-up: POST /fhir/CarePlan (treatment plan + next visit date)
```

### 4.2 Laboratory Workflow

```text
LAB ORDERING (Doctor → Lab)

1. Doctor orders test during encounter:
   POST /fhir/ServiceRequest
   {
     "resourceType": "ServiceRequest",
     "status": "active",
     "intent": "order",
     "code": {
       "coding": [{"system": "http://loinc.org", "code": "57698-3",
                    "display": "Lipid Panel"}]
     },
     "subject": {"reference": "Patient/pt-ram"},
     "requester": {"reference": "Practitioner/dr-arpan"},
     "encounter": {"reference": "Encounter/enc-20260624-001"},
     "note": [{"text": "Fasting 12 hours required"}]
   }

2. Lab technician receives order:
   GET /fhir/ServiceRequest?status=active&category=laboratory
   (Shows all pending lab orders in ultimate_grid)

3. Sample collection:
   ├── PUT /fhir/ServiceRequest/{id} (status=in-progress, add specimen info)
   └── POST /fhir/Specimen (specimen details — future FHIR resource)

4. Test performed:
   └── POST /fhir/Observation (for each test in panel)
   {
     "resourceType": "Observation",
     "status": "final",
     "category": [{"coding": [{"system": "...", "code": "laboratory"}]}],
     "code": {"coding": [{"system": "http://loinc.org", "code": "2093-3",
                          "display": "Cholesterol"}]},
     "subject": {"reference": "Patient/pt-ram"},
     "effectiveDateTime": "2026-06-24T10:30:00+05:45",
     "valueQuantity": {"value": 185, "unit": "mg/dL"},
     "referenceRange": [{"low": {"value": 0}, "high": {"value": 200}}]
   }

5. Lab report assembled:
   POST /fhir/DiagnosticReport
   {
     "resourceType": "DiagnosticReport",
     "status": "final",
     "category": [{"coding": [{"code": "LAB"}]}],
     "code": {"coding": [{"system": "http://loinc.org", "code": "57698-3"}]},
     "subject": {"reference": "Patient/pt-ram"},
     "effectiveDateTime": "2026-06-24T10:45:00+05:45",
     "performer": [{"reference": "Organization/lab-everest"}],
     "result": [
       {"reference": "Observation/obs-chol"},
       {"reference": "Observation/obs-trig"},
       {"reference": "Observation/obs-hdl"},
       {"reference": "Observation/obs-ldl"}
     ],
     "conclusion": "Lipid panel within normal limits."
   }

   PUT /fhir/ServiceRequest/{id} (status=completed)

6. Doctor notified:
   ├── GET /fhir/DiagnosticReport?patient=pt-ram&date=ge2026-06-24
   └── Results appear in patient chart "Results" tab (ultimate_grid)

7. Patient accesses results:
   ├── Patient portal: "My Health Record" → "Lab Results"
   └── GET /fhir/DiagnosticReport?patient={self}&_sort=-date
```

### 4.3 Pharmacy & Prescription Workflow

```text
PRESCRIPTION (Doctor → Pharmacist)

1. Doctor prescribes during encounter:
   POST /fhir/MedicationRequest
   {
     "resourceType": "MedicationRequest",
     "status": "active",
     "intent": "order",
     "medicationCodeableConcept": {
       "coding": [{"system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                    "code": "860975", "display": "Amlodipine 5 MG Oral Tablet"}],
       "text": "Amlodipine 5mg"
     },
     "subject": {"reference": "Patient/pt-ram"},
     "encounter": {"reference": "Encounter/enc-20260624-001"},
     "authoredOn": "2026-06-24T11:00:00+05:45",
     "requester": {"reference": "Practitioner/dr-arpan"},
     "dosageInstruction": [{
       "text": "Take one tablet daily in the morning",
       "timing": {"repeat": {"frequency": 1, "period": 1, "periodUnit": "d"}},
       "doseAndRate": [{"doseQuantity": {"value": 5, "unit": "mg", "code": "mg"}}],
       "route": {"coding": [{"code": "PO", "display": "Oral"}]}
     }],
     "dispenseRequest": {
       "quantity": {"value": 30, "unit": "tablets"},
       "numberOfRepeatsAllowed": 2
     }
   }

   CDS Check (Clinical Decision Support):
   ├── GET /fhir/AllergyIntolerance?patient=pt-ram&code=860975
   │   (Check: is patient allergic to amlodipine?)
   ├── GET /fhir/MedicationRequest?patient=pt-ram&status=active
   │   (Check: drug-drug interactions with current meds?)
   └── If alert: show warning to doctor before finalizing

2. Pharmacist dispenses:
   GET /fhir/MedicationRequest?patient=pt-ram&status=active
   (Shows all active prescriptions to dispense)

   POST /fhir/MedicationDispense
   {
     "resourceType": "MedicationDispense",
     "status": "completed",
     "medicationReference": {"reference": "MedicationRequest/mr-amlodipine"},
     "subject": {"reference": "Patient/pt-ram"},
     "performer": [{"actor": {"reference": "Organization/pharmacy-everest"}}],
     "whenHandedOver": "2026-06-24T12:00:00+05:45",
     "quantity": {"value": 30, "unit": "tablets"},
     "note": [{"text": "Dispensed as prescribed. Counseled on taking in morning."}]
   }

3. Refill request (Patient Portal):
   Patient: "My Health Record" → "Medications" → Request Refill
   POST /fhir/MedicationRequest (new order with note: "Patient-requested refill")

4. Medication adherence:
   GET /fhir/MedicationDispense?patient=pt-ram
   (Shows dispensing history — did they pick up their refills?)
```

### 4.4 Referral Workflow

```text
REFERRAL (Health Post → District Hospital)

1. Health Post doctor decides referral is needed:
   POST /fhir/ServiceRequest
   {
     "resourceType": "ServiceRequest",
     "status": "active",
     "intent": "order",
     "priority": "urgent",
     "code": {"text": "Cardiology consultation for uncontrolled hypertension"},
     "subject": {"reference": "Patient/pt-ram"},
     "requester": {"reference": "Practitioner/dr-hp"},
     "performer": [{"reference": "Organization/hospital-district"}],
     "reasonCode": [{"coding": [{"code": "38341003",
                                 "display": "Hypertension"}]}],
     "note": [{"text": "BP 180/110 despite amlodipine 5mg. Needs specialist eval."}]
   }

2. Referral letter (FHIR Composition):
   POST /fhir/Composition
   {
     "resourceType": "Composition",
     "status": "final",
     "type": {"coding": [{"code": "57133-1",
                          "display": "Referral note"}]},
     "subject": {"reference": "Patient/pt-ram"},
     "date": "2026-06-24T14:00:00+05:45",
     "author": [{"reference": "Practitioner/dr-hp"}],
     "section": [
       {"title": "Reason for Referral", "text": {"div": "..."}},
       {"title": "History", "text": {"div": "..."}},
       {"title": "Vitals", "text": {"div": "..."}},
       {"title": "Current Medications", "text": {"div": "..."}},
       {"title": "Lab Results", "text": {"div": "..."}}
     ]
   }

3. Receiving hospital:
   GET /fhir/ServiceRequest?performer=hospital-district&status=active
   (See incoming referrals)

   When patient arrives:
   POST /fhir/Encounter
   {
     "class": "IMP",
     "status": "arrived",
     "hospitalization": {
       "admitSource": {"coding": [{"code": "trans", "display": "Transferred"}]},
     },
     "basedOn": [{"reference": "ServiceRequest/referral-001"}]
   }

4. Referral outcome:
   PUT /fhir/ServiceRequest/referral-001 (status=completed, outcome added)
```

### 4.5 Emergency & Ambulance Workflow

```text
AMBULANCE REQUEST (Patient/Caregiver → Ambulance Service)

1. Request:
   POST /fhir/ServiceRequest (category=ambulance)
   {
     "resourceType": "ServiceRequest",
     "status": "active",
     "intent": "order",
     "priority": "stat",
     "code": {"text": "Emergency ambulance transport"},
     "subject": {"reference": "Patient/pt-ram"},
     "occurrenceDateTime": "2026-06-24T18:00:00+05:45",
     "note": [{"text": "Patient reports severe chest pain. Location: ..."}],
     // GPS coordinates via extension
   }

2. Ambulance dispatch:
   PUT /fhir/ServiceRequest/{id} (status=in-progress, driver assigned, ETA)

3. Tracking:
   Patient app shows ambulance location on map (flutter_map)
   Periodic GPS updates from driver app → server

4. Handover:
   POST /fhir/Encounter
   {
     "class": "EMER",
     "status": "arrived",
     "hospitalization": {"admitSource": {"coding": [
       {"code": "emerg", "display": "Emergency"}]}},
     "reasonCode": [{"text": "Chest pain — possible MI"}]
   }

   PUT /fhir/ServiceRequest/{id} (status=completed, with handover notes)
```

### 4.6 Telemedicine Workflow

```text
TELEMEDICINE CONSULT (Patient at home → Doctor remotely)

1. Patient books teleconsult:
   POST /fhir/Appointment
   {
     "serviceType": [{"text": "Telemedicine Consultation"}],
     "start": "2026-06-25T10:00:00+05:45",
     "end": "2026-06-25T10:30:00+05:45",
     "participant": [
       {"actor": {"reference": "Patient/pt-ram"}, "status": "accepted"},
       {"actor": {"reference": "Practitioner/dr-arpan"}, "status": "accepted"}
     ]
   }

2. At appointment time:
   POST /fhir/Encounter
   {
     "class": "VR",
     "status": "in-progress",
     // Video call (WebRTC) launched
   }

3. During call:
   ├── Doctor views patient records (GET /fhir/*?patient=pt-ram)
   ├── Doctor adds notes (PUT /fhir/Encounter/{id})
   ├── Doctor prescribes (POST /fhir/MedicationRequest)
   └── Doctor orders labs (POST /fhir/ServiceRequest)

4. After call:
   PUT /fhir/Encounter/{id} (status=finished, add SOAP notes)
```

### 4.7 Preventive Care & Public Health

```text
IMMUNIZATION CAMP (Health Post / Outreach)

1. Community health worker registers child:
   POST /fhir/Patient (age <5 years, with guardian contact)

2. Check immunization status:
   GET /fhir/Immunization?patient={child-id}

3. Administer vaccine:
   POST /fhir/Immunization
   {
     "resourceType": "Immunization",
     "status": "completed",
     "vaccineCode": {"coding": [{"system": "http://hl7.org/fhir/sid/cvx",
                                 "code": "03", "display": "MMR"}]},
     "patient": {"reference": "Patient/child-sita"},
     "occurrenceDateTime": "2026-06-24T10:00:00+05:45",
     "lotNumber": "LOT-2026-001",
     "protocolApplied": [{
       "targetDisease": [{"coding": [{"code": "14189004",
                                       "display": "Measles"}]}],
       "doseNumberPositiveInt": 1
     }]
   }

4. Next due date:
   POST /fhir/CarePlan (immunization schedule plan)

SCREENING PROGRAM (e.g., Hypertension, Diabetes)

1. Community screening:
   POST /fhir/Observation (BP, blood glucose — mass screening)

2. Refer abnormal cases:
   POST /fhir/ServiceRequest (referral to health post for follow-up)

3. Population analytics:
   GET /fhir/Observation?code=85354-9&date=ge2026-01-01 (Bulk export)
   → Dashboard: hypertension prevalence in municipality X
```

---

## 5. Offline-First Design for Nepal

### 5.1 Connectivity Realities

```text
Nepal Internet Profile:
  ├── Urban (Kathmandu, Pokhara): 4G/LTE, fiber — 20-50 Mbps
  ├── Semi-urban (district HQs): 3G/4G, ADSL — 2-10 Mbps
  ├── Rural (health posts): 2G/EDGE, satellite — 0.1-1 Mbps
  └── Remote (mountain villages): No connectivity for days/weeks

System Response:
  ├── Patient app: FULL offline mode. Works with Hive cache.
  ├── Sync uses minimal bandwidth (delta sync via _since).
  ├── Sync queue retries with exponential backoff.
  └── Critical data (emergency) can be sent via SMS gateway.
```

### 5.2 Sync Protocol

```text
Client Sync Flow:

1. App foregrounds OR connectivity restored:
   └── FhirSyncService.check()

2. Pull (Server → Client):
   For each resource type (Patient, Observation, Encounter, etc.):
   └── GET /fhir/{type}?_since=2026-06-24T00:00:00Z&_count=500
   └── response.hasMore=true → repeat with nextSince timestamp
   └── Upsert into Hive cache (key = "{type}/{fhirId}")
   └── Save new lastSyncTimestamp_{type} in SharedPreferences

3. Push (Client → Server):
   Get all dirty entries from Hive cache:
   ├── syncStatus=pending_upload:
   │   └── PUT /fhir/{type}/{fhirId} (if existing)
   │   └── POST /fhir/{type} (if new — no fhirId yet)
   └── syncStatus=pending_delete:
       └── DELETE /fhir/{type}/{fhirId}

4. Conflict Resolution:
   Both client and server have meta.lastUpdated.
   Server wins if server.lastUpdated > client.lastUpdated.
   Client wins if client.lastUpdated > server.lastUpdated.
   Tie: server wins (conservative).

5. Bandwidth Optimization:
   ├── _since=timestamp means only changes since last sync (not full dataset)
   ├── _count=500 batch size (adjustable for slow connections)
   ├── Only sync patient's own resources (not full database)
   └── Observation payloads ~200-500 bytes each (efficient)

Estimated sync sizes:
  ├── First sync (full patient history): 100-500 KB (all records)
  ├── Daily sync (new results): 5-50 KB (just today's changes)
  └── Works on 2G (10-15 second sync time for daily changes)
```

### 5.3 Offline Capabilities Matrix

| Action | Online | Offline |
|--------|--------|---------|
| View patient records (meds, vitals, allergies) | ✅ | ✅ (cached) |
| View lab results | ✅ | ✅ (cached, last synced) |
| Record vitals (BP, HR, etc.) | ✅ | ✅ (queued) |
| Write encounter notes (SOAP) | ✅ | ✅ (queued) |
| Prescribe medications | ✅ | ✅ (queued — CDS checks run on sync) |
| Order lab tests | ✅ | ✅ (queued — lab sees order on sync) |
| Book appointment | ✅ | ✅ (queued — slot reservation on sync) |
| Request ambulance | ✅ | ⚠️ (SMS fallback needed) |
| Video call (telemedicine) | ✅ | ❌ (requires connectivity) |
| Sync data | ✅ | ❌ (waits for connectivity) |

---

## 6. Nepal-Specific Features

### 6.1 Practitioner Registration (NMC Verification)

Already partially built in admin app. Complete workflow:

```text
1. Doctor downloads Clinical Curator Clinician app
2. Signs up with email + password
3. Selects "Register as Practitioner"
4. Enters:
   ├── NMC Registration Number (verified against NMC database — future API)
   ├── License photo upload (stored as DocumentReference)
   ├── Specialization (Cardiology, Orthopedics, etc.)
   └── Practice location (health post, hospital, clinic)
5. Status: pending → admin verification queue
6. Admin reviews (existing verification_detail_screen.dart):
   ├── Verifies NMC number
   ├── Verifies license photo
   ├── Approves → practitioner.isVerified = true
   └── Practitioner can now switch to "Clinician View"
```

Future: Integrate with NMC API when available. For now, manual verification with photo upload.

### 6.2 Nepali Language Support

```dart
// Patient resource with Nepali support
{
  "resourceType": "Patient",
  "communication": [
    {
      "language": {
        "coding": [
          {"system": "urn:ietf:bcp:47", "code": "ne", "display": "Nepali"}
        ],
        "text": "नेपाली"
      },
      "preferred": true
    }
  ],
  "name": [
    {
      "use": "official",
      "family": "महर्जन",
      "given": ["अर्जुन"]
    },
    {
      "use": "usual",
      "family": "Maharjan",
      "given": ["Arjun"]
    }
  ],
  "address": [
    {
      "use": "home",
      "text": "ललितपुर १६, बागमती प्रदेश",
      "district": "Lalitpur",
      "state": "Bagmati",
      "country": "NP"
    }
  ]
}
```

UI: All labels in Nepali + English toggle. FHIR resources store both scripts.

### 6.3 Health Post / District Hospital Hierarchy

```text
Organization hierarchy (FHIR Organization.partOf):
  ├── MoHP (Ministry of Health)
  │   ├── Bagmati Province Health Directorate
  │   │   ├── Lalitpur District Health Office
  │   │   │   ├── Patan Hospital (tertiary)
  │   │   │   ├── Godawari PHCC (primary)
  │   │   │   └── Chapagaun Health Post (basic)
  │   │   └── ...
  │   └── ...
  └── Private Hospitals
      ├── Bir Hospital
      ├── Grande International Hospital
      └── ...

Referral chain:
  Health Post → PHCC → District Hospital → Provincial Hospital → Tertiary
  (Each level uses FHIR ServiceRequest for referrals upward)
```

### 6.4 Nepal EPI (Expanded Program on Immunization)

```dart
// CarePlan for immunization schedule
Future<void> createImmunizationCarePlan(String childFhirId) async {
  final schedule = [
    _ScheduleEntry(age: Duration.zero, vaccines: ['BCG', 'OPV-0', 'HepB-0']),
    _ScheduleEntry(age: Duration(days: 42), vaccines: ['DPT-HepB-Hib-1', 'OPV-1', 'PCV-1', 'Rota-1']),
    _ScheduleEntry(age: Duration(days: 70), vaccines: ['DPT-HepB-Hib-2', 'OPV-2', 'PCV-2', 'Rota-2']),
    _ScheduleEntry(age: Duration(days: 98), vaccines: ['DPT-HepB-Hib-3', 'OPV-3', 'PCV-3', 'IPV']),
    _ScheduleEntry(age: Duration(days: 270), vaccines: ['Measles-Rubella-1', 'JE']),
    _ScheduleEntry(age: Duration(days: 450), vaccines: ['Measles-Rubella-2']),
    _ScheduleEntry(age: Duration(days: 1825), vaccines: ['Td-booster']),
  ];

  final carePlan = {
    'resourceType': 'CarePlan',
    'status': 'active',
    'intent': 'plan',
    'category': [{'coding': [{'code': 'immunization'}]}],
    'subject': {'reference': 'Patient/$childFhirId'},
    'period': {'start': DateTime.now().toIso8601String()},
    'activity': schedule.map((s) => {
      'detail': {
        'status': 'scheduled',
        'scheduledString': 'At ${_calculateDate(s.age)}',
        'code': {'text': s.vaccines.join(', ')},
      },
    }).toList(),
  };

  await fhirApi.create('CarePlan', carePlan);
}
```

### 6.5 Nepal Drug Database (DDA)

The Department of Drug Administration maintains a list of registered drugs in Nepal. Common medications used in Nepal that should be in the terminology cache:

```text
Common Nepal medications (RxNorm codes where available, custom codes otherwise):
  ├── Amoxicillin 500mg          (RxNorm: 308191)
  ├── Amlodipine 5mg             (RxNorm: 860975)
  ├── Metformin 500mg            (RxNorm: 6809)
  ├── Paracetamol 500mg          (RxNorm: 315266)
  ├── Ibuprofen 400mg            (RxNorm: 316762)
  ├── Omeprazole 20mg            (RxNorm: 7646)
  ├── Salbutamol Inhaler 100mcg  (RxNorm: 745679)
  ├── Oral Rehydration Salts     (custom code)
  ├── Zinc Sulfate 20mg          (custom code)
  ├── Iron/Folic Acid tablets    (Nepal MoHP: IFA)
  ├── Albendazole 400mg          (RxNorm: 636123)
  └── Cotrimoxazole 480mg        (RxNorm: 208017)
```

---

## 7. Implementation Roadmap

### Phase 1: Foundation (Weeks 1-3)
- FHIR JSONB schema + migration (`fhir_resource`, `fhir_resource_history`)
- `FhirStoreService` — CRUD + search with GIN indexes
- `FhirApiEndpoint` — full FHIR REST API (read, create, update, delete, search, history, batch, metadata)
- Search parameter extraction for Patient, Observation, Encounter, MedicationRequest
- **Deliverable:** `curl https://localhost:8080/fhir/Patient/123` returns valid FHIR JSON

### Phase 2: Data Migration + Sync (Weeks 4-5)
- Migrate mock seed data to FHIR JSON (16 patients → real FHIR Patient + Observation resources)
- Hive cache redesign (single `FhirCacheEntry` class replaces 27)
- `FhirSyncService` — pull/push with `_since` timestamp
- Offline queue with `syncStatus` flag
- **Deliverable:** Patient app works offline, syncs when online

### Phase 3: Patient Chart (Weeks 6-9)
- Patient banner with demographics, allergies, active problems
- 9-tab patient chart navigation
- SOAP note editor (Encounter workspace)
- Problem list management (Condition CRUD)
- Medication list + interactions (MedicationRequest + CDS)
- Vitals trending (Observation → fl_chart)
- **Deliverable:** Doctor can manage a full patient encounter

### Phase 4: Patient Portal (Weeks 10-12)
- My Health Record screen (problems, meds, allergies, labs, immunizations)
- Appointment booking wizard (practitioner search → slot picker → confirm)
- Medication refill request
- Secure messaging (FHIR Communication)
- Self-reported vitals entry
- **Deliverable:** Patient can manage their own health records

### Phase 5: Medical Services (Weeks 13-15)
- Lab order → result workflow (ServiceRequest → Observation → DiagnosticReport)
- Pharmacy dispensing (MedicationRequest → MedicationDispense)
- Referral workflow (ServiceRequest → Composition → receiving Encounter)
- Immunization schedule tracker (Nepal EPI)
- Ambulance request with GPS tracking
- **Deliverable:** Full clinical workflows operational

### Phase 6: Interoperability + Hardening (Weeks 16-18)
- SMART on FHIR OAuth2 (Phase 4A)
- FHIR Bulk Export (Phase 4B)
- Audit trail (AuditEvent + Provenance for every interaction)
- Data validation (FHIR profiles)
- Terminology service (LOINC, SNOMED, RxNorm local cache)
- **Deliverable:** Production-ready platform

### Phase 7: UI Modernization (Weeks 19-20)
- ultimate_grid on patient directory, lab results, medications, appointments, audit log
- Redesigned clinician + patient dashboards
- Responsive layout (mobile/tablet/desktop)
- **Deliverable:** Modern, professional UI

---

## 8. Technical Specifications

### 8.1 FHIR Bundle Response Format

```json
// GET /fhir/Patient?_count=20&_offset=0&gender=male
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 247,
  "link": [
    {"relation": "self", "url": "/fhir/Patient?_count=20&_offset=0&gender=male"},
    {"relation": "next", "url": "/fhir/Patient?_count=20&_offset=20&gender=male"}
  ],
  "entry": [
    {
      "fullUrl": "https://clinicalcurator.com/fhir/Patient/pt-001",
      "resource": {
        "resourceType": "Patient",
        "id": "pt-001",
        "meta": {"versionId": "3", "lastUpdated": "2026-06-24T10:30:00+05:45"},
        "name": [{"family": "Maharjan", "given": ["Arjun"]}],
        "gender": "male",
        "birthDate": "1990-03-15"
      }
    }
  ]
}
```

### 8.2 OperationOutcome (Error Response)

```json
// POST /fhir/Observation with missing subject
{
  "resourceType": "OperationOutcome",
  "issue": [
    {
      "severity": "error",
      "code": "invalid",
      "diagnostics": "Observation.subject is required",
      "location": ["Observation.subject"]
    }
  ]
}
```

### 8.3 Database Size Estimates

```text
Per patient (average):
  ├── 1 Patient resource                         ~2 KB
  ├── 10 Encounters (visits)                      ~10 KB
  ├── 50 Observations (vitals + labs)             ~15 KB
  ├── 10 Conditions (diagnoses)                    ~3 KB
  ├── 20 MedicationRequests (prescriptions)        ~10 KB
  ├── 5 AllergyIntolerance                         ~1 KB
  ├── 10 Immunization                               ~2 KB
  ├── 5 DiagnosticReports                          ~5 KB
  ├── 20 Appointments                               ~6 KB
  ├── 2 CarePlans                                   ~2 KB
  └── Audit overhead                                 ~10 KB
  Total per patient: ~66 KB (compressed/full JSON)

For 100,000 patients:
  ├── FHIR resources: ~6.4 GB
  ├── History (10 versions avg): ~64 GB
  ├── Audit log (100 events/patient): ~20 GB
  └── Total: ~90 GB (well within PostgreSQL capabilities)

GIN indexes add ~30% overhead: ~120 GB total.
Easily fits on a 500 GB cloud VM for years of data.
```

### 8.4 Security Considerations

```text
Transport: TLS 1.3 for all API calls
Auth: JWT + Serverpod Auth (already built)
RBAC: cc_rbac + FHIR Consent for data-level access control
Audit: Every FHIR API call logged (AuditEvent + dedicated table)
Encryption: PostgreSQL at rest (file system encryption)
Backup: Daily pg_dump + WAL archiving
