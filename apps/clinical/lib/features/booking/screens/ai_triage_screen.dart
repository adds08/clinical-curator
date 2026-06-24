import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

/// Informational placeholder for the "Describe Symptoms" AI triage feature.
///
/// No AI integration is wired yet. Rather than a fake chat UI, this screen
/// tells the user the feature is planned and points them to the
/// doctor-consultation flow instead.
class AiTriageScreen extends StatelessWidget {
  const AiTriageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SubPageScaffold(
      title: 'Describe Symptoms',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(LucideIcons.brain,
                            color: colors.primary, size: 22),
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: Text(
                          'AI-guided symptom triage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    'This feature is planned for a future release. Once available, you\'ll be able to describe your symptoms and get a recommended specialty, urgency level, and suggested next steps.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    'In the meantime, the fastest way to get help is to book a consultation with a doctor.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.foreground,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),
            PrimaryButton(
              onPressed: () => context.push('/service/telemedicine'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.video, size: 16),
                  Gap(AppSpacing.sm),
                  Text('Book a doctor consultation'),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            OutlineButton(
              onPressed: () => context.push('/booking/doctor-search'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.userSearch, size: 16),
                  Gap(AppSpacing.sm),
                  Text('Find a doctor'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
