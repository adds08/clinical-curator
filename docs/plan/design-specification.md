# Clinical Curator — Complete UI/UX Design Specification

> **Target Audience**: AI designer or human designer creating screens, wireframes, and UI flows for Clinical Curator — a clinical EMR, patient portal, and appointment platform with FHIR R4 compatibility.

---

## TABLE OF CONTENTS

1. [Design System Overview](#1-design-system-overview)
2. [Global Layout Rules](#2-global-layout-rules)
3. [Color System & Conventions](#3-color-system--conventions)
4. [Typography & Spacing](#4-typography--spacing)
5. [Iconography](#5-iconography)
6. [Component Library (shadcn_flutter)](#6-component-library-shadcn_flutter)
7. [Role-Based Navigation (Shells)](#7-role-based-navigation-shells)
8. [Screen Specifications](#8-screen-specifications)
   - 8.1 Patient Home Screen
   - 8.2 Patient Appointment Booking
   - 8.3 Medical Records (Patient View)
   - 8.4 Pharmacy Orders
   - 8.5 Doctor Dashboard
   - 8.6 Doctor Schedule (Timesheet)
   - 8.7 Add / Edit Schedule Entry
   - 8.8 Patient Management (Clinician)
   - 8.9 Patient Chart / EMR Core Screen
   - 8.10 Encounter Workspace (SOAP / Clinical Note)
   - 8.11 Telemedicine
   - 8.12 Ambulance Request
   - 8.13 Health Tips
   - 8.14 Insurance Claims
   - 8.15 Lab Bookings
   - 8.16 Notifications
   - 8.17 Profile & Settings
   - 8.18 Hospitals Directory
   - 8.19 Consent Management
   - 8.20 Signup / Login / Onboarding
9. [Admin App Specifications](#9-admin-app-specifications)
10. [Data Flow & State Patterns](#10-data-flow--state-patterns)
11. [File Organization](#11-file-organization)
12. [Implementation Priority Order](#12-implementation-priority-order)
13. [Authored Screens References](#13-authored-screens-references)

---

## 1. Design System Overview

| Property | Value |
|---|---|
| Framework | Flutter 3.x |
| UI Library | **shadcn_flutter v0.0.52** (not Material) |
| Components Library Provider | `shadcn_flutter/shadcn_flutter.dart` |
| Icon Set | **LucideIcons** (bundled with shadcn_flutter) |
| State Management | `flutter_riverpod` |
| Local Storage | Hive CE |
| Backend | Serverpod 3.4.5 + PostgreSQL 16 + Redis |
| Health Data Format | FHIR R4 |
| Offline Support | Offline-first with optional cloud sync |

**Critical Rule**: Do NOT use Material Design widgets (no `Theme.of(context).primaryColor`, no `ElevatedButton`, no `IconButton`, no `SizedBox.expand`, etc). Use only shadcn_flutter components.

---

## 2. Global Layout Rules

### 2.1 Page Scaffold
- Sub-pages (non-tab screens): Use `SubPageScaffold` widget from `cc_core/widgets/sub_page_scaffold.dart`
  - Provides consistent title bar with back navigation arrow
  - Takes `title` (String) and `child` parameters
- Full-page screens (tab-based): Use `Container(color: colors.background)` + `SafeArea` + `SingleChildScrollView`

### 2.2 Padding
- Scrollable content: `EdgeInsets.all(AppSpacing.lg)` (usually 16px)
- Cards inside containers: `EdgeInsets.all(AppSpacing.xl)` (24px) or `AppSpacing.lg` for compact
- Inter-element spacing: `SizedBox(height: AppSpacing.xl)` for sections, `AppSpacing.md` for small gaps

### 2.3 Cards
- Card background: `SurfaceTheme.colorFor(SurfaceLevel.lowest, context)`
- Card border radius: `AppRadius.cardRadius`
- Card padding: `AppSpacing.xl` (standard), `AppSpacing.lg` (compact)

### 2.4 Colors
- All colors from `Theme.of(context).colorScheme`
- Never hardcode hex colors

### 2.5 Empty States
- Use a Card with centered Column
- Icon: large (28-36px), color `colors.mutedForeground.withValues(alpha: 0.4)`
- Message: below icon, `Text(message, style: TextStyle(fontSize: 13-14, fontWeight: FontWeight.w600, color: colors.mutedForeground))`
- Optional CTA button below the empty state

### 2.6 Loading
- Use `Spinner` component from shadcn_flutter (NOT `CircularProgressIndicator`)
- Center in container with SizedBox

### 2.7 Error/Toast
- Error display: `Basic(leading: Icon(LucideIcons.triangleAlert, color: colors.warning), title: Text(message))` inside a `SurfaceCard` with `showToast()`
- Success: `Basic(leading: Icon(LucideIcons.circleCheck, color: colors.success), title: Text(message))`

### 2.8 Form Labels
- Use small bold captions above fields:
```dart
Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.mutedForeground, letterSpacing: 0.3))
```

---

## 3. Color System & Conventions

| Token | Usage | Example |
|---|---|---|
| `colors.primary` | Primary brand, active state, primary buttons | "Book Now", selected tab |
| `colors.primaryForeground` | Text on primary background | Button label |
| `colors.foreground` | Primary text | Headings, body text |
| `colors.mutedForeground` | Secondary text, captions | Dates, subtitles, hints |
| `colors.background` | Page background | Container fill |
| `colors.card` | Card surface | Default card background |
| `colors.success` | Completed, done, available, normal | "DONE" badge |
| `colors.successBackground` | Light success fill | Badge background |
| `colors.warning` | In-progress, checked-in, partial | "CHECKED IN", "IN QUEUE" |
| `colors.destructive` | Cancelled, error, emergency, allergy | "CANCELLED", critical values |
| `colors.muted` | Subtle backgrounds | Chip backgrounds, progress bar track |
| `colors.border` | Dividers, borders | Divider widget |

### Status Color Mapping

| Status | Color |
|---|---|
| `booked` / waiting | `colors.primary` |
| `checked-in` / in queue | `colors.warning` |
| `completed` / done | `colors.success` |
| `cancelled` / rejected | `colors.destructive` |
| `noshow` | `colors.mutedForeground` |
| Emergency override | `colors.warning` |
| Telehealth | `colors.primary` |

---

## 4. Typography & Spacing

### Text Size & Weight Scale

| Role | Size | Weight | Color |
|---|---|---|---|
| Page title | 20-22px | w800 | foreground |
| Section header | 15-18px | w700 | foreground |
| Sub-header | 15-16px | w700 | foreground |
| Card title | 13-14px | w700 | foreground |
| Body text | 13-14px | w500 | foreground |
| Caption / Meta | 10-12px | w600 | mutedForeground |
| Badge / Chip | 9-11px | w700 | per context |
| Stat value | 18-28px | w800 | foreground |
| Stat label | 9-10px | w600 | per context |
| Form label | 12px | w700 | mutedForeground |

### Spacing Scale (AppSpacing constants)

| Constant | Value (px) | Usage |
|---|---|---|
| `AppSpacing.xs` | 4 | Tight between icons |
| `AppSpacing.sm` | 6-8 | Between elements in a row |
| `AppSpacing.md` | 12 | Between card items |
| `AppSpacing.lg` | 16 | Page padding, card padding |
| `AppSpacing.xl` | 24 | Section spacing, card padding |
| `AppSpacing.xxl` | 32 | Section separation |
| `AppSpacing.xxxl` | 48 | Major section separation |

### Border Radius (AppRadius)

| Constant | Value | Usage |
|---|---|---|
| `AppRadius.inputRadius` | 8px | Inputs, buttons, container corners |
| `AppRadius.cardRadius` | 12px | Card corners |
| `AppRadius.chipRadius` | 16px | Badge/chip corners |

---

## 5. Iconography

- **Icon Set**: `LucideIcons` from `shadcn_flutter`
- Size: 14-16px for inline, 18-24px for feature icons, 28-36px for empty states, 20-24px for avatar placeholders

### Common Icons Reference

| Use Case | Icon Name | Size |
|---|---|---|
| Home / Dashboard | `LucideIcons.house` | 20 |
| Calendar | `LucideIcons.calendar` | 16-20 |
| Calendar with days | `LucideIcons.calendarDays` | 14-16 |
| Appointments | `LucideIcons.calendarCheck` | 16-20 |
| Patients / People | `LucideIcons.users` | 16-20 |
| Add new | `LucideIcons.plus` | 14-16 |
| Edit | `LucideIcons.pencil` | 14-16 |
| Delete | `LucideIcons.trash2` | 14-16 |
| Search | `LucideIcons.search` | 14-16 |
| Bell / Notifications | `LucideIcons.bell` | 16-20 |
| Video / Telemedicine | `LucideIcons.video` | 16-18 |
| Ambulance / Emergency | `LucideIcons.ambulance` | 20-24 |
| Clock / Time | `LucideIcons.clock` | 14-16 |
| Medication / Pharmacy | `LucideIcons.pill` | 16-20 |
| Lab / Flask | `LucideIcons.flaskConical` | 16-20 |
| Insurance / Shield | `LucideIcons.shieldCheck` | 16-20 |
| Emergency Alert | `LucideIcons.shieldAlert` | 14-18 |
| User / Avatar | `LucideIcons.user` | 16-20 |
| Chevron | `LucideIcons.chevronLeft/Right` | 16-18 |
| Settings | `LucideIcons.settings` | 16-20 |
| Logout | `LucideIcons.logOut` | 16-18 |
| Info | `LucideIcons.info` | 14-16 |
| Heart / Vitals | `LucideIcons.heartPulse` | 16-20 |
| File / Records | `LucideIcons.fileText` | 16-20 |
| Eye / View | `LucideIcons.eye` | 16-20 |
| Check / Success | `LucideIcons.circleCheck` | 16-24 |
| Warning / Alert | `LucideIcons.triangleAlert` | 16-24 |
| Hospital / Location | `LucideIcons.hospital` | 16-20 |
| Phone / Contact | `LucideIcons.phone` | 16-20 |
| Globe / Website | `LucideIcons.globe` | 14-16 |
| Star / Rating | `LucideIcons.star` | 12-16 |
| Lightbulb / Tips | `LucideIcons.lightbulb` | 16-20 |
| Exit / Leave | `LucideIcons.logOut` | 16 |
| Prescription | `LucideIcons.filePrescription` | 16-20 |
| Clipboard | `LucideIcons.clipboardList` | 16-20 |
| Checkbox checked | `CheckboxState.checked` | -- |
| Checkbox unchecked | `CheckboxState.unchecked` | -- |

---

## 6. Component Library (shadcn_flutter)

Every UI element must be from shadcn_flutter unless specified otherwise.

### Available Components

| Component | Import Path | Notes |
|---|---|---|
| `Card` | `shadcn_flutter` | Container with padding, fillColor |
| `Button.primary` | `shadcn_flutter` | Primary action button |
| `Button` (default) | `shadcn_flutter` | Outline/secondary button |
| `TextField` | `shadcn_flutter` | Text input with controller/placeholder/features |
| `TextArea` | `shadcn_flutter` | Multi-line text input |
| `Select` | `shadcn_flutter` | Dropdown with `SelectPopup` + `SelectItemButton` |
| `SelectPopup` | `shadcn_flutter` | Popup for Select items |
| `SelectItemList` | `shadcn_flutter` | Wrap items in this |
| `SelectItemButton` | `shadcn_flutter` | Individual selectable item |
| `DatePicker` | `shadcn_flutter` | Date picker with popover/dialog mode |
| `TimePicker` | `shadcn_flutter` | Time picker with popover/dialog mode |
| `Calendar` | `shadcn_flutter` | Month grid calendar with `CalendarView`, `CalendarSelectionMode`, `CalendarValue.single()` |
| `CalendarView` | `shadcn_flutter` | `CalendarView(year, month)` or `CalendarView.fromDateTime(date)` |
| `CalendarValue` | `shadcn_flutter` | `CalendarValue.single(date)`, `.range(start, end)`, `.multi(dates)` |
| `SingleCalendarValue` | `shadcn_flutter` | Pattern match: `value is SingleCalendarValue` |
| `CalendarSelectionMode` | `shadcn_flutter` | `.none`, `.single`, `.range`, `.multi` |
| `DateState` | `shadcn_flutter` | `.disabled`, `.enabled` |
| `Checkbox` | `shadcn_flutter` | With `CheckboxState.checked/unchecked` |
| `Chip` | `shadcn_flutter` | Pressable chip with onPressed + child |
| `Avatar` | `shadcn_flutter` | `Avatar(initials: "JD", size: 36)` |
| `Badge` | `shadcn_flutter` | `PrimaryBadge`, `SecondaryBadge`, `DestructiveBadge`, `SuccessBadge` |
| `Progress` | `shadcn_flutter` | Circular/linear progress indicator |
| `LinearProgressIndicator` | `shadcn_flutter` | Thin bar progress |
| `Switch` | `shadcn_flutter` | Toggle switch (on/off) |
| `Divider` | `shadcn_flutter` | Horizontal rule |
| `Spinner` | `shadcn_flutter` | Loading spinner |
| `AlertDialog` | `shadcn_flutter` | Dialog with title, content, actions |
| `Accordion` | `shadcn_flutter` | Expandable accordion panel |
| `SurfaceCard` | `shadcn_flutter` | Surface-level themed card |
| `Basic` | `shadcn_flutter` | Simple leading+title+subtitle layout |
| `Collapsible` | `shadcn_flutter` | Expandable content section |
| `Skeleton` | `shadcn_flutter` | Loading placeholder shimmer |
| `StarRating` | `shadcn_flutter` | Rating display/input |
| `ChipInput` | `shadcn_flutter` | Chip/tag input field |
| `Tabs` | `shadcn_flutter` | Default Flutter `TabBar` + `TabBarView` can be used |
| `showToast` | `shadcn_flutter` | Global toast notification function |
| `ObjectFormField` | `shadcn_flutter` | Form field wrapping any value type |
| `ControlledDatePicker` | `shadcn_flutter` | Controller-based date picker |
| `ControlledTimePicker` | `shadcn_flutter` | Controller-based time picker |

### Component Patterns

**Button.primary**:
```dart
Button.primary(
  onPressed: () { ... },
  child: const Text('Label'),
)
```

**Select dropdown**:
```dart
Select<String>(
  value: selectedValue,
  onChanged: (val) { if (val != null) setState(() => selectedValue = val); },
  itemBuilder: (context, item) => Text(item),
  // ignore: implicit_call_tearoffs
  popup: SelectPopup(
    items: SelectItemList(
      children: options.map((o) => SelectItemButton(value: o, child: Text(o))).toList(),
    ),
  ),
  placeholder: const Text('Select...'),
)
```

**DatePicker** (use popover mode):
```dart
DatePicker(
  value: dateValue,
  onChanged: (date) => setState(() => selectedDate = date),
  placeholder: const Text('Select a date'),
  mode: PromptMode.popover,
  stateBuilder: (date) => isPast ? DateState.disabled : DateState.enabled,
)
```

**TimePicker** (use popover mode):
```dart
TimePicker(
  value: timeValue,
  onChanged: (time) => setState(() => selectedTime = time),
  placeholder: const Text('Select time'),
  mode: PromptMode.popover,
)
```

**Calendar** (standalone, inside SurfaceCard):
```dart
Calendar(
  view: CalendarView.fromDateTime(currentDate),
  selectionMode: CalendarSelectionMode.single,
  value: selectedDate != null ? CalendarValue.single(selectedDate!) : null,
  onChanged: (value) {
    if (value is SingleCalendarValue) {
      setState(() => selectedDate = value.date);
    }
  },
  stateBuilder: (date) => isPast ? DateState.disabled : DateState.enabled,
)
```

---

## 7. Role-Based Navigation (Shells)

The app has two main shells determined by `user.activeRole`:

### 7.1 Patient Shell (Bottom Navigation)

**5 tabs**, each with icon + label:

| Tab | Route | Icon | Label |
|---|---|---|---|
| Home | `/patient-home` | `house` | Home |
| Appointments | `/bookings` | `calendar` | Appointments |
| Records | `/medical-records` | `fileText` | Records |
| Pharmacy | `/pharmacy` | `pill` | Pharmacy |
| Profile | `/profile` | `user` | Profile |

### 7.2 Clinician Shell (Bottom Navigation)

| Tab | Route | Icon | Label |
|---|---|---|---|
| Dashboard | `/doctor-dashboard` | `layoutDashboard` | Dashboard |
| Schedule | `/doctor-schedule` | `calendarDays` | Schedule |
| Patients | `/patient-management` | `users` | Patients |
| Tips | `/health-tips` | `lightbulb` | Tips |
| Profile | `/profile` | `user` | Profile |

### 7.3 Admin (Separate App)

- Found in `apps/admin/` directory
- Full-screen navigation with side menu or stack navigation
- Routes managed by its own `router.dart`

---

## 8. Screen Specifications

### 8.1 Patient Home Screen

**Route**: `/patient-home`
**Role**: Patient
**Purpose**: Dashboard summary, quick actions, upcoming appointments, health metrics snapshot

**Layout** (top to bottom, scrollable):
```
┌──────────────────────────────────────┐
│  "Hello, [Name]"       🔔(unread)   │
│  "How are you feeling today?"       │
│  [Date: EEEE, MMM d, yyyy]          │
│                                      │
│  🚨 Emergency Banner (red)           │
│  "In an emergency, call 102"         │
│  Tap → `/ambulance`                  │
│                                      │
│  ┌── Quick Actions ────────────────┐ │
│  │  Scrollable row of icon cards:  │ │
│  │  [Book Appt]  [Lab]  [Pharmacy] │ │
│  │  [Telemed]    [Amb]  [Insurance]│ │
│  │  Each: 56x56 rounded icon +     │ │
│  │        label below              │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Upcoming Appointments ───────┐ │
│  │  Header: "Upcoming" + badge     │ │
│  │  Each card:                     │ │
│  │  ● time | doctor name | type    │ │
│  │  Empty: "No upcoming" icon+text │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Vitals Summary ──────────────┐ │
│  │  3 horizontal cards:            │ │
│  │  [BP 120/80] [HR 72 bpm]       │ │
│  │  [SpO2 98%]                     │ │
│  │  Each: icon, label, value       │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Recent Notifications ────────┐ │
│  │  Each: icon + title + time      │ │
│  │  Limit 3 items, "View all" link │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components Used**: `Card`, `Button`, `Avatar`, `Badge`, `Container`

---

### 8.2 Patient Appointment Booking

**Route**: `/bookings`
**Role**: Patient
**Purpose**: View upcoming/past appointments, book new appointments

**Layout**:
```
┌── Top: Segmented toggle (3 options) ─┐
│  [Upcoming] [Past] [Book New]         │
├──────────────────────────────────────┤
│                                      │
│  === Tab: Upcoming ===               │
│  ┌──────────────────────────────┐    │
│  │  Appt card:                  │    │
│  │  ● dot | date/time           │    │
│  │  doctor name                 │    │
│  │  specialty | status badge    │    │
│  │  Tap → appt detail           │    │
│  │  Long-press → cancel dialog  │    │
│  └──────────────────────────────┘    │
│  Empty: "No upcoming appointments"   │
│                                      │
│  === Tab: Past ===                   │
│  Same card layout, status:           │
│  "Completed" / "Cancelled" /         │
│  "No Show"                           │
│                                      │
│  === Tab: Book New ===               │
│  ┌── Specialty filter dropdown ───┐  │
│  └────────────────────────────────┘  │
│  ┌── Available Slots ─────────────┐  │
│  │  Grouped by practitioner:      │  │
│  │  · Avatar + name + specialty   │  │
│  │  · Next available time         │  │
│  │  · [Book] button               │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

**Booking Flow**:
1. Select a slot → confirmation dialog with details
2. Confirm → creates AppointmentLocal with syncStatus=1 → bumps appointmentRefreshProvider
3. Toast success → navigates to Appointments tab

**Components Used**: `SurfaceCard` (toggle), `Avatar`, `Card`, `Button`, `Select`, `AlertDialog`

---

### 8.3 Medical Records (Patient View)

**Route**: `/medical-records`
**Role**: Patient
**Purpose**: View own health records — vitals, labs, medications, conditions, allergies, immunizations, reports

**Layout**:
```
┌── Search bar ───────────────────────┐
│  TextField with search icon          │
├────────────────────────────────────┤
│  ┌── Category Chips ──────────────┐ │
│  │  [All] [Vitals] [Labs] [Meds]  │ │
│  │  [Conditions] [Immunizations]   │ │
│  │  [Allergies] [Reports]         │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Record List ─────────────────┐ │
│  │  Each record as a Card:        │ │
│  │  Icon + type label + date      │ │
│  │  Value / summary line          │ │
│  │  Tap → full detail view        │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Detail View** (push route):
- Renders the FHIR Resource in a human-readable card layout
- Fields displayed with labels + values
- Coding systems shown with system URI + code + display
- Expandable "Raw FHIR JSON" section at bottom via `Collapsible` or `Accordion`

**Components Used**: `TextField` (search), `Chip`, `Card`, `Collapsible`, `Accordion`, `Divider`

---

### 8.4 Pharmacy Orders

**Route**: `/pharmacy`
**Role**: Patient
**Purpose**: Browse pharmacies, order medications, track orders

**Layout**:
```
┌── Header: "Pharmacy" ───────────────┐
├────────────────────────────────────┤
│  ┌── Pharmacies Nearby ───────────┐ │
│  │  Horizontal scrollable cards:  │ │
│  │  Pharmacy name, address,       │ │
│  │  open hours, rating stars      │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Active Prescriptions ────────┐ │
│  │  Each: medication name, dosage │ │
│  │  prescriber, refill status     │ │
│  │  [Order] button                │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Order History ───────────────┐ │
│  │  Each: date, pharmacy, items   │ │
│  │  status badge, total price     │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Order Flow**:
1. Select prescription or "Order without prescription"
2. Choose pharmacy from list
3. Select quantity
4. Add delivery address
5. Confirm → creates `PharmacyOrder` → syncStatus=1
6. Toast: "Order placed"

**Components Used**: `Card`, `Button`, `TextField`, `Select`, `Badge` (status), `StarRating`

---

### 8.5 Doctor Dashboard

**Route**: `/doctor-dashboard`
**Role**: Clinician
**Purpose**: Overview of today's clinical load, quick access to OPD queue, agenda, recent patients

**Layout**:
```
┌── Header ───────────────────────────┐
│  "Hello, Dr. [Name]"               │
│  [Date: EEEE, MMM d, yyyy]         │
├────────────────────────────────────┤
│  ┌── Mini Stats Row ──────────────┐ │
│  │  12        5         3       4  │ │
│  │  Today    Done    Queue  Booked │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Quick Action Buttons ────────┐ │
│  │  [Start Encounter] [Add Patient]│ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── OPD Queue ───────────────────┐ │
│  │  Each: dot·time·name··avatar    │ │
│  │  ·status badge, tap → patient   │ │
│  │  Empty: "No patients in queue"  │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Today's Agenda ──────────────┐ │
│  │  Each: type icon·time·name     │ │
│  │  ·appt type·status badge        │ │
│  │  tap → patient detail          │ │
│  │  Empty: "No appointments today" │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Recent Patients ─────────────┐ │
│  │  Horizontal scrollable avatars │ │
│  │  Each: Avatar(name) + name     │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components Used**: `SurfaceCard`, `Avatar`, `Badge`, `Card`, `Button`, `LinearProgressIndicator`
**Data Sources**: `todayAppointmentsProvider(practRef)`, `todayOpdProvider(practRef)`, `allPatientsProvider`

---

### 8.6 Doctor Schedule (Timesheet) — BUILD REFERENCE

**Route**: `/doctor-schedule`
**Role**: Clinician
**Purpose**: Manage availability slots, view weekly/calendar schedule, see appointments

**Layout**:
```
┌── Header ───────────────────────────┐
│  "Schedule"        [i]  [+ Add Slot]│
│  [Today's date label]               │
├────────────────────────────────────┤
│  ┌── Mini Stats Row ──────────────┐ │
│  │  Today  Done  Queue  Book Slots│ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── View Toggle (icon only) ─────┐ │
│  │  [📅 days] [📅]                │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Week View / Calendar View ───┐ │
│  │  Week: arrows + date strip     │ │
│  │  (each tab: day label, number  │ │
│  │   dot if slots exist, count    │ │
│  │   badge on dates with slots)   │ │
│  │  Calendar: full month grid     │ │
│  │  (SizedBox height: auto)       │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── OPD Queue (compact) ─────────┐ │
│  │  Limit 3, "+ N more"           │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Today's Agenda ──────────────┐ │
│  │  Limit 4, "+ N more"           │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Schedule Slots (grouped) ────┐ │
│  │  Header: "Schedule Slots" badge│ │
│  │  Grouped by date:              │ │
│  │  "Wednesday, Jun 25, 2026"     │ │
│  │  Slot card:                    │ │
│  │  clock icon | time range       │ │
│  │  facility | telehealth icon    │ │
│  │  ER override icon              │ │
│  │  N left / booked/total         │ │
│  │  Thin progress bar (color=     │ │
│  │   green/yellow/red by fill)    │ │
│  │  Long-press → delete dialog    │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**What is a Slot? Info Dialog**: Tapping the `[i]` icon shows: "A Schedule Slot represents a block of time when you are available to see patients. Each slot defines: Date & time range, Facility location, Duration per patient, Max patients (capacity), Emergency override toggle, Telehealth option. Patients book appointments within your available slots. You can long-press any slot to delete it."

**Components**: `Calendar`, `DatePicker`, `TimePicker` (all popover mode), `Card`, `Avatar`, `LinearProgressIndicator`, `AlertDialog`
**Data**: `practitionerSlotsProvider(practRef)` via Hive, with `slotRefreshProvider` for invalidation

---

### 8.7 Add / Edit Schedule Entry

**Route**: `/schedule-entry`
**Role**: Clinician
**Purpose**: Create a new availability schedule slot

**Form Fields**:
1. **Date** — `DatePicker(mode: PromptMode.popover)`, disables past dates
2. **Facility** — `Select` dropdown (hardcoded list for now)
3. **Start Time** — `TimePicker(mode: PromptMode.popover)`
4. **End Time** — `TimePicker(mode: PromptMode.popover)` with validation: end must be after start
5. **Slot Duration** — `Chip` toggle: 15m / 30m / 45m / 60m
6. **Buffer Time** — `TextField` number input (minutes)
7. **Emergency Override Toggle** — `Checkbox`
8. **Telehealth Toggle** — `Checkbox`

**Save Behavior**:
- Validates all required fields
- Normalizes `practitionerRef` with `Practitioner/` prefix
- Creates `ScheduleSlotLocal` with `syncStatus = 1`
- Adds to `DatabaseService.scheduleSlots`
- Bumps `slotRefreshProvider`
- Shows success toast
- Pops back to schedule screen after 600ms delay

**Components**: `DatePicker`, `TimePicker`, `Select`, `Chip`, `TextField`, `Checkbox`, `Button`, `SubPageScaffold`

---

### 8.8 Patient Management (Clinician)

**Route**: `/patient-management`
**Role**: Clinician
**Purpose**: Search, browse, and add patients

**Layout**:
```
┌── Search Bar (TextField) ───────────┐
├────────────────────────────────────┤
│  ┌── Patient List ────────────────┐ │
│  │  Each card:                    │ │
│  │  Avatar(name, 40px)           │ │
│  │  Name, Age/Gender              │ │
│  │  Health ID / Last visit        │ │
│  │  → arrow (tap → patient chart) │ │
│  └────────────────────────────────┘ │
│                                      │
│  ╋ + FAB: Add Patient (positioned)  │
└──────────────────────────────────────┘
```

**Add Patient Flow**: Push to add form → Name, DOB, Gender, Phone, Address, Health ID → Save → syncStatus=1 → Back to list

**Components**: `TextField`, `Card`, `Avatar`, `Button`
**Data**: `allPatientsProvider`, `patientRefreshProvider`

---

### 8.9 Patient Chart / EMR Core Screen

**Route**: `/patient-detail/:patientId`
**Role**: Clinician (patient can also view own data)
**Purpose**: Complete patient chart — this is the **core EMR screen**

**Header Section**:
```
┌──────────────────────────────────────┐
│ ← Back                              │
│                                      │
│  [Avatar 56px]  [Name]              │
│  [Age] · [Gender] · [Health ID]     │
│                                      │
│  Allergy Badges: ⚠ Penicillin       │
│  Active Conditions: HTN · DM2        │
│                                      │
│  [Start Encounter] [New Order]       │
└──────────────────────────────────────┘
```

**Tabbed Body** (use Flutter `TabBar` with `TabBarView`):

#### Tab 1: Overview (Summary)
```
┌── Vitals Summary Panel ────────────┐
│  BP: 120/80  HR: 72  SpO2: 98%    │
│  Temp: 98.6°F                      │
│  "Last updated 2h ago"            │
│  [View Full Vitals] link           │
├────────────────────────────────────┤
│  Active Conditions (list)          │
│  Active Medications (list)         │
│  Allergies (list with criticality) │
├────────────────────────────────────┤
│  Recent Encounters (last 3)        │
│  [View All] link                   │
└────────────────────────────────────┘
```

#### Tab 2: Encounters
```
┌── [+ New Encounter] button ────────┐
│  List of encounters:               │
│  Card: date | type | practitioner  │
│  chief complaint | diagnosis       │
│  status badge                      │
│  Tap → encounter workspace         │
└────────────────────────────────────┘
```

#### Tab 3: Vitals
```
┌── Time range selector ────────────┐
│  [24h] [7d] [30d] [All]           │
├────────────────────────────────────┤
│  ┌── Chart area ─────────────────┐ │
│  │  BP chart (line, systolic +   │ │
│  │  diastolic)                    │ │
│  │  HR chart (line)               │ │
│  │  SpO2 chart (line)             │ │
│  │  Temp chart (line)             │ │
│  └────────────────────────────────┘ │
├────────────────────────────────────┤
│  ┌── Vitals Table ───────────────┐ │
│  │  Date | Time | BP | HR | SpO2  │ │
│  │  ...rows...                    │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

#### Tab 4: Labs
```
┌── [+ Order Lab] button ────────────┐
│  Filter: [All] [Pending] [Results] │
│  Lab cards grouped by date:        │
│  Test name | value | range | flag  │
│  (normal/high/low indicators)      │
│  Status: "Pending" or "Completed"  │
└──────────────────────────────────────┘
```

#### Tab 5: Medications
```
┌── [+ Prescribe] button ───────────┐
├────────────────────────────────────┤
│  Active Medications:               │
│  Card: drug name (RxNorm code)     │
│  dose · frequency · route          │
│  prescriber · start date           │
│  [Stop] [Renew] actions            │
├────────────────────────────────────┤
│  Medication History (collapsible)  │
│  Past medications list             │
└──────────────────────────────────────┘
```

#### Tab 6: Imaging / Reports
```
┌── Diagnostic Reports: ────────────┐
│  Card: type (CXR / ECG / US)      │
│  date · ordering provider         │
│  conclusion preview (1 line)       │
│  [View Full Report] expandable    │
└────────────────────────────────────┘
```

#### Tab 7: Immunizations
```
┌── [+ Record] button ─────────────┐
│  Card: vaccine (CVX code)         │
│  date administered · lot number   │
│  administering organization        │
└────────────────────────────────────┘
```

**Components**: `Avatar`, `Card`, `Badge`, `Chip`, `Button`, `TabBar`, `TabBarView`, `Divider`, `Skeleton` (loading), `Collapsible`
**Data**: Unified from all FHIR resources filtered by patientRef

---

### 8.10 Encounter Workspace (SOAP / Clinical Note)

**Route**: `/encounter/:encounterId` or new after "Start Encounter"
**Role**: Clinician
**Purpose**: Document a clinical encounter with SOAP note format, orders, prescriptions

**Layout**:
```
┌── Encounter Header ──────────────┐
│  Patient: [Name]                 │
│  Type: OPD | Emergency | IP      │
│  Attending: [Practitioner]       │
│  Date: [Today]                   │
│  Status: In Progress ✓           │
└─────────────────────────────────┘

┌── Sections (scrollable) ─────────┐
│                                   │
│  S — Subjective:                  │
│  ┌── Chief Complaint ───────────┐ │
│  │  TextField (multi-line)       │ │
│  └──────────────────────────────┘ │
│  ┌── History of Present Illness ┐ │
│  │  TextArea (4 lines)           │ │
│  └──────────────────────────────┘ │
│                                   │
│  O — Objective:                   │
│  ┌── Vitals Input ──────────────┐ │
│  │  Row of TextFields:           │ │
│  │  BP [120/80]  HR [72]        │ │
│  │  SpO2 [98]   Temp [98.6]     │ │
│  │  [+ Add More Vitals]         │ │
│  └──────────────────────────────┘ │
│  ┌── Physical Exam ─────────────┐ │
│  │  Chips: CVS | Resp | GI      │ │
│  │  | Neuro | MSK | ...          │ │
│  │  Each chip opens text field   │ │
│  └──────────────────────────────┘ │
│                                   │
│  A — Assessment:                  │
│  ┌── Diagnoses ─────────────────┐ │
│  │  [+ Add Diagnosis]           │ │
│  │  Search ICD-10 / SNOMED      │ │
│  │  Each: code + description +  │ │
│  │  type (Primary/Secondary)    │ │
│  │  swipe to delete              │ │
│  └──────────────────────────────┘ │
│                                   │
│  P — Plan:                        │
│  ┌── Orders ────────────────────┐ │
│  │  [+ Medication Order]        │ │
│  │  [+ Lab Order]               │ │
│  │  [+ Imaging Order]           │ │
│  │  [+ Referral]                │ │
│  │  Each order card with icon   │ │
│  └──────────────────────────────┘ │
│  ┌── Follow-up ─────────────────┐ │
│  │  DatePicker + notes TextField│ │
│  └──────────────────────────────┘ │
│                                   │
│  [Save Draft]  [Complete Encounter]│
│  (two buttons at bottom)          │
└────────────────────────────────────┘
```

**Components**: `TextField`, `TextArea`, `Chip`, `Button`, `DatePicker`, `Select`, `Card`, `Collapsible`
**Data**: Creates/updates `Encounter` FHIR resource, linked conditions, medication requests, etc.
**Note**: This screen is the most complex — it's the core clinical documentation tool.

---

### 8.11 Telemedicine

**Route**: `/telemedicine`
**Role**: Both (Patient books, Clinician hosts)
**Purpose**: Browse and book virtual consultations with specialists

**Layout**:
```
┌── Search / Filter ─────────────────┐
│  Specialty dropdown + search bar    │
├────────────────────────────────────┤
│  ┌── Specialist Cards ────────────┐ │
│  │  Each:                         │ │
│  │  Avatar(56px)                  │ │
│  │  Name · Specialty · Rating     │ │
│  │  Next available slot time      │ │
│  │  [Book Video Consult] button   │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── My Upcoming Telemedicine ─────┐ │
│  │  Card: doctor, date, time       │ │
│  │  [Join Call] button             │ │
│  │  (disabled if >15min early)     │ │
│  └────────────────────────────────┘ │
│  ┌── Past Telemedicine Calls ─────┐ │
│  │  List of completed calls       │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components**: `Avatar`, `Card`, `Button`, `Select`, `TextField`, `StarRating`, `Badge`

---

### 8.12 Ambulance Request

**Route**: `/ambulance`
**Role**: Both
**Purpose**: Request emergency ambulance service

**Layout**:
```
┌── Emergency Header (red bg) ──────┐
│  "🚨 In life-threatening emergency,│
│   call 102 immediately"            │
├────────────────────────────────────┤
│  ┌── Request Form ────────────────┐ │
│  │  Patient Name (auto-filled)    │ │
│  │  Contact Phone (input)         │ │
│  │  Pickup Location (text input)  │ │
│  │  Emergency Type (dropdown):    │ │
│  │    Cardiac | Trauma | Resp |   │ │
│  │    OB | Other                  │ │
│  │  Notes (TextArea, optional)    │ │
│  │                                │ │
│  │  [Request Ambulance] button    │ │
│  │  (full width, destructive)     │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── Active / Tracked Requests ────┐ │
│  │  Card: status badge             │ │
│  │  driver name, estimated ETA     │ │
│  │  [Track] button                 │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components**: `Card`, `TextField`, `TextArea`, `Select`, `Button`, `Badge`, `Divider`

---

### 8.13 Health Tips

**Route**: `/health-tips`
**Role**: Both
**Purpose**: Browse health articles organized by category

**Layout**:
```
┌── Category Chips (scrollable) ─────┐
│  [All] [Cardiology] [Diabetes]     │
│  [Nutrition] [Mental Health]       │
│  [Seasonal] [... more]             │
├────────────────────────────────────┤
│  ┌── Article Cards ───────────────┐ │
│  │  Each:                         │ │
│  │  Icon (category related)       │ │
│  │  Title (w700, 14px)            │ │
│  │  Author + Date (caption)       │ │
│  │  Summary (2 lines, muted)      │ │
│  │  Tap → full article view       │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Full Article View**: Title, author, date, full content body (scrollable)
**Components**: `Chip`, `Card`, `Icon`, `Text`
**Data**: `healthTipProvider` from Hive

---

### 8.14 Insurance Claims

**Route**: `/insurance`
**Role**: Patient
**Purpose**: Submit and track insurance claims

**Layout**:
```
┌── [+ New Claim] button ───────────┐
├────────────────────────────────────┤
│  Tabs: [Pending] [Approved] [Rej.]  │
│                                      │
│  Each claim card:                   │
│  ┌──────────────────────────────┐  │
│  │  Insurance provider name     │  │
│  │  Policy number               │  │
│  │  Amount: $X,XXX              │  │
│  │  Type: Outpatient/Emergency  │  │
│  │  Submitted: [date]           │  │
│  │  Status badge (color-coded)  │  │
│  └────────────────────────────────┘  │
│                                      │
│  Empty state per tab                 │
└──────────────────────────────────────┘
```

**New Claim Form**: Patient reference (auto), claim type dropdown, provider name, policy number, amount, description (TextArea), attach evidence (file upload placeholder)
**Components**: `Card`, `Button`, `Select`, `TextField`, `TextArea`, `Badge`, `TabBar`

---

### 8.15 Lab Bookings

**Route**: `/lab-booking`
**Role**: Patient
**Purpose**: Book lab tests at available laboratories

**Layout**:
```
┌── [+ Book Lab Test] button ────────┐
├────────────────────────────────────┤
│  ┌── Available Labs ──────────────┐ │
│  │  Each: name, address, phone    │ │
│  │  available tests (chips)       │ │
│  │  Tap → select tests            │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌── My Lab Bookings ─────────────┐ │
│  │  Each: lab name                │ │
│  │  tests (chips)                 │ │
│  │  date/time scheduled           │ │
│  │  status badge                  │ │
│  │  total price                   │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Booking Flow**: Select lab → Select tests from available test list → Choose date/time → Confirm → Create `LabBooking` with syncStatus=1
**Components**: `Card`, `Button`, `Chip`, `Select`, `Badge`, `DatePicker`, `TimePicker`

---

### 8.16 Notifications

**Route**: `/notifications`
**Role**: Both
**Purpose**: View and manage in-app notifications

**Layout**:
```
┌── [Mark All Read] button ─────────┐
├────────────────────────────────────┤
│  Each notification card:          │
│  ┌──────────────────────────────┐  │
│  │  Icon (type-related)         │  │
│  │  Title (w700)                │  │
│  │  Body (muted, 1-2 lines)     │  │
│  │  Time (relative: "2h ago")   │  │
│  │  Unread indicator (blue dot) │  │
│  │  Tap → navigate to related   │  │
│  │  Long-press → mark read/     │  │
│  │               delete dialog  │  │
│  └──────────────────────────────┘  │
│                                      │
│  Empty: "No notifications"          │
└──────────────────────────────────────┘
```

**Notification Types**: `appointment`, `lab_result`, `prescription`, `verification`, `alert`, `system`, `patient_assignment`
**Components**: `Card`, `Icon`, `Button`, `AlertDialog`
**Data**: `notification_by_user_provider`

---

### 8.17 Profile & Settings

**Route**: `/profile`
**Role**: Both
**Purpose**: Account management, sync toggle, password change, logout

**Layout**:
```
┌── Profile Header ──────────────────┐
│  Avatar(64px)                     │
│  Display Name                     │
│  Email                            │
│  [Edit Profile] link               │
├────────────────────────────────────┤
│  ┌── Settings List ──────────────┐ │
│  │  Role Switcher (if multi-role)│ │
│  │  [Patient/Clinician] radio    │ │
│  │                               │ │
│  │  ┌── Cloud Sync ────────────┐ │ │
│  │  │  Toggle: Enable/Disable   │ │ │
│  │  │  Last sync: [timestamp]   │ │ │
│  │  │  Pending: [N] items       │ │ │
│  │  │  [Sync Now] button        │ │ │
│  │  └───────────────────────────┘ │ │
│  │                               │ │
│  │  ┌── Change Password ────────┐ │ │
│  │  │  Current password field   │ │ │
│  │  │  New password field       │ │ │
│  │  │  Confirm field            │ │ │
│  │  │  [Update] button          │ │ │
│  │  └───────────────────────────┘ │ │
│  │                               │ │
│  │  ┌── Notifications ──────────┐ │ │
│  │  │  Toggle: Appointment rem. │ │ │
│  │  │  Toggle: Lab results      │ │ │
│  │  │  Toggle: Alerts           │ │ │
│  │  └───────────────────────────┘ │ │
│  │                               │ │
│  │  About: version, licenses     │ │
│  └────────────────────────────────┘ │
│                                      │
│  Button: Logout (destructive)        │
└──────────────────────────────────────┘
```

**Components**: `Avatar`, `Switch`, `Button`, `TextField`, `Divider`, `Card`, `SurfaceCard`
**Data**: `syncProvider` for toggle and status, `authProvider` for user info

---

### 8.18 Hospitals Directory

**Route**: `/hospitals`
**Role**: Both
**Purpose**: Browse hospitals and healthcare facilities

**Layout**:
```
┌── Search + Filter ────────────────┐
│  TextField(search)                 │
│  Chips: [All] [Government] [Priv.] │
├────────────────────────────────────┤
│  ┌── Hospital Cards ─────────────┐ │
│  │  Each:                        │ │
│  │  Hospital name                │ │
│  │  Type badge (Gov/Private)      │ │
│  │  Address, Phone                │ │
│  │  Rating: ⭐⭐⭐⭐ 4.2           │ │
│  │  Badges: 24/7 🏥 Emergency    │ │
│  │  Departments (chips)          │ │
│  │  Tap → detail with map        │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**Components**: `TextField`, `Chip`, `Card`, `Badge`, `StarRating`

---

### 8.19 Consent Management

**Route**: `/consent`
**Role**: Patient
**Purpose**: View and manage FHIR Consent resources for data sharing

**Layout**:
```
┌── Active Consents ─────────────────┐
│  Each consent card:                │
│  ┌──────────────────────────────┐  │
│  │  Practitioner: [Name]       │  │
│  │  Scope: Patient Privacy     │  │
│  │  Date granted: [date]       │  │
│  │  Status: Active              │  │
│  │  [Revoke] button             │  │
│  └──────────────────────────────┘  │
├────────────────────────────────────┤
│  [+ Grant New Consent] button      │
│  Form: select practitioner,        │
│  select data categories, confirm   │
└──────────────────────────────────────┘
```

**Components**: `Card`, `Button`, `Select`, `Checkbox`, `DatePicker`

---

### 8.20 Signup / Login / Onboarding

**Routes**: `/login`, `/signup`
**Role**: New user
**Purpose**: Create account, email verification, complete profile

**Login Screen**:
```
┌─────────────────────────────────────┐
│  Logo / App icon                    │
│  "Clinical Curator"                 │
│                                     │
│  TextField: Email                   │
│  TextField: Password (obscured)     │
│                                     │
│  Button.primary: "Sign In"          │
│                                     │
│  TextButton: "Don't have an account?│
│              Create one"            │
│                                     │
│  TextButton: "Forgot password?"     │
└─────────────────────────────────────┘
```

**Signup Flow**:
1. `startRegistration` API call → returns requestId
2. Show "Enter verification code sent to your email" screen
3. `verifyRegistrationCode` → returns registrationToken
4. `finishRegistration(registrationToken, password)` → returns AuthSuccess with JWT

**Profile Completion (after signup)**:
- Name, DOB, Gender, Health ID (optional)
- Role: Patient or Practitioner
- If Practitioner: license number, specialty, hospital
- → Creates `UserAccount` locally, redirects to appropriate home

**Components**: `TextField`, `Button`, `TextButton`, `Avatar`
**Serverpod Auth Endpoints**: `emailIdp/startRegistration`, `emailIdp/verifyRegistrationCode`, `emailIdp/finishRegistration`, `emailIdp/login`

---

## 9. Admin App Specifications

**Location**: `apps/admin/`
**Role**: Admin only
**Shell**: No bottom nav — uses go_router with nested routes

### 9.1 Admin Dashboard
```
┌── Stats Overview ──────────────────┐
│  4 stat cards:                     │
│  Total Users | Practitioners      │
│  Pending Verifications | Orgs      │
├────────────────────────────────────┤
│  Quick actions:                    │
│  [Manage Users] [Pending Verif.]   │
│  [Organizations] [Audit Log]       │
│  [RBAC Permissions]                │
└────────────────────────────────────┘
```

### 9.2 Practitioner Verification
```
┌── Pending Verifications List ─────┐
│  Each: name, email, specialty,    │
│  license#, submitted date          │
│  [Approve] [Reject] buttons        │
├────────────────────────────────────┤
│  Verified Practitioners tab        │
│  List with search + filter         │
└────────────────────────────────────┘
```

### 9.3 User Management
```
┌── Search ──────────────────────────┐
│  Table/user list:                  │
│  Name | Email | Role | Status      │
│  [Edit] [Verify] [Deactivate]       │
└────────────────────────────────────┘
```

### 9.4 RBAC Permissions
```
┌── Role: Permission Matrix ────────┐
│  Roles as rows, permissions as    │
│  columns, checkboxes at          │
│  intersections                    │
│  [Save Permissions] button        │
└────────────────────────────────────┘
```

### 9.5 Organization Management
```
┌── Tabs: [Hospitals] [Pharmacies] ─┐
│  CRUD: create, edit, delete        │
│  Form: name, type, address,       │
│  phone, rating, hours, services   │
└────────────────────────────────────┘
```

### 9.6 Audit Log
```
┌── Filters ─────────────────────────┐
│  Date range, action type, user     │
├────────────────────────────────────┤
│  Table: timestamp, user, action,   │
│  resource type, details            │
│  Paginated                         │
└────────────────────────────────────┘
```

---

## 10. Data Flow & State Patterns

### 10.1 Offline-First Writes
Every create/update/delete follows this pattern:
```
1. Create/modify local Hive object
2. Set syncStatus = 1 (0 = synced, 1 = pending upload, 2 = pending delete)
3. Save to Hive box
4. Bump the relevant refreshProvider (e.g., slotRefreshProvider)
5. Show success toast
6. Navigate back (if applicable)
```

### 10.2 Read Pattern
```
Provider.family<List<ItemType>, String>((ref, filter) {
  ref.watch(refreshProvider);
  final box = DatabaseService.items;
  return box.values.where(...).toList()..sort(...);
});
```

### 10.3 Provider Naming Convention
| Refresh Provider | Watched By |
|---|---|
| `patientRefreshProvider` | `allPatientsProvider` |
| `appointmentRefreshProvider` | `practitionerAppointmentsProvider`, `todayAppointmentsProvider`, `todayOpdProvider` |
| `slotRefreshProvider` | `practitionerSlotsProvider` |

### 10.4 Sync Behavior
- Sync is **optional** — user can toggle on/off in Profile Settings
- `SyncNotifier.toggleSync(bool)` → persists via SharedPreferences
- `SyncNotifier.syncAll()` → skipped if sync disabled or offline
- Sync pushes FHIR resources and schedule slots with syncStatus != 0
- Sync pulls server changes via FHIR `getChangesSince(since)` for FHIR resources

### 10.5 Login Auth Flow (Two Layers)
1. **Serverpod IDP** → `emailIdp/login` → Argon2 password hash → returns JWT
2. **Custom auth** → `auth/login` → bcrypt password hash → returns UserAccount from `user_accounts` table
- The client calls `emailIdp/login` first, then `auth/login` to get the full user profile

---

## 11. File Organization

```
apps/clinical/lib/
├── main.dart                    # Entry point
├── app.dart                     # ShadcnApp.router + theme
├── core/
│   ├── network/
│   │   └── sync_service.dart    # FHIR + schedule sync service
│   └── router/
│       └── app_router.dart      # GoRouter with shells
├── domain/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── serverpod_provider.dart
│   │   └── connectivity_provider.dart
│   └── services/
│       └── audit_logger.dart
└── features/
    ├── auth/screens/            # Login, signup, practitioner registration
    ├── ambulance/screens/       # Ambulance request + tracking
    ├── booking/screens/         # Appointment booking + reschedule
    ├── clinical/screens/        # Encounter workspace
    ├── consent/screens/         # Consent management
    ├── doctor_dashboard/screens/ # Doctor dashboard
    ├── doctor_schedule/screens/  # Timesheet + schedule entry
    ├── health_tips/screens/     # Articles library
    ├── help/screens/            # Help center
    ├── hospitals/screens/       # Hospital directory
    ├── insurance/screens/       # Insurance claims
    ├── lab_booking/screens/     # Lab bookings
    ├── medical_records/screens/ # Patient records view
    ├── notifications/screens/   # Notifications
    ├── onboarding/screens/      # Onboarding wizard
    ├── patient_chart/screens/   # Patient chart (EMR core)
    ├── patient_detail/screens/  # Patient detail
    ├── patient_home/screens/    # Patient home dashboard
    ├── patient_management/screens/ # Patient list + add
    ├── pharmacy/screens/        # Pharmacy orders
    ├── profile/screens/         # Profile & settings
    ├── shared/
    │   ├── screens/             # Shared screens (services hub)
    │   └── widgets/             # Reusable widgets (sync_chip, etc.)
    └── telemedicine/screens/    # Telemedicine

packages/
├── core/lib/                    # cc_core — design tokens, theme, config, router
├── data/lib/                    # cc_data — Hive DB, providers, repositories, sync
├── fhir_models/lib/             # cc_fhir_models — Hive collections, AppUser, enums
└── rbac/lib/                    # cc_rbac — can widget, role-based access
```

---

## 12. Implementation Priority Order

| Priority | Screen | Complexity | Existing |
|---|---|---|---|
| 1 | **Patient Chart / EMR** (tabbed: overview, encounters, vitals, labs, meds, imaging, immunizations) | Very High | 🟡 Partial |
| 2 | **Encounter Workspace** (SOAP note, orders, prescriptions) | Very High | ❌ Missing |
| 3 | **Patient Management** (list, search, add patient) | Medium | 🟡 Partial |
| 4 | **Doctor Dashboard** (stats, queue, agenda, recent patients) | Medium | 🟡 Partial |
| 5 | **Telemedicine** (specialist search, book, call) | Medium | ❌ Missing |
| 6 | **Ambulance Request** (form + tracking) | Low | 🟡 Partial |
| 7 | **Pharmacy Orders** (order flow) | Medium | ❌ Missing |
| 8 | **Lab Bookings** | Low | 🟡 Partial |
| 9 | **Insurance Claims** | Low | 🟡 Partial |
| 10 | **Consents** | Low | 🟡 Partial |
| 11 | **Hospitals Directory** | Low | 🟡 Partial |
| 12 | **Profile with Sync Toggle** | Low | 🟡 Partial |
| 13 | **Notifications** | Low | 🟡 Partial |
| 14 | **Health Tips** | Low | ✅ Complete |
| 15 | **Doctor Schedule** | Medium | ✅ Complete |
| 16 | **Admin App** (verification, RBAC, orgs, audit) | High | ❌ Missing |
| 17 | **Signup/Onboarding** improvement | Medium | 🟡 Partial |

---

## 13. Authored Screens References

The following screens have been implemented and can be used as reference for component patterns:

| Screen | File | Status |
|---|---|---|
| Doctor Schedule (Timesheet) | `apps/clinical/lib/features/doctor_schedule/screens/schedule_timesheet_screen.dart` | ✅ Complete |
| Add Schedule Entry | `apps/clinical/lib/features/doctor_schedule/screens/schedule_entry_screen.dart` | ✅ Complete |
| Login Screen | `apps/clinical/lib/features/auth/screens/login_screen.dart` | ✅ Complete |
| Doctor Dashboard | `apps/clinical/lib/features/doctor_dashboard/screens/doctor_dashboard_screen.dart` | 🟡 Needs EMR integration |
| Patient Home | `apps/clinical/lib/features/patient_home/screens/patient_home_screen.dart` | 🟡 Needs refinement |
| Sync Service | `apps/clinical/lib/core/network/sync_service.dart` | ✅ Complete |

---

*End of Specification Document. Total: 20 patient/clinician screens + 6 admin screens = 26 screen specifications.*