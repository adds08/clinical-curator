import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/providers/practitioner_verification_provider.dart';

class PractitionerVerifiedBadge extends ConsumerWidget {
  final String practitionerRef;
  const PractitionerVerifiedBadge({super.key, required this.practitionerRef});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verified = ref.watch(practitionerVerifiedProvider(practitionerRef));

    if (verified) {
      return const PrimaryBadge(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.badgeCheck, size: 10, color: Colors.white),
            SizedBox(width: 3),
            Text('Verified', style: TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    return const SecondaryBadge(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.shieldAlert, size: 10),
          SizedBox(width: 3),
          Text('Not Verified', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
