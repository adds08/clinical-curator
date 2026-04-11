import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/insurance_claim_collection.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class InsuranceScreen extends ConsumerStatefulWidget {
  const InsuranceScreen({super.key});

  @override
  ConsumerState<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends ConsumerState<InsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final patientRef = user?.fhirPatientId ?? user?.id ?? '';

    // Read real claims from Hive
    final allClaims = DatabaseService.insuranceClaims.values
        .where((c) => c.patientRef == patientRef)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SubPageScaffold(
      title: 'Insurance',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active policy card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Health Insurance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Nepal Life Insurance Co.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Policy No: NLI-2025-KTM-48291', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8), fontFamily: 'monospace')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _PolicyStat(label: 'Coverage', value: 'Rs. 5,00,000'),
                      const SizedBox(width: 24),
                      _PolicyStat(label: 'Valid Until', value: 'Dec 2026'),
                      const SizedBox(width: 24),
                      _PolicyStat(label: 'Type', value: 'Family'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Claims section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Claims', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground)),
                GestureDetector(
                  onTap: () => _showNewClaim(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: colors.primary),
                        const SizedBox(width: 4),
                        Text('New Claim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (allClaims.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 32, color: colors.mutedForeground),
                    const SizedBox(height: 8),
                    Text('No claims yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                    const SizedBox(height: 4),
                    Text('Submit a new claim to get started.', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              )
            else
              ...allClaims.map((claim) {
                const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                final d = claim.createdAt;
                final dateStr = '${months[d.month - 1]} ${d.day}, ${d.year}';
                return _ClaimCard(
                  title: claim.claimType,
                  date: dateStr,
                  amount: 'Rs. ${claim.amount.toStringAsFixed(0)}',
                  status: claim.status,
                  colors: colors,
                );
              }),

            const SizedBox(height: 24),

            // Coverage summary
            Text('Coverage Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground)),
            const SizedBox(height: 12),
            _CoverageRow(label: 'Hospitalization', covered: true, limit: 'Rs. 3,00,000', colors: colors),
            _CoverageRow(label: 'OPD / Outpatient', covered: true, limit: 'Rs. 50,000', colors: colors),
            _CoverageRow(label: 'Maternity', covered: true, limit: 'Rs. 1,00,000', colors: colors),
            _CoverageRow(label: 'Dental', covered: true, limit: 'Rs. 25,000', colors: colors),
            _CoverageRow(label: 'Vision / Optical', covered: false, limit: 'Not covered', colors: colors),
            _CoverageRow(label: 'Mental Health', covered: true, limit: 'Rs. 30,000', colors: colors),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showNewClaim(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final claimTypeCtrl = TextEditingController();
    final providerCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Claim', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground)),
            const SizedBox(height: 20),
            TextField(controller: claimTypeCtrl, placeholder: const Text('Claim type (e.g., OPD Visit)')),
            const SizedBox(height: 12),
            TextField(controller: providerCtrl, placeholder: const Text('Hospital / Provider name')),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, placeholder: const Text('Amount (Rs.)')),
            const SizedBox(height: 12),
            TextField(controller: dateCtrl, placeholder: const Text('Date of service')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () async {
                  if (claimTypeCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) {
                    showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: const Text('Please fill in claim type and amount'))));
                    return;
                  }

                  final user = ref.read(authProvider).user;
                  final patientRef = user?.fhirPatientId ?? user?.id ?? '';
                  final amount = double.tryParse(amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

                  final claim = InsuranceClaimLocal()
                    ..patientRef = patientRef
                    ..claimType = claimTypeCtrl.text.trim()
                    ..provider = providerCtrl.text.trim().isNotEmpty ? providerCtrl.text.trim() : 'Unknown'
                    ..policyNumber = 'NLI-2025-KTM-48291'
                    ..amount = amount
                    ..status = 'Processing'
                    ..description = 'Service date: ${dateCtrl.text.trim()}'
                    ..createdAt = DateTime.now()
                    ..syncStatus = 1;

                  await DatabaseService.insuranceClaims.add(claim);

                  if (!context.mounted) return;
                  closeDrawer(context);
                  setState(() {}); // Rebuild to show new claim
                  showToast(context: context, builder: (c, o) => SurfaceCard(child: Basic(title: const Text('Claim submitted successfully!'))));
                },
                child: const Text('Submit Claim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyStat extends StatelessWidget {
  final String label;
  final String value;
  const _PolicyStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final String title, date, amount, status;
  final ColorScheme colors;
  const _ClaimCard({required this.title, required this.date, required this.amount, required this.status, required this.colors});

  Color get _statusColor {
    if (status == 'Approved') return colors.success;
    if (status == 'Rejected') return colors.destructive;
    return colors.warning;
  }

  @override
  Widget build(BuildContext context) {
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
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.foreground)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverageRow extends StatelessWidget {
  final String label, limit;
  final bool covered;
  final ColorScheme colors;
  const _CoverageRow({required this.label, required this.limit, required this.covered, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            covered ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: covered ? colors.success : colors.destructive,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: colors.foreground))),
          Text(limit, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: covered ? colors.foreground : colors.mutedForeground)),
        ],
      ),
    );
  }
}
