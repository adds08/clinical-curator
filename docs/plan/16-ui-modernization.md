# Phase 5: UI Modernization — ultimate_grid + Dashboards

**Status:** 🔴 Not started
**Priority:** P2 — UX improvement
**Effort:** ~2 weeks
**Depends on:** Phase 1 (FHIR API), Phase 2 (patient chart data exists)

## Objective

Replace current `ListView`/`Card` patterns with `ultimate_grid` data tables for sortable, filterable, paginated views. Modernize dashboards with actionable widgets.

## Dependency: ultimate_grid

```yaml
# apps/clinical/pubspec.yaml additions
dependencies:
  ultimate_grid: ^0.1.0+3
```

`ultimate_grid` provides: column sorting, filtering, pagination, column resizing, row selection, cell formatting, export hooks.

## 5A: ultimate_grid Tables

### Patient Directory

```dart
// apps/clinical/lib/features/patient_management/widgets/patient_grid.dart

class PatientGrid extends ConsumerStatefulWidget {
  @override
  ConsumerState<PatientGrid> createState() => _PatientGridState();
}

class _PatientGridState extends ConsumerState<PatientGrid> {
  late final UltraDataGridController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UltraDataGridController(
      columns: [
        GridColumn(field: 'name', title: 'Name', width: 200),
        GridColumn(field: 'mrn', title: 'MRN', width: 120),
        GridColumn(field: 'gender', title: 'Gender', width: 80),
        GridColumn(field: 'birthDate', title: 'DOB', width: 110),
        GridColumn(field: 'lastVisit', title: 'Last Visit', width: 120),
        GridColumn(field: 'status', title: 'Status', width: 100),
      ],
      pageSize: 50,
      serverSide: true, // Fetch from FHIR API
    );
  }

  @override
  Widget build(BuildContext context) {
    return UltraDataGrid<Map<String, dynamic>>(
      controller: _controller,
      onPageRequest: (page, sort, filters) async {
        // Build FHIR search params from grid state
        final params = <String, String>{
          '_count': page.pageSize.toString(),
          '_offset': ((page.pageIndex - 1) * page.pageSize).toString(),
        };
        // Map grid sort → FHIR _sort
        if (sort.direction != null) {
          params['_sort'] = '${sort.direction == SortDirection.asc ? '' : '-'}${sort.column!.field}';
        }
        // Map grid filters → FHIR search params
        for (final filter in filters) {
          params[filter.column!.field] = filter.value;
        }

        final bundle = await ref.read(fhirApiProvider).search('Patient', params);
        return PageResponse(
          items: bundle.entries.map((e) => e['resource']).toList(),
          totalCount: bundle['total'],
        );
      },
      rowBuilder: (patient) => DataGridRow(cells: [
        DataGridCell(value: _fullName(patient)),
        DataGridCell(value: _extractMrn(patient)),
        DataGridCell(value: patient['gender']),
        DataGridCell(value: patient['birthDate']),
        DataGridCell(value: _lastVisit(patient)),
        DataGridCell(value: patient['active'] == true ? 'Active' : 'Inactive'),
      ]),
      onRowTap: (patient) => context.push('/patient/${patient['id']}'),
    );
  }
}
```

### Lab Results Table

```dart
// apps/clinical/lib/features/patient_chart/tabs/results_tab.dart

UltraDataGrid<Map<String, dynamic>>(
  controller: UltraDataGridController(
    columns: [
      GridColumn(field: 'name', title: 'Test', width: 200),
      GridColumn(field: 'value', title: 'Value', width: 120),
      GridColumn(field: 'unit', title: 'Unit', width: 80),
      GridColumn(field: 'referenceRange', title: 'Reference', width: 120),
      GridColumn(field: 'status', title: 'Flag', width: 80,
        cellBuilder: (ctx, cell) {
          final val = cell.value as String;
          final color = val == 'H' ? Colors.red
              : val == 'L' ? Colors.amber
              : Colors.green;
          return Badge(color: color, child: Text(val));
        },
      ),
      GridColumn(field: 'effectiveDate', title: 'Date', width: 120),
      GridColumn(field: 'action', title: '', width: 60,
        cellBuilder: (ctx, cell) => IconButton(
          icon: const Icon(Icons.trending_up, size: 16),
          onPressed: () => _showTrend(cell.rowData),
        ),
      ),
    ],
    pageSize: 25,
  ),
  onPageRequest: (page, sort, _) async {
    final bundle = await ref.read(fhirApiProvider).search('Observation', {
      'patient': 'Patient/$patientFhirId',
      'category': 'laboratory',
      '_count': page.pageSize.toString(),
      '_offset': ((page.pageIndex - 1) * page.pageSize).toString(),
    });
    return PageResponse(
      items: bundle.entries.map((e) {
        final obs = e['resource'];
        return {
          'name': obs['code']?['coding']?[0]?['display'],
          'value': obs['valueQuantity']?['value']?.toString(),
          'unit': obs['valueQuantity']?['unit'],
          'referenceRange': _formatRefRange(obs['referenceRange']),
          'flag': _interpretFlag(obs),
          'effectiveDate': obs['effectiveDateTime'],
          'fullData': obs,
        };
      }).toList(),
      totalCount: bundle['total'],
    );
  },
);
```

