import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/providers/rbac_provider.dart';

/// Conditionally renders [child] based on RBAC permissions.
/// Shows [fallback] (defaults to nothing) when the user lacks permission.
class PermissionGate extends ConsumerWidget {
  final String resource;
  final String action;
  final Widget child;
  final Widget fallback;

  const PermissionGate({
    super.key,
    required this.resource,
    required this.action,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(
      hasPermissionProvider((resource: resource, action: action)),
    );
    return allowed ? child : fallback;
  }
}

/// Same as [PermissionGate] but renders a disabled/greyed-out version
/// of the child instead of hiding it completely.
class PermissionGateDisabled extends ConsumerWidget {
  final String resource;
  final String action;
  final Widget child;

  const PermissionGateDisabled({
    super.key,
    required this.resource,
    required this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(
      hasPermissionProvider((resource: resource, action: action)),
    );
    if (allowed) return child;
    return Opacity(
      opacity: 0.4,
      child: IgnorePointer(child: child),
    );
  }
}
