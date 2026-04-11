import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/user_account_collection.dart';
import '../../../domain/providers/practitioner_data_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class VerificationDetailScreen extends ConsumerStatefulWidget {
  const VerificationDetailScreen({super.key});

  @override
  ConsumerState<VerificationDetailScreen> createState() =>
      _VerificationDetailScreenState();
}

class _VerificationDetailScreenState
    extends ConsumerState<VerificationDetailScreen> {
  final List<bool> _checklistValues = [false, false, false, false];
  final TextEditingController _notesController = TextEditingController();

  final List<String> _checklistLabels = const [
    'License number verified against NMC database',
    'Photo matches submitted ID',
    'Specialization credentials confirmed',
    'No disciplinary actions found',
  ];

  UserAccount? _account;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_account == null) _loadAccount();
  }

  void _loadAccount() {
    final idStr = GoRouterState.of(context).pathParameters['id'] ?? '';
    final id = int.tryParse(idStr);
    if (id != null) {
      try {
        final account = DatabaseService.userAccounts.get(id);
        if (account != null && mounted) {
          setState(() => _account = account);
        }
      } catch (_) {}
    }
  }

  Future<void> _approveAccount() async {
    if (_account == null) return;
    _account!.isVerified = true;
    _account!.updatedAt = DateTime.now();
    await _account!.save();
    ref.invalidate(pendingVerificationsProvider);
    if (mounted) {
      final colors = Theme.of(context).colorScheme;
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('Practitioner Approved'),
            subtitle: const Text('They can now access practitioner features'),
            leading: Icon(Icons.check_circle, size: 18, color: colors.success),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
      context.pop();
    }
  }

  Future<void> _rejectAccount() async {
    if (_account == null) return;
    if (_notesController.text.trim().isEmpty) {
      final colors = Theme.of(context).colorScheme;
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('Notes required'),
            subtitle: const Text('Please provide a reason for rejection'),
            leading: Icon(Icons.warning_amber, size: 18, color: colors.warning),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
      return;
    }
    _account!.isPractitioner = false;
    _account!.isVerified = false;
    _account!.updatedAt = DateTime.now();
    await _account!.save();
    ref.invalidate(pendingVerificationsProvider);
    if (mounted) {
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
    }
  }

  Future<void> _requestMoreInfo() async {
    if (_account == null) return;
    _account!.updatedAt = DateTime.now();
    await _account!.save();
    if (mounted) {
      showToast(
        context: context,
        builder: (ctx, overlay) => SurfaceCard(
          child: Basic(
            title: const Text('More Information Requested'),
            subtitle: const Text('Notification sent to practitioner'),
            leading: const Icon(Icons.info_outline, size: 18),
          ),
        ),
        location: ToastLocation.bottomRight,
      );
    }
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

    if (account == null) {
      return SubPageScaffold(
        title: 'Verification',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_outlined, size: 48, color: colors.mutedForeground),
              const SizedBox(height: AppSpacing.md),
              Text('Account not found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.foreground)),
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
              // -- Practitioner Info Card --
              _buildPractitionerInfoCard(account, colors),
              const SizedBox(height: AppSpacing.xxl),

              // -- License Photos --
              Text(
                'License Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
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

              // -- Verification Checklist --
              Text(
                'Verification Checklist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
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

              // -- Notes Field --
              Text(
                'Notes / Reason',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
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

              // -- Action Buttons --
              Row(
                children: [
                  Expanded(
                    child: Button.primary(
                      onPressed: _approveAccount,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 16),
                          SizedBox(width: 6),
                          Text('Approve'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Button.outline(
                      onPressed: _requestMoreInfo,
                      child: const Text(
                        'Request More Info',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Button.destructive(
                      onPressed: _rejectAccount,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, size: 16),
                          SizedBox(width: 6),
                          Text('Reject'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // -- Info Text --
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.06),
                  borderRadius: AppRadius.cardRadius,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: colors.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'On approval, this practitioner will be able to switch to doctor view and manage patients.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.foreground,
                          height: 1.5,
                        ),
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

  Widget _buildPractitionerInfoCard(UserAccount account, ColorScheme colors) {
      final colors = Theme.of(context).colorScheme;
    final initials = _extractInitials(account.displayName);
    final isDoctor = account.practitionerType != 'nurse';
    final d = account.createdAt;
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
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
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        isDoctor
                            ? const PrimaryBadge(child: Text('DOCTOR'))
                            : const SecondaryBadge(child: Text('NURSE')),
                        const SizedBox(width: AppSpacing.sm),
                        account.isVerified
                            ? const PrimaryBadge(child: Text('VERIFIED'))
                            : DestructiveBadge(child: const Text('PENDING REVIEW')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Details grid
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: SurfaceTheme.colorFor(SurfaceLevel.low, context),
              borderRadius: AppRadius.inputRadius,
            ),
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

  Widget _buildPhotoPlaceholder(String label, ColorScheme colors) {
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
            Icon(
              Icons.camera_alt_outlined,
              size: 36,
              color: colors.mutedForeground.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap to view',
              style: TextStyle(
                fontSize: 10,
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(int index, String label, ColorScheme colors) {
      final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _checklistValues[index] = !_checklistValues[index];
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Checkbox(
              state: _checklistValues[index]
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
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
                  color: _checklistValues[index]
                      ? colors.foreground
                      : colors.mutedForeground,
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

// ---------------------------------------------------------------------------
// Detail Row Widget
// ---------------------------------------------------------------------------
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
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colors.mutedForeground,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
