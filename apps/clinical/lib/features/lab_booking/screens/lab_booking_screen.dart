import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_data/database/isar_service.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_fhir_models/collections/lab_booking_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

class _LabTest {
  final String name;
  final String category;
  final String price;
  final String turnaround;
  final bool fastingRequired;
  const _LabTest({required this.name, required this.category, required this.price, required this.turnaround, this.fastingRequired = false});
}

class LabBookingScreen extends ConsumerStatefulWidget {
  const LabBookingScreen({super.key});

  @override
  ConsumerState<LabBookingScreen> createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends ConsumerState<LabBookingScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';
  final _cart = <_LabTest>[];

  static const _tests = [
    _LabTest(name: 'Complete Blood Count (CBC)', category: 'Hematology', price: 'Rs. 500', turnaround: '4 hrs'),
    _LabTest(name: 'Full Lipid Panel', category: 'Biochemistry', price: 'Rs. 1,200', turnaround: '6 hrs', fastingRequired: true),
    _LabTest(name: 'HbA1c (Glycated Hemoglobin)', category: 'Diabetes', price: 'Rs. 800', turnaround: '24 hrs', fastingRequired: true),
    _LabTest(name: 'Thyroid Panel (TSH, T3, T4)', category: 'Endocrinology', price: 'Rs. 1,500', turnaround: '24 hrs'),
    _LabTest(name: 'Liver Function Test (LFT)', category: 'Biochemistry', price: 'Rs. 900', turnaround: '6 hrs', fastingRequired: true),
    _LabTest(name: 'Kidney Function Test (KFT)', category: 'Biochemistry', price: 'Rs. 850', turnaround: '6 hrs'),
    _LabTest(name: 'Urine Routine & Microscopy', category: 'Pathology', price: 'Rs. 300', turnaround: '2 hrs'),
    _LabTest(name: 'Dengue NS1 Antigen', category: 'Serology', price: 'Rs. 1,000', turnaround: '4 hrs'),
    _LabTest(name: 'COVID-19 RT-PCR', category: 'Molecular', price: 'Rs. 1,500', turnaround: '24 hrs'),
    _LabTest(name: 'Vitamin D (25-OH)', category: 'Biochemistry', price: 'Rs. 1,200', turnaround: '48 hrs'),
    _LabTest(name: 'Iron Studies (Fe, TIBC, Ferritin)', category: 'Hematology', price: 'Rs. 1,400', turnaround: '24 hrs', fastingRequired: true),
    _LabTest(name: 'ESR (Erythrocyte Sedimentation Rate)', category: 'Hematology', price: 'Rs. 200', turnaround: '2 hrs'),
  ];

  static const _categories = ['All', 'Hematology', 'Biochemistry', 'Diabetes', 'Endocrinology', 'Pathology', 'Serology', 'Molecular'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_LabTest> get _filtered {
    var list = _tests.toList();
    if (_filter != 'All') list = list.where((t) => t.category == _filter).toList();
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) list = list.where((t) => t.name.toLowerCase().contains(q)).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final results = _filtered;

    return SubPageScaffold(
      title: 'Lab Booking',
      trailing: [
        if (_cart.isNotEmpty)
          GestureDetector(
            onTap: () => _showCart(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shoppingCart, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('${_cart.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              placeholder: const Text('Search tests...'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  final active = _filter == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? colors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: active ? colors.primary : colors.border),
                        ),
                        child: Text(c, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : colors.foreground)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ...results.map((t) => _LabTestCard(
              test: t,
              inCart: _cart.contains(t),
              onToggle: () => setState(() {
                if (_cart.contains(t)) { _cart.remove(t); } else { _cart.add(t); }
              }),
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Tests (${_cart.length})', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 16),
            ..._cart.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(t.name, style: TextStyle(fontSize: 14, color: colors.foreground))),
                  Text(t.price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Container(height: 1, color: colors.border),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground)),
                Text('Rs. ${_calculateTotal()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.primary)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () async {
                  final user = ref.read(authProvider).user;
                  final patientRef = user?.fhirPatientId ?? user?.id ?? '';
                  final testsJson = jsonEncode(_cart.map((t) => {'name': t.name, 'price': t.price, 'category': t.category}).toList());

                  final booking = LabBookingLocal()
                    ..patientRef = patientRef
                    ..testsJson = testsJson
                    ..status = 'confirmed'
                    ..totalPrice = _calculateTotal().toDouble()
                    ..scheduledAt = DateTime.now().add(const Duration(days: 1))
                    ..labName = 'Clinical Curator Lab'
                    ..createdAt = DateTime.now()
                    ..syncStatus = 1;

                  await DatabaseService.labBookings.add(booking);

                  if (!context.mounted) return;
                  closeDrawer(ctx);
                  setState(() => _cart.clear());
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: const Text('Booking confirmed! You will receive an SMS with details.'))));
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotal() {
    var total = 0;
    for (final t in _cart) {
      final num = t.price.replaceAll(RegExp(r'[^0-9]'), '');
      total += int.tryParse(num) ?? 0;
    }
    return total;
  }
}

class _LabTestCard extends StatelessWidget {
  final _LabTest test;
  final bool inCart;
  final VoidCallback onToggle;
  const _LabTestCard({required this.test, required this.inCart, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: inCart ? Border.all(color: colors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(test.category, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                    const SizedBox(width: 8),
                    Icon(LucideIcons.clock, size: 12, color: colors.mutedForeground),
                    const SizedBox(width: 2),
                    Text(test.turnaround, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                    if (test.fastingRequired) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: colors.warningBackground, borderRadius: BorderRadius.circular(4)),
                        child: Text('Fasting', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: colors.warning)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(test.price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: inCart ? colors.destructive.withValues(alpha: 0.1) : colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    inCart ? 'Remove' : 'Add',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: inCart ? colors.destructive : colors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