### Medication List

```dart
UltraDataGrid<Map<String, dynamic>>(
  columns: [
    GridColumn(field: 'drug', title: 'Drug', width: 180),
    GridColumn(field: 'dose', title: 'Dose', width: 100),
    GridColumn(field: 'route', title: 'Route', width: 80),
    GridColumn(field: 'frequency', title: 'Frequency', width: 100),
    GridColumn(field: 'prescriber', title: 'Prescriber', width: 140),
    GridColumn(field: 'startDate', title: 'Started', width: 110),
    GridColumn(field: 'status', title: 'Status', width: 100),
  ],
  pageSize: 50,
  onPageRequest: (page, sort, _) => /* FHIR MedicationRequest search */,
);
```

### Appointments Table

```dart
UltraDataGrid<Map<String, dynamic>>(
  columns: [
    GridColumn(field: 'date', title: 'Date', width: 100),
    GridColumn(field: 'time', title: 'Time', width: 80),
    GridColumn(field: 'patient', title: 'Patient', width: 160),
    GridColumn(field: 'type', title: 'Type', width: 120),
    GridColumn(field: 'status', title: 'Status', width: 100),
    GridColumn(field: 'action', title: '', width: 120,
      cellBuilder: (ctx, cell) => Row(children: [
        ActionChip(label: const Text('Check In'), onPressed: () => _checkIn(cell.rowData)),
        const SizedBox(width: 4),
        ActionChip(label: const Text('Cancel'), onPressed: () => _cancel(cell.rowData)),
      ]),
    ),
  ],
);
```

### Audit Log Table (Admin)

```dart
UltraDataGrid<Map<String, dynamic>>(
  columns: [
    GridColumn(field: 'timestamp', title: 'Timestamp', width: 150),
    GridColumn(field: 'user', title: 'User', width: 150),
    GridColumn(field: 'action', title: 'Action', width: 100),
    GridColumn(field: 'resource', title: 'Resource', width: 200),
    GridColumn(field: 'outcome', title: 'Outcome', width: 80),
    GridColumn(field: 'detail', title: 'Detail', width: 250),
  ],
  pageSize: 100,
);
```

## 5B: Dashboard Redesign

### Clinician Dashboard

```
┌──────────────────────────────────────────────────────────────┐
│ Good Morning, Dr. Sharma                   🔔 3    ⚙️ [Logout]│
├─────────────┬────────────────┬───────────────┬────────────────┤
│ My Queue    │ Today's Appts  │ Pending Orders│ Abnormal Labs  │
│ ┌──────────┐│ ┌─────────────┐│ ┌───────────┐ │ ┌────────────┐ │
│ │ Ram B.    ││ │ 09:00 S. Rai││ │ Lab: CBC  │ │ │ K+ 5.8     │ │
│ │ (Check-in)││ │ 09:30 A. Tam││ │ Rx: Amox  │ │ │ (H)        │ │
│ │           ││ │ 10:00 P. Gur││ │           │ │ │            │ │
│ │ Sunita    ││ │ 10:30 B. Shr││ │ Lab: Lipid│ │ │ Creat 2.1  │ │
│ │ (Waiting) ││ │             ││ │ (pending) │ │ │ (H)        │ │
│ │           ││ │ 11:00 K. Ra││ │           │ │ │            │ │
│ │ Bikesh M. ││ │             ││ │           │ │ │            │ │
│ │ (In Room) ││ │             ││ │           │ │ │            │ │
│ └──────────┘│ └─────────────┘│ └───────────┘ │ └────────────┘ │
├─────────────┴────────────────┴───────────────┴────────────────┤
│ Recent Activity    [ultimate_grid audit rows]                  │
└──────────────────────────────────────────────────────────────┘
```

