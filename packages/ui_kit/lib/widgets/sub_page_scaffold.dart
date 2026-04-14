import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A scaffold for sub-pages that pushes full-screen (no bottom nav).
/// Shows an AppBar with back button + title.
class SubPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> trailing;

  const SubPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      headers: [
        AppBar(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: colors.background,
          leading: [
            IconButton.ghost(
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ],
          trailing: trailing,
        ),
      ],
      child: child,
    );
  }
}
