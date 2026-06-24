# Phase 8: Guff Messenger Integration

**Status:** 🔴 Not started
**Priority:** P3 — Value-add
**Depends on:** Guff API availability, Phase 4 (patient portal)

## Objective

Replace Clinical Curator's in-app chat (FHIR Communication) with Guff Messenger — Nepal's WhatsApp-like platform. Patients and providers use their existing Guff accounts. Clinical Curator sends/receives messages via the Guff API.

## Integration Model

```
Patient app                                 Provider app
┌─────────────┐                             ┌─────────────┐
│ Chat with   │                             │ Chat with   │
│ Dr. Sharma  │                             │ Patient Ram │
│ (opens Guff)│                             │ (opens Guff)│
└──────┬──────┘                             └──────┬──────┘
       │   Guff deep link:                           │
       │   guff://chat/practitioner-dr-arpan-id      │
       ▼                                             ▼
┌────────────────────────────────────────────────────────────┐
│                      Guff Messenger                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Healthcare Chat Rooms                                │  │
│  │                                                      │  │
│  │  Patient ↔ Practitioner in a verified medical room   │  │
│  │  Room created by: POST /guff/chat/room (API key)    │  │
│  │  Message types: text, image (lab report), pdf       │  │
│  │  Encryption: E2EE for all medical conversations      │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
       │   Guff REST API                                     │
       ▼
┌────────────────────────────────────────────────────────────┐
│               Clinical Curator Server                       │
│  Webhook handler: /webhook/guff                            │
│  Triggers: patient portal notification,                    │
│            message saved to FHIR Communication             │
└────────────────────────────────────────────────────────────┘
```

## API Contract (Expected)

```dart
// Clinical Curator → Guff API
class GuffMessagingService {
  final Dio _http = Dio(BaseOptions(baseUrl: 'https://api.guff.com/v1'));

  /// Create a secure medical chat room.
  /// patientGuffId: Guff user ID of the patient
  /// practitionerGuffId: Guff user ID of the practitioner
  /// Returns: room ID (for deep linking)
  Future<String> createChatRoom({
    required String patientGuffId,
    required String practitionerGuffId,
    required String organizationId,  // Clinical Curator org that requested
  }) async {
    final response = await _http.post('/chat/rooms', data: {
      'participants': [patientGuffId, practitionerGuffId],
      'metadata': {'org_id': organizationId, 'type': 'healthcare'},
      'e2ee': true,
    });
    return response.data['room_id'] as String;
  }

  /// Send a message on behalf of a clinical user.
  Future<void> sendMessage({
    required String roomId,
    required String senderGuffId,
    required String body,
    String? attachmentUrl,
  }) async {
    await _http.post('/chat/rooms/$roomId/messages', data: {
      'sender_id': senderGuffId,
      'body': body,
      'attachment_url': attachmentUrl,
    });
  }

  /// Generate a deep link to open the chat in Guff app.
  String chatDeepLink(String roomId) => 'guff://chat/room/$roomId';
}
```

## Webhook Handler

```dart
// clinical_curator_server/lib/src/endpoints/guff_webhook_endpoint.dart

class GuffWebhookEndpoint extends Endpoint {
  /// POST /webhook/guff — Called by Guff when a new message arrives.
  Future<void> receiveMessage(Session session, Map<String, dynamic> payload) async {
    final roomId = payload['room_id'] as String;
    final senderId = payload['sender_id'] as String;
    final body = payload['body'] as String;
    final timestamp = payload['timestamp'] as String;

    // Save as FHIR Communication for audit trail
    await _fhirStore.create(session, {
      'resourceType': 'Communication',
      'status': 'completed',
      'payload': [{'contentString': body}],
      'sent': timestamp,
      // ... sender, recipient resolved from room metadata
    });
  }
}
```

## Files

| File | Purpose |
|------|---------|
| `packages/data/lib/services/guff_messaging_service.dart` | Guff API client |
| `apps/clinical/lib/features/patient_portal/screens/chat_screen.dart` | Chat screen with Guff deep link |
| `clinical_curator_server/lib/src/endpoints/guff_webhook_endpoint.dart` | Guff webhook handler |