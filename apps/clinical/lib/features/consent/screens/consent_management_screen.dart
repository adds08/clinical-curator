import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fhir/r4.dart' as fhir;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_ui_kit/widgets/sub_page_scaffold.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/consent_provider.dart';
import '../../shared/widgets/practitioner_verified_badge.dart';


class ConsentManagementScreen extends ConsumerStatefulWidget {
  const ConsentManagementScreen({super.key});

  @override
  ConsumerState<ConsentManagementScreen> createState() => _ConsentManagementScreenState();
}

class _ConsentManagementScreenState extends ConsumerState<ConsentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;
    final patientRef = user?.fhirPatientId != null ? 'Patient/${user!.fhirPatientId}' : '';
    final consents = patientRef.isNotEmpty ? ref.watch(patientConsentsProvider(patientRef)) : <fhir.Consent>[];

    return SubPageScaffold(
      title: 'Consent Management',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Control who can access your health records',
              style: TextStyle(fontSize: 13, color: colors.mutedForeground, height: 1.4),
            ),
            const SizedBox(height: 24),

            if (consents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Icon(LucideIcons.shield, size: 32, color: colors.mutedForeground),
                    const SizedBox(height: 12),
                    Text('No active consents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                    const SizedBox(height: 4),
                    Text('Grant access to a practitioner to get started.', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                  ],
                ),
              )
            else
              ...consents.map((consent) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ConsentCard(consent: consent, onToggle: (active) => _toggleConsent(consent, active)),
              )),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () {
                  showToast(
                    context: context,
                    builder: (ctx, overlay) => SurfaceCard(
                      child: Basic(title: const Text('Grant New Access'), subtitle: const Text('New consent form opening...'), leading: const Icon(LucideIcons.plus, size: 18)),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(LucideIcons.plus, size: 18), SizedBox(width: 6), Text('Grant New Access')],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Button.outline(
                onPressed: () {
                  showToast(
                    context: context,
                    builder: (ctx, overlay) => SurfaceCard(
                      child: Basic(title: const Text('QR Code'), subtitle: const Text('QR code generated'), leading: const Icon(LucideIcons.qrCode, size: 18)),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(LucideIcons.qrCode, size: 18), SizedBox(width: 6), Text('Share via QR Code')],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // FHIR compliance info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.shieldCheck, size: 20, color: colors.primary.withValues(alpha: 0.7)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your records are protected by the FHIR R4 Consent standard. All consent grants and revocations are stored as auditable FHIR resources.',
                      style: TextStyle(fontSize: 12, color: colors.foreground, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleConsent(fhir.Consent consent, bool activate) async {
    final id = consent.fhirId?.toString() ?? '';
    if (id.isEmpty) return;

    final user = ref.read(authProvider).user;
    await toggleConsentStatus(
      id,
      activate,
      agentEmail: user?.email,
      agentName: user?.displayName,
    );
    setState(() {}); // Rebuild to reflect Hive change
    ref.invalidate(patientConsentsProvider);

    if (mounted) {
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: Text(activate ? 'Access granted' : 'Access revoked'),
            leading: Icon(activate ? LucideIcons.circleCheck : LucideIcons.circleX, size: 18),
          ),
        ),
      );
    }
  }
}

// =============================================================================
// Consent Card — backed by FHIR Consent resource
// =============================================================================

class _ConsentCard extends StatelessWidget {
  final fhir.Consent consent;
  final ValueChanged<bool> onToggle;

  const _ConsentCard({required this.consent, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isActive = consent.status?.toString() == 'active';

    // Extract practitioner reference from provision actor
    final practitionerRef = consent.provision?.actor?.firstOrNull?.reference.reference ?? '';
    final practitionerName = _resolvePractitionerName(practitionerRef);
    final initials = _extractInitials(practitionerName);
    final dateStr = consent.dateTime?.toString().split('T').first ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [SurfaceTheme.ambientShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(initials: initials, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(practitionerName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.foreground)),
                    const SizedBox(height: 2),
                    Text(practitionerRef, style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                    const SizedBox(height: 4),
                    PractitionerVerifiedBadge(practitionerRef: practitionerRef),
                  ],
                ),
              ),
              Switch(value: isActive, onChanged: (v) => onToggle(v)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: colors.muted, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SCOPE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colors.mutedForeground, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text(
                        consent.scope.coding?.firstOrNull?.display ?? 'Full records',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.foreground),
                      ),
                    ],
                  ),
                ),
                isActive
                    ? PrimaryBadge(child: const Text('ACTIVE'))
                    : DestructiveBadge(child: const Text('REVOKED')),
              ],
            ),
          ),
          if (dateStr.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              isActive ? 'Active since $dateStr' : 'Revoked',
              style: TextStyle(fontSize: 11, color: colors.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }

  String _resolvePractitionerName(String ref) {
    // Simple name resolution from reference ID
    if (ref.contains('arpan')) return 'Dr. Arpan K. Sharma';
    if (ref.contains('elena')) return 'Dr. Elena Vance';
    if (ref.contains('anjali')) return 'Anjali Sharma';
    if (ref.contains('bikesh')) return 'Dr. Bikesh Shrestha';
    return ref.replaceAll('Practitioner/', '');
  }

  String _extractInitials(String name) {
    final cleaned = name.replaceAll('Dr. ', '');
    final parts = cleaned.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}
