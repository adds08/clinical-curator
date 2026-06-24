import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';
import 'package:cc_core/widgets/sub_page_scaffold.dart';

import '../../../domain/providers/serverpod_provider.dart';
import 'admin_panel_screen.dart';

class VerificationDetailScreen extends ConsumerStatefulWidget {
  const VerificationDetailScreen({super.key});

  @override
  ConsumerState<VerificationDetailScreen> createState() => _VerificationDetailScreenState();
}

class _VerificationDetailScreenState extends ConsumerState<VerificationDetailScreen> {
  final List<bool> _checklistValues = [false, false, false, false];
  final TextEditingController _notesController = TextEditingController();

  final List<String> _checklistLabels = const [
    'License number verified against NMC database',
    'Photo matches submitted ID',
    'Specialization credentials confirmed',
    'No disciplinary actions found',
  ];

  UserAccount? _account;
  bool _loading = true;
  String? _loadError;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_account == null && _loading && _loadError == null) {
      _loadAccount();
    }
  }

  Future<void> _loadAccount() async {
    final idStr = GoRouterState.of(context).pathParameters['id'] ?? '';
    final id = int.tryParse(idStr);
    if (id == null) {
      setState(() {
        _loading = false;
        _loadError = 'Invalid account id';
      });
      return;
    }
    try {
      final client = ref.read(serverpodClientProvider);
      final account = await client.auth.getById(id);
      if (!mounted) return;
      setState(() {
        _account = account;
        _loading = false;
        _loadError = account == null ? 'Account not found' : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Failed to load: $e';
      });
    }
  }

  Future<void> _approveAccount() async {
    final account = _account;
    if (account == null || account.id == null || _busy) return;
    setState(() => _busy = true);
    try {
      final client = ref.read(serverpodClientProvider);
      final updated = await client.admin.approvePractitioner(account.id!);
      ref.read(adminPanelRefreshProvider.notifier).state++;
      if (!mounted) return;
      final colors = Theme.of(context).colorScheme;
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('Practitioner Approved'),
            subtitle: Text('${updated.displayName} can now access practitioner features'),
            leading: Icon(Icons.check_circle, size: 18, color: colors.success),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError('Approval failed: $e');
    }
  }

  Future<void> _rejectAccount() async {
    final account = _account;
    if (account == null || account.id == null || _busy) return;
    if (_notesController.text.trim().isEmpty) {
      _showError('Please provide a reason for rejection');
      return;
    }
    setState(() => _busy = true);
    try {
      final client = ref.read(serverpodClientProvider);
      await client.admin.rejectPractitioner(account.id!);
      ref.read(adminPanelRefreshProvider.notifier).state++;
      if (!mounted) return;
      final colors = Theme.of(context).colorScheme;
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('Application Rejected'),
            subtitle: const Text('Practitioner has been notified'),
            leading: Icon(Icons.cancel, size: 18, color: colors.destructive),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError('Rejection failed: $e');
    }
  }

  void _showError(String message) {
    final colors = Theme.of(context).colorScheme;
    showToast(
      context: context,
      builder: (ctx, overlay) => SurfaceCard(
        child: Basic(
          title: const Text('Action failed'),
          subtitle: Text(message),
          leading: Icon(Icons.warning_amber, size: 18, color: colors.warning),
        ),
      ),
      location: ToastLocation.bottomRight,
    );
  }

  void _requestMoreInfo() {
    showToast(
      context: context,
      builder: (ctx, overlay) => const SurfaceCard(
        child: Basic(
          title: Text('Not implemented'),
          subtitle: Text('Request-more-info messaging is not yet wired to the server'),
          leading: Icon(Icons.info_outline, size: 18),
        ),
      ),
      location: ToastLocation.bottomRight,
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final account = _account;

    if (_loading) {
      return const SubPageScaffold(
        title: 'Verification',
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    if (account == null) {
      return SubPageScaffold(
        title: 'Verification',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_outlined, size: 48, color: colors.mutedForeground),
              const SizedBox(height: AppSpacing.md),
              Text(
                _loadError ?? 'Account not found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground),
              ),
            ],
          ),
        ),
      );
    }

    return SubPageScaffold(
      title: 'Verification',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPractitionerInfoCard(account, colors),
            const SizedBox(height: AppSpacing.xxl),

            Text(
              'License Photo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _buildPhotoPlaceholder('Front', colors)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildPhotoPlaceholder('Back', colors)),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            Text(
              'Verification Checklist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
              borderRadius: AppRadius.cardRadius,
              child: Column(
                children: _checklistLabels.asMap().entries.map((entry) {
                  return _buildChecklistItem(entry.key, entry.value, colors);
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            Text(
              'Notes / Reason',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.foreground),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _notesController,
              placeholder: const Text('Add notes (required for rejection)'),
              filled: true,
              maxLines: 4,
              borderRadius: AppRadius.cardRadius,
            ),
            const SizedBox(height: AppSpacing.xxl),

            Row(
              children: [
                Expanded(
                  child: Button.primary(
                    onPressed: _busy ? null : _approveAccount,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.check, size: 16), SizedBox(width: 6), Text('Approve')],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Button.outline(
                    onPressed: _busy ? null : _requestMoreInfo,
                    child: const Text('Request More Info', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Button.destructive(
                    onPressed: _busy ? null : _rejectAccount,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.close, size: 16), SizedBox(width: 6), Text('Reject')],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.06), borderRadius: AppRadius.cardRadius),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: colors.primary.withValues(alpha: 0.7)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'On approval, this practitioner will be able to switch to doctor view and manage patients.',
                      style: TextStyle(fontSize: 12, color: colors.foreground, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPractitionerInfoCard(UserAccount account, ColorScheme _) {
    final colors = Theme.of(context).colorScheme;
    final initials = _extractInitials(account.displayName);
    final isDoctor = account.practitionerType != 'nurse';
    final d = account.createdAt;
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final submittedDate = '${months[d.month - 1]} ${d.day}, ${d.year}';

    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(initials: initials, size: 52),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.displayName,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.foreground),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        isDoctor ? const PrimaryBadge(child: Text('DOCTOR')) : const SecondaryBadge(child: Text('NURSE')),
                        const SizedBox(width: AppSpacing.sm),
                        account.isVerified
                            ? const PrimaryBadge(child: Text('VERIFIED'))
                            : const DestructiveBadge(child: Text('PENDING REVIEW')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: SurfaceTheme.colorFor(SurfaceLevel.low, context), borderRadius: AppRadius.inputRadius),
            child: Column(
              children: [
                _DetailRow(label: 'Email', value: account.email),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Type', value: account.practitionerType ?? 'Doctor'),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Account Type', value: account.accountType),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Submitted', value: submittedDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(String label, ColorScheme _) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      padding: EdgeInsets.zero,
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.low, context),
      borderRadius: AppRadius.cardRadius,
      child: SizedBox(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 36, color: colors.mutedForeground.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.mutedForeground),
            ),
            const SizedBox(height: 2),
            Text('Tap to view', style: TextStyle(fontSize: 10, color: colors.mutedForeground)),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(int index, String label, ColorScheme _) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _checklistValues[index] = !_checklistValues[index];
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Checkbox(
              state: _checklistValues[index] ? CheckboxState.checked : CheckboxState.unchecked,
              onChanged: (state) {
                setState(() {
                  _checklistValues[index] = state == CheckboxState.checked;
                });
              },
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _checklistValues[index] ? colors.foreground : colors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractInitials(String name) {
    final cleaned = name.replaceAll('Dr. ', '').replaceAll('dr. ', '');
    final parts = cleaned.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : 'U';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colors.mutedForeground, letterSpacing: 0.8),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.foreground),
          ),
        ),
      ],
    );
  }
}