```dart
// apps/clinical/lib/features/dashboard/widgets/clinician_dashboard.dart

class ClinicianDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top row: 4 stat cards
            Row(children: [
              Expanded(child: _StatCard(
                title: 'My Queue', icon: Icons.people,
                loading: _queueAsync.isLoading,
                child: _QueueList(patients: _queueAsync.valueOrNull ?? []),
              )),
              const SizedBox(width: 16),
              Expanded(child: _StatCard(
                title: "Today's Appointments", icon: Icons.calendar_today,
                child: _AppointmentList(appointments: _todayApps),
              )),
              const SizedBox(width: 16),
              Expanded(child: _StatCard(
                title: 'Pending Orders', icon: Icons.receipt_long,
                child: _OrderList(orders: _pendingOrders),
              )),
              const SizedBox(width: 16),
              Expanded(child: _StatCard(
                title: 'Abnormal Labs', icon: Icons.warning_amber,
                color: colors.destructive,
                child: _AbnormalLabList(labs: _abnormalLabs),
              )),
            ]),
            const SizedBox(height: 24),
            // Bottom row: Activity feed
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 300,
                    child: AuditGrid(), // ← ultimate_grid
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Patient Dashboard

```dart
// apps/clinical/lib/features/patient_home/widgets/patient_dashboard.dart

Column(
  children: [
    // Welcome card with next appointment
    _WelcomeCard(
      name: patient.displayName,
      nextAppointment: _nextAppointment,
    ),
    Row(children: [
      // Upcoming appointments (2 cols)
      Expanded(child: _UpcomingAppointmentsCard(appointments: _appointments)),
      const SizedBox(width: 16),
      // Medication today
      Expanded(child: _MedicationTodayCard(medications: _todayMeds)),
    ]),
    const SizedBox(height: 16),
    Row(children: [
      // Recent lab results
      Expanded(child: _RecentLabsCard(labs: _recentLabs)),
      const SizedBox(width: 16),
      // Health tips
      Expanded(child: _HealthTipsCard(tips: _tips)),
    ]),
  ],
);
```

### Admin Dashboard Expand

```dart
// apps/admin/lib/features/admin/screens/admin_dashboard_screen.dart
// Enhance existing dashboard with ultimate_grid for user table and audit log

// Replace current _StatCard with data-linked cards:
_StatCard(
  label: 'Patients',
  value: '${snapshot['totalPatients'] ?? 0}',
  trend: _patientTrend, // +12% this month
  onTap: () => context.push('/admin/users?type=patient'),
),
```

## 5C: Responsive Layout

```dart
// apps/clinical/lib/core/utils/responsive.dart — extend existing

/// Desktop breakpoint utilities.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return desktop;
    if (width >= 768) return tablet ?? mobile;
    return mobile;
  }
}

// Usage in patient chart:
ResponsiveLayout(
  mobile: SingleChildScrollView(child: _tabsContent),  // Stacked tabs
  tablet: Row(children: [_tabBar, Expanded(child: _tabsContent)]), // Sidebar
  desktop: Row(children: [_wideSidebar, Expanded(child: _tabsContent), _quickActionsPanel]),
)
```

## Files to Create

| File | Purpose |
|------|---------|
| `apps/clinical/lib/features/dashboard/widgets/clinician_dashboard.dart` | Redesigned clinician dashboard |
| `apps/clinical/lib/features/patient_home/widgets/patient_dashboard.dart` | Redesigned patient dashboard |
| `apps/clinical/lib/features/patient_management/widgets/patient_grid.dart` | ultimate_grid patient directory |
| `apps/clinical/lib/features/patient_chart/tabs/results_tab.dart` | ultimate_grid lab results |
| `apps/clinical/lib/features/patient_chart/tabs/medication_tab.dart` | ultimate_grid medications |
| `apps/clinical/lib/features/patient_chart/tabs/order_list_tab.dart` | ultimate_grid orders |
| `apps/admin/lib/features/admin/widgets/audit_grid.dart` | ultimate_grid audit log |
| `apps/admin/lib/features/admin/widgets/user_grid.dart` | ultimate_grid user management |
| `apps/clinical/pubspec.yaml` | Add `ultimate_grid: ^0.1.0+3` |
| `apps/admin/pubspec.yaml` | Add `ultimate_grid: ^0.1.0+3` |