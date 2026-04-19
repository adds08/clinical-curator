import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/providers/admin_auth_provider.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(adminAuthProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
    // go_router redirect handles post-login navigation.
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(adminAuthProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.shieldCheck,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Clinical Curator',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: colors.foreground,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin Console',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Card(
                  padding: const EdgeInsets.all(24),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (auth.errorMessage != null) ...[
                        Alert(
                          destructive: true,
                          leading:
                              const Icon(LucideIcons.circleAlert, size: 18),
                          title: Text(auth.errorMessage!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _label('EMAIL', colors),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        placeholder: const Text('admin@example.com'),
                        filled: true,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 16),
                      _label('PASSWORD', colors),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        placeholder: const Text('Enter your password'),
                        filled: true,
                        borderRadius: BorderRadius.circular(8),
                        features: [
                          InputFeature.passwordToggle(
                            mode: PasswordPeekMode.toggle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        onPressed: auth.isLoading ? null : _submit,
                        size: const ButtonSize(1.1),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Authorised personnel only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colors.secondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
