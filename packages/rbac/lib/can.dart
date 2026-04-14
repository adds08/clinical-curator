import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'can_provider.dart';

/// Shows [child] only if the active user has the named application
/// permission. Falls back to [fallback] (default: nothing) otherwise.
///
/// The permission string follows `resource.action` (e.g. `encounter.sign`).
/// Backed by the RBAC tables in `RbacPermissionLocal` — see canProvider.
class Can extends ConsumerWidget {
  const Can({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final String permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(canProvider(permission));
    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}
