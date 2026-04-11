/// FHIR R4 System URIs and Common Code Constants
class FhirConstants {
  FhirConstants._();

  // System URIs
  static const String loincSystem = 'http://loinc.org';
  static const String snomedSystem = 'http://snomed.info/sct';
  static const String rxNormSystem = 'http://www.nlm.nih.gov/research/umls/rxnorm';
  static const String cvxSystem = 'http://hl7.org/fhir/sid/cvx';
  static const String icd10System = 'http://hl7.org/fhir/sid/icd-10';
  static const String observationCategorySystem =
      'http://terminology.hl7.org/CodeSystem/observation-category';
  static const String diagnosticCategorySystem =
      'http://terminology.hl7.org/CodeSystem/v2-0074';
  static const String consentCategorySystem =
      'http://terminology.hl7.org/CodeSystem/consentcategorycodes';
  static const String consentScopeSystem =
      'http://terminology.hl7.org/CodeSystem/consentscope';

  // Observation categories
  static const String vitalSigns = 'vital-signs';
  static const String laboratory = 'laboratory';
  static const String imaging = 'imaging';

  // Common LOINC codes
  static const String heartRateCode = '8867-4';
  static const String bloodPressureSystolicCode = '8480-6';
  static const String bloodPressureDiastolicCode = '8462-4';
  static const String bodyTemperatureCode = '8310-5';
  static const String oxygenSaturationCode = '2708-6';
  static const String respiratoryRateCode = '9279-1';
  static const String bodyWeightCode = '29463-7';
  static const String bodyHeightCode = '8302-2';

  // Blood pressure panel
  static const String bloodPressurePanelCode = '85354-9';

  // UCUM system
  static const String ucumSystem = 'http://unitsofmeasure.org';

  // AllergyIntolerance systems
  static const String allergyIntoleranceClinicalSystem =
      'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical';
  static const String allergyIntoleranceVerificationSystem =
      'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification';

  // Participation type
  static const String participationTypeSystem =
      'http://terminology.hl7.org/CodeSystem/v3-ParticipationType';

  // Nepal-specific
  static const String nepalHealthIdSystem =
      'http://health.gov.np/fhir/sid/patient-id';
  static const String nmcSystem =
      'http://nmc.org.np/fhir/sid/practitioner-license';

  // Practitioner types
  static const String practitionerTypeDoctor = 'doctor';
  static const String practitionerTypeNurse = 'nurse';

  // Consent scopes
  static const String consentScopePatientPrivacy = 'patient-privacy';
  static const String consentScopeTreatment = 'treatment';

  // Encounter class codes
  static const String encounterClassAmbulatory = 'AMB';
  static const String encounterClassEmergency = 'EMER';
  static const String encounterClassInpatient = 'IMP';
  static const String encounterClassObservation = 'OBSENC';

  // Encounter status codes
  static const String encounterStatusPlanned = 'planned';
  static const String encounterStatusArrived = 'arrived';
  static const String encounterStatusTriaged = 'triaged';
  static const String encounterStatusInProgress = 'in-progress';
  static const String encounterStatusOnLeave = 'onleave';
  static const String encounterStatusFinished = 'finished';
  static const String encounterStatusCancelled = 'cancelled';

  // Condition clinical status codes
  static const String conditionStatusActive = 'active';
  static const String conditionStatusRecurrence = 'recurrence';
  static const String conditionStatusRelapse = 'relapse';
  static const String conditionStatusInactive = 'inactive';
  static const String conditionStatusRemission = 'remission';
  static const String conditionStatusResolved = 'resolved';

  // Condition verification status codes
  static const String conditionVerifUnconfirmed = 'unconfirmed';
  static const String conditionVerifProvisional = 'provisional';
  static const String conditionVerifDifferential = 'differential';
  static const String conditionVerifConfirmed = 'confirmed';

  // Procedure status codes
  static const String procedureStatusPreparation = 'preparation';
  static const String procedureStatusInProgress = 'in-progress';
  static const String procedureStatusNotDone = 'not-done';
  static const String procedureStatusOnHold = 'on-hold';
  static const String procedureStatusStopped = 'stopped';
  static const String procedureStatusCompleted = 'completed';

  // ServiceRequest status codes
  static const String serviceRequestStatusDraft = 'draft';
  static const String serviceRequestStatusActive = 'active';
  static const String serviceRequestStatusOnHold = 'on-hold';
  static const String serviceRequestStatusRevoked = 'revoked';
  static const String serviceRequestStatusCompleted = 'completed';

  // ServiceRequest priority codes
  static const String priorityRoutine = 'routine';
  static const String priorityUrgent = 'urgent';
  static const String priorityAsap = 'asap';
  static const String priorityStat = 'stat';

  // ServiceRequest categories
  static const String categoryLaboratory = 'laboratory';
  static const String categoryImaging = 'imaging';
  static const String categoryReferral = 'referral';
  static const String categoryProcedure = 'procedure';

  // CarePlan status codes
  static const String carePlanStatusDraft = 'draft';
  static const String carePlanStatusActive = 'active';
  static const String carePlanStatusOnHold = 'on-hold';
  static const String carePlanStatusRevoked = 'revoked';
  static const String carePlanStatusCompleted = 'completed';

  // Slot status codes
  static const String slotStatusFree = 'free';
  static const String slotStatusBusy = 'busy';
  static const String slotStatusBusyUnavailable = 'busy-unavailable';
  static const String slotStatusBusyTentative = 'busy-tentative';

  // Encounter class system URI
  static const String encounterClassSystem =
      'http://terminology.hl7.org/CodeSystem/v3-ActCode';

  // Condition clinical status system URI
  static const String conditionClinicalStatusSystem =
      'http://terminology.hl7.org/CodeSystem/condition-clinical';

  // Condition verification status system URI
  static const String conditionVerificationStatusSystem =
      'http://terminology.hl7.org/CodeSystem/condition-ver-status';
}
