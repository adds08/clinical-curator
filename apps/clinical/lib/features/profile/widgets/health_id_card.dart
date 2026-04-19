import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/providers/auth_provider.dart';

/// A digital Health ID card that looks like a physical card.
/// Reads user data from authProvider.
class HealthIdCard extends ConsumerWidget {
  const HealthIdCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final colors = Theme.of(context).colorScheme;
    final name = user?.displayName ?? 'Unknown';
    final healthId = user?.healthId ?? 'NEP-0000-0000-00';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
            const Color(0xFF1E3A8A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.hospital,
                      color: Colors.white.withValues(alpha: 0.9), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'NATIONAL HEALTH ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NEPAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 16),

          // Health ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    healthId,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.95),
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              // QR hint
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.qrCode,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
