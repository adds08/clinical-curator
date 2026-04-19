import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../providers/auth_provider.dart';
import '../providers/serverpod_provider.dart';
import 'audit_logger.dart';

/// Watches the signed-in practitioner's account for transitions from
/// unverified → verified (driven by the admin app approving them).
///
/// Flow on every resume / login / foreground:
///   1. If online, pull the fresh `UserAccount` from Serverpod
///      (`auth.getByEmail`) and upsert it into Hive. This is what makes
///      a fresh admin approval visible here — the admin writes to the
///      server, we read from the server.
///   2. Re-read the Hive row (now up to date if step 1 succeeded; still
///      last-known if offline).
///   3. Compare `isVerified` against the `lastSeenVerificationStatus:<email>`
///      flag in SharedPreferences. On false → true, fire the one-time
///      shadcn `AlertDialog`, refresh `authProvider` so `canToggleRole`
///      flips true, and write a `practitioner-verified` audit event.
///
/// Idempotency is enforced by the persisted flag — the dialog never
/// re-fires for the same transition, even across app restarts.
class VerificationWatcher {
  VerificationWatcher._();

  static String _key(String email) =>
      'lastSeenVerificationStatus:${email.toLowerCase()}';

  /// Reads the latest UserAccount row for the logged-in email, compares
  /// against the last-seen flag in prefs, and if the admin has flipped the
  /// account to verified shows the one-time dialog.
  static Future<void> check({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final auth = ref.read(authProvider);
    final user = auth.user;
    if (user == null || !auth.isAuthenticated) return;
    if (!user.isPractitioner) return; // patients never see this dialog

    // Step 1: pull-from-server. Best-effort; on failure we fall back to
    // whatever Hive already has (admin on the same machine may have
    // written directly to the shared box).
    await _refreshFromServer(ref, user.email);

    // Step 2: re-read Hive.
    final box = DatabaseService.userAccounts;
    UserAccount? account;
    for (final a in box.values) {
      if (a.email == user.email) {
        account = a;
        break;
      }
    }
    if (account == null) return;

    // Step 3: transition detection.
    final prefs = await SharedPreferences.getInstance();
    final key = _key(account.email);
    final lastSeen = prefs.getBool(key);
    final isNowVerified = account.isVerified;

    // First-time seed: record current state without firing.
    if (lastSeen == null) {
      await prefs.setBool(key, isNowVerified);
      // If they land already-verified (e.g. admin approved before first
      // login) still refresh auth so the role toggle is enabled.
      if (isNowVerified) {
        await ref.read(authProvider.notifier).checkAuthStatus();
      }
      return;
    }

    // Transition unverified → verified: fire dialog + refresh.
    if (!lastSeen && isNowVerified) {
      await prefs.setBool(key, true);
      await AuditLogger.log(
        type: 'rest',
        action: 'U',
        agentRef: 'Practitioner/${account.fhirPractitionerId ?? account.email}',
        agentName: account.displayName,
        agentRole: account.practitionerType,
        entityRef:
            'Practitioner/${account.fhirPractitionerId ?? account.email}',
        entityType: 'Practitioner',
        detail: 'verification-approved',
      );
      // Refresh auth state so UI gates (canToggleRole) unlock.
      await ref.read(authProvider.notifier).checkAuthStatus();
      if (!context.mounted) return;
      await _showDialog(context);
      return;
    }

    // Admin reverted: refresh auth so UI badges/banner update, show dialog.
    if (lastSeen && !isNowVerified) {
      await prefs.setBool(key, false);
      await ref.read(authProvider.notifier).checkAuthStatus();
      if (!context.mounted) return;
      await _showRevocationDialog(context);
    }
  }

  /// Pull the latest UserAccount from Serverpod and upsert it into Hive.
  /// Silent no-op on network errors — the caller still compares Hive's
  /// last-known state.
  static Future<void> _refreshFromServer(WidgetRef ref, String email) async {
    try {
      final client = ref.read(serverpodClientProvider);
      final server = await client.auth.getByEmail(email);
      if (server == null) return;
      final normalized = server.email.trim().toLowerCase();

      final box = DatabaseService.userAccounts;
      UserAccount? existing;
      for (final a in box.values) {
        if (a.email == normalized) {
          existing = a;
          break;
        }
      }
      if (existing != null) {
        existing
          ..displayName = server.displayName
          ..isPractitioner = server.isPractitioner
          ..isVerified = server.isVerified
          ..practitionerType = server.practitionerType
          ..accountType = server.accountType
          ..fhirPatientId = server.fhirPatientId
          ..fhirPractitionerId = server.fhirPractitionerId
          ..healthId = server.healthId
          ..updatedAt = DateTime.now();
        await existing.save();
      }
    } catch (_) {
      // Offline / server down — keep whatever Hive has.
    }
  }

  static Future<void> _showDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          leading: const Icon(LucideIcons.badgeCheck, size: 24),
          title: const Text('You are verified'),
          content: const Text(
            'Your practitioner account has been verified by an administrator. '
            'Patient consent sharing is now enabled for your account.',
          ),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _showRevocationDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          leading: const Icon(LucideIcons.shieldAlert, size: 24),
          title: const Text('Verification status changed'),
          content: const Text(
            'Your verification has been updated by an administrator. '
            'Consent sharing is temporarily restricted. '
            'Contact your administrator for details.',
          ),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Understood'),
            ),
          ],
        );
      },
    );
  }
}
