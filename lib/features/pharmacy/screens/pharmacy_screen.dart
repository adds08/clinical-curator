import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/pharmacy_order_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/organization_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class _Pharmacy {
  final String name;
  final String address;
  final String distance;
  final String hours;
  final bool isOpen;
  final bool hasDelivery;
  final String phone;
  const _Pharmacy({required this.name, required this.address, required this.distance, required this.hours, required this.isOpen, this.hasDelivery = false, required this.phone});
}

class _Medication {
  final String name;
  final String dosage;
  final String price;
  final bool inStock;
  const _Medication({required this.name, required this.dosage, required this.price, this.inStock = true});
}

class PharmacyScreen extends ConsumerStatefulWidget {
  const PharmacyScreen({super.key});

  @override
  ConsumerState<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends ConsumerState<PharmacyScreen> {
  int _tab = 0; // 0 = nearby, 1 = order

  List<_Pharmacy> get _pharmacies {
    final orgs = ref.watch(pharmaciesProvider);
    return orgs.map((o) => _Pharmacy(
      name: o.name,
      address: o.address,
      distance: '',
      hours: o.openHours ?? 'N/A',
      isOpen: o.isOpen24Hours,
      hasDelivery: false,
      phone: o.phone ?? '',
    )).toList();
  }

  static const _medications = [
    _Medication(name: 'Paracetamol 500mg', dosage: 'Strip of 10 tablets', price: 'Rs. 25'),
    _Medication(name: 'Amoxicillin 500mg', dosage: 'Strip of 10 capsules', price: 'Rs. 120'),
    _Medication(name: 'Metformin 500mg', dosage: 'Strip of 10 tablets', price: 'Rs. 45'),
    _Medication(name: 'Omeprazole 20mg', dosage: 'Strip of 10 capsules', price: 'Rs. 80'),
    _Medication(name: 'Cetirizine 10mg', dosage: 'Strip of 10 tablets', price: 'Rs. 35'),
    _Medication(name: 'Azithromycin 500mg', dosage: 'Strip of 3 tablets', price: 'Rs. 150'),
    _Medication(name: 'Losartan 50mg', dosage: 'Strip of 10 tablets', price: 'Rs. 90', inStock: false),
    _Medication(name: 'Ibuprofen 400mg', dosage: 'Strip of 10 tablets', price: 'Rs. 30'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SubPageScaffold(
      title: 'Pharmacy',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: _TabBtn(label: 'Nearby', active: _tab == 0, onTap: () => setState(() => _tab = 0))),
                  Expanded(child: _TabBtn(label: 'Order Medicines', active: _tab == 1, onTap: () => setState(() => _tab = 1))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_tab == 0) ..._pharmacies.map((p) => _PharmacyCard(pharmacy: p))
            else ..._medications.map((m) => _MedicationCard(
              medication: m,
              onOrder: m.inStock ? () => _orderMedication(m) : null,
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _orderMedication(_Medication med) async {
    final user = ref.read(authProvider).user;
    final patientRef = user?.fhirPatientId ?? user?.id ?? '';
    final price = double.tryParse(med.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    final order = PharmacyOrderLocal()
      ..patientRef = patientRef
      ..pharmacyName = 'Nepal Pharmacy'
      ..itemsJson = jsonEncode([{'name': med.name, 'dosage': med.dosage, 'price': med.price}])
      ..status = 'ordered'
      ..totalPrice = price
      ..createdAt = DateTime.now()
      ..syncStatus = 1;

    await DatabaseService.pharmacyOrders.add(order);

    if (mounted) {
      showToast(
        context: context,
        builder: (c, o) => SurfaceCard(
          child: Basic(
            title: Text('${med.name} ordered'),
            subtitle: const Text('Your order has been placed'),
            leading: Icon(Icons.check_circle, size: 18, color: Theme.of(context).colorScheme.success),
          ),
        ),
      );
    }
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : colors.mutedForeground)),
        ),
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final _Pharmacy pharmacy;
  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: colors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.local_pharmacy_rounded, color: colors.success, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pharmacy.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground)),
                    Text(pharmacy.address, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pharmacy.isOpen ? colors.success.withValues(alpha: 0.1) : colors.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(pharmacy.isOpen ? 'Open' : 'Closed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: pharmacy.isOpen ? colors.success : colors.destructive)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 13, color: colors.mutedForeground),
              const SizedBox(width: 3),
              Text(pharmacy.distance, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
              const SizedBox(width: 12),
              Icon(Icons.schedule, size: 13, color: colors.mutedForeground),
              const SizedBox(width: 3),
              Text(pharmacy.hours, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
              if (pharmacy.hasDelivery) ...[
                const SizedBox(width: 12),
                Icon(Icons.delivery_dining_rounded, size: 13, color: colors.primary),
                const SizedBox(width: 3),
                Text('Delivery', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final _Medication medication;
  final VoidCallback? onOrder;
  const _MedicationCard({required this.medication, this.onOrder});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medication.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 2),
                Text(medication.dosage, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(medication.price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onOrder,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: medication.inStock ? colors.primary.withValues(alpha: 0.1) : colors.muted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    medication.inStock ? 'Order Now' : 'Out of Stock',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: medication.inStock ? colors.primary : colors.mutedForeground),
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
