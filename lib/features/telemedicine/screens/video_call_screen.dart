import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _micEnabled = true;
  bool _cameraEnabled = true;
  bool _chatOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      color: const Color(0xFF0A0C10),
      child: Stack(
        children: [
          // -- Full-screen "video" area with dark medical theme --
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.3),
                  radius: 1.2,
                  colors: [
                    Color(0xFF1A1D24),
                    Color(0xFF111318),
                    Color(0xFF0A0C10),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _cameraEnabled
                            ? Icons.videocam
                            : Icons.videocam_off,
                        color: const Color(0xFF555555),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Video consultation will start shortly',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Connecting to Dr. Arpan K. Sharma...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // -- Doctor name overlay (top) --
          Positioned(
            top: topPad + AppSpacing.lg,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dr. Arpan K. Sharma',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cardiology',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Elapsed time badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.destructive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Text(
                        '00:00',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -- Self-view (bottom right) --
          Positioned(
            right: AppSpacing.xl,
            bottom: bottomPad + 110,
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1D1F24),
                    Color(0xFF15171C),
                  ],
                ),
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: colors.primary, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Color(0xFF555555), size: 32),
                  SizedBox(height: 4),
                  Text(
                    'You',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -- Bottom control bar --
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xl,
                  AppSpacing.xxl,
                  bottomPad + AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF0A0C10).withValues(alpha: 0.95),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mic toggle
                  _buildControlButton(
                    icon: _micEnabled ? Icons.mic : Icons.mic_off,
                    label: _micEnabled ? 'Mic On' : 'Mic Off',
                    active: _micEnabled,
                    onTap: () {
                      setState(() => _micEnabled = !_micEnabled);
                      shadcn.showToast(
                        context: context,
                        builder: (ctx, overlay) => shadcn.SurfaceCard(
                          child: shadcn.Basic(
                            leading: Icon(
                              _micEnabled ? Icons.mic : Icons.mic_off,
                              color: _micEnabled
                                  ? colors.primary
                                  : colors.destructive,
                            ),
                            title: Text(
                                _micEnabled ? 'Mic unmuted' : 'Mic muted'),
                          ),
                        ),
                      );
                    },
                  ),
                  // Camera toggle
                  _buildControlButton(
                    icon: _cameraEnabled
                        ? Icons.videocam
                        : Icons.videocam_off,
                    label: _cameraEnabled ? 'Cam On' : 'Cam Off',
                    active: _cameraEnabled,
                    onTap: () {
                      setState(() => _cameraEnabled = !_cameraEnabled);
                      shadcn.showToast(
                        context: context,
                        builder: (ctx, overlay) => shadcn.SurfaceCard(
                          child: shadcn.Basic(
                            leading: Icon(
                              _cameraEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              color: _cameraEnabled
                                  ? colors.primary
                                  : colors.destructive,
                            ),
                            title: Text(_cameraEnabled
                                ? 'Camera on'
                                : 'Camera off'),
                          ),
                        ),
                      );
                    },
                  ),
                  // End call
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colors.destructive,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end,
                          color: Colors.white, size: 28),
                    ),
                  ),
                  // Chat toggle
                  _buildControlButton(
                    icon: _chatOpen
                        ? Icons.chat
                        : Icons.chat_bubble_outline,
                    label: 'Chat',
                    active: _chatOpen,
                    onTap: () {
                      setState(() => _chatOpen = !_chatOpen);
                      shadcn.showToast(
                        context: context,
                        builder: (ctx, overlay) => shadcn.SurfaceCard(
                          child: shadcn.Basic(
                            leading: Icon(
                              _chatOpen
                                  ? Icons.chat
                                  : Icons.chat_bubble_outline,
                              color: colors.primary,
                            ),
                            title: Text(_chatOpen
                                ? 'Chat opened'
                                : 'Chat closed'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: active
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : const Color(0xFF666666),
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: active
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
