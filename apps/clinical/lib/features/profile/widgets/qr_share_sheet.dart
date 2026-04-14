import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import '../../../domain/providers/auth_provider.dart';

/// Drawer for sharing health records via QR code.
/// Invoke via [QrShareSheet.show(context)].
class QrShareSheet extends ConsumerStatefulWidget {
  const QrShareSheet({super.key});

  static void show(BuildContext context) {
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => const QrShareSheet(),
    );
  }

  @override
  ConsumerState<QrShareSheet> createState() => _QrShareSheetState();
}

class _QrShareSheetState extends ConsumerState<QrShareSheet> {
  bool _fullRecords = true;
  bool _labsOnly = false;
  bool _vitalsOnly = false;
  String _expiry = '24 hours';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final healthId = user?.healthId ?? 'NEP-0000-0000-00';
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl, AppSpacing.sm, AppSpacing.xxl, AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Health Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.foreground,
                ),
              ),
              IconButton.ghost(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => closeDrawer(context),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // QR Code
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: QrImageView(
              data: 'clinical-curator://share/$healthId?full=$_fullRecords&labs=$_labsOnly&vitals=$_vitalsOnly&expiry=$_expiry',
              version: QrVersions.auto,
              size: 180,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF0F172A),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          Text(
            'Scan to access health profile',
            style: TextStyle(
              fontSize: 12,
              color: colors.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Sharing scope
          _shareToggle('Full Medical Records', _fullRecords, (v) {
            setState(() {
              _fullRecords = v;
              if (v) { _labsOnly = false; _vitalsOnly = false; }
            });
          }),
          const SizedBox(height: AppSpacing.sm),
          _shareToggle('Lab Results Only', _labsOnly, (v) {
            setState(() {
              _labsOnly = v;
              if (v) _fullRecords = false;
            });
          }),
          const SizedBox(height: AppSpacing.sm),
          _shareToggle('Vital Signs Only', _vitalsOnly, (v) {
            setState(() {
              _vitalsOnly = v;
              if (v) _fullRecords = false;
            });
          }),

          const SizedBox(height: AppSpacing.xl),

          // Expiry
          Row(
            children: [
              Text(
                'Expires in:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(width: 12),
              ...['24 hours', '7 days', '30 days'].map((label) {
                final active = _expiry == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    style: active
                        ? const ButtonStyle.primary()
                        : const ButtonStyle.outline(),
                    onPressed: () => setState(() => _expiry = label),
                    child: Text(label, style: const TextStyle(fontSize: 11)),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Actions
          SizedBox(
            width: double.infinity,
            child: Button.outline(
              onPressed: () {
                showToast(
                  context: context,
                  builder: (ctx, overlay) => SurfaceCard(
                    child: Basic(
                      title: const Text('Share link copied'),
                      leading: const Icon(Icons.check_circle_outline),
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link, size: 16),
                  SizedBox(width: 8),
                  Text('Copy Share Link'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              onPressed: () => closeDrawer(context),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareToggle(String label, bool value, ValueChanged<bool> onChanged) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.foreground,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
