# Feature 10 — AI Triage Placeholder

## Overview

Build the full symptom triage UI with a mock keyword-based service for v1. The architecture is designed for future integration with a **self-hosted LLM** (not limited to Claude API). The triage result connects to the appointment booking flow (Feature 08).

## Dependencies

- Feature 08 (Appointment Booking) — triage result links to doctor search/booking flow

## What Already Exists

Nothing specific to AI triage exists in the codebase. The booking hub (Feature 08) will have a "Describe Symptoms" path that routes here.

## What Needs to Be Built

### 1. Triage Intro Screen — `lib/features/ai_triage/screens/triage_intro_screen.dart` (new)

- Explanation of how AI-assisted triage works
- Privacy notice: "Your symptoms are analyzed locally / sent to a secure AI service"
- Clear disclaimer: "This is not a medical diagnosis. Always consult a healthcare professional."
- "Start Assessment" CTA button
- Option to skip directly to booking

### 2. Symptom Input Screen — `lib/features/ai_triage/screens/symptom_input_screen.dart` (new)

Multi-step symptom entry form:

**Step 1 — Body Region:**
- Visual body map (front/back silhouette) with tappable regions
- Regions: Head, Chest, Abdomen, Back, Arms, Legs, Skin, General/Whole Body
- Multiple selection allowed
- Alternative: dropdown/chip selector for accessibility

**Step 2 — Symptom Description:**
- Free text input: "Describe what you're experiencing"
- Common symptom quick-select chips:
  - Pain, Fever, Cough, Shortness of breath, Nausea, Dizziness, Fatigue, Swelling, Rash, Numbness
- Selected chips appear as tags below input

**Step 3 — Details:**
- Duration: "When did it start?" (Today, 1-3 days, 1 week, 2+ weeks, 1+ months)
- Severity: 1-10 scale slider with labels (Mild / Moderate / Severe)
- Onset: Sudden or Gradual
- Pattern: Constant, Intermittent, Getting worse, Getting better
- Associated symptoms: checklist of related symptoms based on selected region

**Step 4 — Medical Context:**
- Existing conditions: auto-populated from patient's FHIR Condition records (if logged in)
- Current medications: auto-populated from MedicationRequest records
- Allergies: auto-populated from AllergyIntolerance records
- Additional notes: free text

### 3. Triage Result Screen — `lib/features/ai_triage/screens/triage_result_screen.dart` (new)

Displays triage recommendation:

- **Urgency level** with color coding:
  - Emergency (red): "Seek emergency care immediately" — link to ambulance request or ER info
  - Urgent (orange): "See a doctor within 24 hours"
  - Routine (blue): "Schedule an appointment within the week"
  - Self-care (green): "Monitor at home, see a doctor if symptoms worsen"

- **Recommended specialty:** Based on symptoms (e.g., "Cardiology", "Dermatology", "General Medicine")

- **Reasoning:** Brief explanation of why this urgency/specialty was recommended

- **Actions:**
  - "Find a Doctor" → navigates to doctor search (Feature 08) pre-filtered by recommended specialty
  - "Find Nearby Hospital" → navigates to hospital search with relevant department
  - "Call Emergency" → phone dialer for emergency number (102 in Nepal)
  - "Save Assessment" → stores locally for reference

- **Disclaimer banner:** "This assessment is powered by AI and is not a substitute for professional medical advice. If you are experiencing a medical emergency, call 102 immediately."

### 4. Triage History Screen — `lib/features/ai_triage/screens/triage_history_screen.dart` (new)

- List of past triage assessments
- Each entry: date, symptoms summary, urgency level, recommended specialty
- Tap to view full assessment detail
- Option to share with doctor during appointment

### 5. Triage Service Architecture — `lib/core/services/triage_service.dart` (new)

```dart
class TriageAssessment {
  final List<String> bodyRegions;
  final String symptomDescription;
  final List<String> symptomTags;
  final String duration;
  final int severity;
  final String onset;
  final String pattern;
  final List<String> existingConditions;
  final List<String> medications;
  final List<String> allergies;
  final String? additionalNotes;
}

enum UrgencyLevel { emergency, urgent, routine, selfCare }

class TriageResult {
  final UrgencyLevel urgency;
  final String recommendedSpecialty;
  final String reasoning;
  final double confidence;
  final DateTime assessedAt;
}

abstract class TriageService {
  Future<TriageResult> assess(TriageAssessment assessment);
}
```

### 6. Mock Triage Service — `lib/core/services/mock_triage_service.dart` (new)

Keyword-based triage that returns plausible results:

```
Rules (examples):
- "chest pain" + severity > 7 → Emergency, Cardiology
- "fever" + "cough" + duration > 3 days → Urgent, Internal Medicine
- "headache" + severity < 5 → Routine, General Medicine
- "rash" + "itching" → Routine, Dermatology
- "shortness of breath" → Urgent, Pulmonology
- "abdominal pain" + "nausea" → Urgent, Gastroenterology
- Default: Routine, General Medicine
```

