⚠️ DEPRECATED — Superseded by docs/plan/12-18
This describes the legacy mock-data architecture. See 18-nepal-complete-system.md for current FHIR-native design.
---
# Feature 09 — Integrations

## Overview

Implement key integrations for v1: payment gateway mock for eSewa/Khalti and GPS/maps enhancements. Video calls remain as UI shell (real WebRTC deferred to v2). Notifications remain in-app only (FCM deferred to v2).

## Dependencies

- Feature 04 (Offline Sync) — sync for payment records, notification records
- Feature 08 (Appointment Booking) — appointments trigger notifications and payments

## What Already Exists

### Telemedicine
- `lib/features/telemedicine/screens/telemedicine_screen.dart` — specialist search with doctor cards, ratings, availability
- `lib/features/telemedicine/screens/video_call_screen.dart` — UI shell with camera/mic toggle buttons, timer, end call button. **No actual WebRTC implementation.**
- `flutter_webrtc` in `pubspec.yaml` (dependency added but unused)

### Notifications
- `lib/data/collections/notification_record_collection.dart` — `NotificationRecordLocal` (TypeId 7) with title, body, type, isRead, actionRoute, createdAt
- `lib/domain/providers/notification_provider.dart` — `NotificationNotifier` with CRUD, mark as read, unread count
- `lib/features/notifications/screens/notifications_screen.dart` — notification list with unread/read tabs
- **No** `firebase_messaging` in `pubspec.yaml` — in-app notifications only

### Maps / GPS
- `flutter_map: ^7.0.2` and `latlong2` in `pubspec.yaml`
- `geolocator` for device location
- `lib/features/ambulance/screens/ambulance_tracking_screen.dart` — map with ambulance tracking UI (mock position)

### Payments
- No payment screens or models exist
- `PaymentLocal` (TypeId 25) planned in Feature 01

### Server
- `clinical_curator_server/lib/src/endpoints/notification_endpoint.dart` — notification CRUD

## What Needs to Be Built

---

### A. Video Calls — UI Shell Only (v2 Feature)

> **Decision:** WebRTC implementation deferred to v2. The existing `video_call_screen.dart` UI shell is sufficient for v1. No signaling server, WebRTC service, or real video streaming needed now.

**v1 scope:** Keep current UI shell. Add a "Coming in v2" notice or disable the "Start Call" button with a tooltip.

---

### B. Notifications — In-App Only (FCM Deferred to v2)

> **Decision:** Firebase Cloud Messaging deferred to v2. Notifications remain in-app only using the existing `NotificationRecordLocal` (TypeId 7) and `NotificationNotifier`.

**v1 scope:** Ensure in-app notifications are created for key events:
- Appointment booking confirmation
- Appointment reminders (local scheduled notification via `flutter_local_notifications` if needed)
- Referral received
- Verification status change (for practitioners)

No Firebase setup, no FCM tokens, no server-side push.

---

### C. Payment Gateway Mock

#### 1. Payment Screen — `lib/features/payment/screens/payment_screen.dart` (new)

Payment form:
- Amount display (from appointment/service fee)
- Payment method selection: eSewa, Khalti, Cash (at facility)
- Method-specific input:
  - eSewa: eSewa ID / phone number
  - Khalti: Khalti ID / phone number
  - Cash: generate payment reference
- "Pay Now" button → processing screen

#### 2. Payment Processing Screen — `lib/features/payment/screens/payment_processing_screen.dart` (new)

Mock processing:
- Loading animation (2-3 second mock delay)
- Simulate eSewa/Khalti redirect and callback
- Success/failure result

#### 3. Payment Receipt Screen — `lib/features/payment/screens/payment_receipt_screen.dart` (new)

Post-payment:
- Transaction ID, amount, method, date/time
- Linked appointment/service details
- Download receipt as PDF
- Share receipt option

#### 4. Payment Gateway Adapters

**File:** `lib/core/services/payment_gateway.dart` (new)

```dart
abstract class PaymentGateway {
  Future<PaymentResult> initiatePayment(PaymentRequest request);
  Future<PaymentStatus> checkStatus(String transactionId);
}

class EsewaMockGateway implements PaymentGateway { ... }
class KhaltiMockGateway implements PaymentGateway { ... }
```

Mock gateways simulate the real flow with configurable success/failure rate.

#### 5. Payment Provider — `lib/domain/providers/payment_provider.dart` (new)

- Payment state management (idle → processing → success/failure)
- Payment history from `PaymentLocal` Hive box
- Gateway selection logic

#### 6. Server Endpoint — `clinical_curator_server/lib/src/endpoints/payment_endpoint.dart` (new)

- `createPayment(Session, PaymentRecord) → PaymentRecord`
- `getPaymentsByPatient(Session, String patientRef) → List<PaymentRecord>`
- `getPaymentByTransaction(Session, String transactionId) → PaymentRecord`

---

### D. GPS / Maps Enhancements

#### 1. Ambulance Tracking Enhancement

**File:** `lib/features/ambulance/screens/ambulance_tracking_screen.dart` (update)

- Simulate real-time ambulance position updates (timer-based mock)
- Animated ambulance marker moving along a route
- ETA recalculation based on position
- Driver contact card with call/message buttons

#### 2. Location Service — `lib/core/services/location_service.dart` (new)

```dart
class LocationService {
  Future<Position> getCurrentPosition();
  Stream<Position> watchPosition();
  double calculateDistance(LatLng from, LatLng to);
}
```

#### 3. Hospital Distance Calculation

Enhance `hospitals_screen.dart`:
- Calculate and display distance from user's current position to each hospital
- Sort by nearest option
- Request location permission on first use

## Implementation Order

1. **Payments:** payment_gateway adapters → payment_provider → payment screens → server endpoint
2. **GPS:** location_service → ambulance tracking enhancement → hospital distance
3. **In-app notifications:** Ensure NotificationNotifier creates records for booking, referral, verification events
4. **Video calls (v2):** Deferred — keep UI shell
5. **FCM (v2):** Deferred — no Firebase setup

## Acceptance Criteria

- [ ] Payment flow completes end-to-end with mock eSewa/Khalti gateway
- [ ] Payment receipts generated and stored in `PaymentLocal` box
- [ ] Ambulance tracking shows simulated real-time position updates
- [ ] Hospital list shows distance from user's location
- [ ] In-app notifications created for booking, referral, and verification events
- [ ] Video call screen shows "Coming in v2" state (UI shell preserved)
- [ ] All integrations degrade gracefully when offline (payments queue for later)

## FHIR Compliance Notes

- Video calls are linked to `Appointment` resources (telemedicine type)
- Payment records could map to FHIR `PaymentNotice` or `PaymentReconciliation` but are stored as app-domain `PaymentLocal` for simplicity
- Notifications reference FHIR resource IDs in `actionRoute` for deep linking

## Mock Data Requirements

- Mock WebRTC: test with local loopback or two simulator instances
- FCM: requires Firebase project setup with `google-services.json`
- Payments: mock gateways need configurable responses (90% success, 10% failure for realism)
- GPS: mock ambulance route coordinates for tracking simulation

## Complexity Estimate

**Medium** — with WebRTC and FCM deferred to v2, the v1 scope is payment mock + GPS enhancements + in-app notification triggers. Significantly reduced from original scope.