### 7. LLM Triage Service Stub — `lib/core/services/llm_triage_service.dart` (new)

Placeholder for future self-hosted LLM integration:

```dart
abstract class LlmTriageService implements TriageService {
  // Base class for any LLM-backed triage
  // Subclasses can target different backends:
  // - Self-hosted LLM (Ollama, vLLM, etc.)
  // - Claude API
  // - OpenAI API
  // - Local on-device model
}

class SelfHostedLlmTriageService extends LlmTriageService {
  final String baseUrl; // e.g., http://localhost:11434/api (Ollama)

  // TODO: Implement with self-hosted LLM
  // - Configurable endpoint URL
  // - Structured prompt with symptom data
  // - Parse LLM response into TriageResult
  // - Rate limiting: max 5 assessments per hour
  // - Safety: always include "consult professional" caveat
  // - Fallback to MockTriageService if LLM unavailable

  @override
  Future<TriageResult> assess(TriageAssessment assessment) {
    throw UnimplementedError('LLM integration coming in v2');
  }
}
```

Document the planned prompt engineering approach:
```
System prompt: "You are a medical triage assistant. Based on the symptoms provided,
assess the urgency level (emergency/urgent/routine/self-care) and recommend an
appropriate medical specialty. Always err on the side of caution. This is NOT a
diagnosis - always recommend professional consultation."
```

The architecture supports multiple LLM backends via the abstract `TriageService` interface. The provider uses a feature flag to switch between `MockTriageService` (v1) and `LlmTriageService` implementations (v2+).

### 8. Triage Provider — `lib/domain/providers/triage_provider.dart` (new)

```dart
// Manages triage flow state
// Stores assessments locally for history
// Feature flag to switch between MockTriageService and ClaudeTriageService
final triageServiceProvider = Provider<TriageService>((ref) {
  // Check feature flag
  return MockTriageService();
});

final triageHistoryProvider = StateNotifierProvider<TriageHistoryNotifier, List<TriageResult>>(...);
```

### 9. Triage Data Model — `lib/domain/models/triage_assessment.dart` (new)

Store assessments locally using the generic `FhirResource` box or a lightweight Hive model:
- Symptoms, urgency level, recommended specialty, confidence score, timestamp
- Link to appointment if one was booked as a result

### 10. Navigation Updates

Add routes:
- `/patient/triage` — triage intro
- `/patient/triage/symptoms` — symptom input
- `/patient/triage/result` — triage result
- `/patient/triage/history` — past assessments

Entry points:
- Booking hub (Feature 08) → "Describe Symptoms" path → triage intro
- Patient services hub → "Symptom Checker" tile

## Implementation Order

1. Create `triage_assessment.dart` and `triage_result` domain models
2. Create `triage_service.dart` abstract interface
3. Create `mock_triage_service.dart` with keyword rules
4. Create `claude_triage_service.dart` stub
5. Create `triage_provider.dart` with feature flag
6. Create `triage_intro_screen.dart`
7. Create `symptom_input_screen.dart` with multi-step form
8. Create `triage_result_screen.dart` with urgency display
9. Create `triage_history_screen.dart`
10. Update router and connect to booking hub

## Acceptance Criteria

- [ ] Symptom input form captures structured data (regions, description, duration, severity, onset, pattern)
- [ ] Common symptom chips allow quick selection
- [ ] Patient's existing conditions/medications/allergies auto-populate from FHIR records
- [ ] Mock triage returns plausible urgency level and specialty based on symptoms
- [ ] Result screen clearly displays urgency with color coding
- [ ] "This is not a diagnosis" disclaimer is prominent on all triage screens
- [ ] Result links to doctor search pre-filtered by recommended specialty
- [ ] Emergency urgency links to ambulance request / emergency number
- [ ] Assessments are saved locally and viewable in history
- [ ] Architecture is ready for Claude API swap-in (replace `MockTriageService` with `ClaudeTriageService`)
- [ ] Feature flag can toggle between mock and Claude service

## FHIR Compliance Notes

Triage assessments could map to FHIR `QuestionnaireResponse` resources, but for the placeholder implementation they are stored as app-domain models. The result's recommended specialty maps to standard specialty codes used in `PractitionerRole`.

## Mock Data Requirements

- No seed data needed (assessments are created by user interaction)
- Mock triage service needs a comprehensive keyword → result mapping covering common Nepal health scenarios:
  - Altitude sickness, tropical diseases, gastrointestinal issues, respiratory infections
  - Common chronic conditions: hypertension, diabetes, asthma

## Complexity Estimate

**Medium** — primarily UI screens with a mock backend. The multi-step symptom form is the most complex UI element. The actual AI integration is deferred. The body map visualization may require custom painting or a pre-built asset.
