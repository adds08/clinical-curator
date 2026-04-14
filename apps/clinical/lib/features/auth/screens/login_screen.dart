import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/router/route_names.dart';
import 'package:cc_core/utils/validators.dart';
import '../../../domain/providers/auth_provider.dart';
import '../../../domain/providers/connectivity_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'arjun@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final emailErr = Validators.validateEmail(_emailController.text);
    final passwordErr = Validators.validatePassword(_passwordController.text);
    setState(() {
      _emailError = emailErr;
      _passwordError = passwordErr;
    });
    return emailErr == null && passwordErr == null;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) return;
    final isOnline = ref.read(isOnlineProvider);
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
          isOnline: isOnline,
        );
    // go_router redirect handles navigation on success
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      child: Stack(
        children: [
          // Background decorative circle
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: 0.25,
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and branding
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Clinical Curator',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: colors.foreground,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Secure Health Platform',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login card
                    Card(
                      padding: const EdgeInsets.all(24),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Error message
                          if (authState.errorMessage != null) ...[
                            Alert(
                              destructive: true,
                              leading: const Icon(
                                Icons.error_outline,
                                size: 18,
                              ),
                              title: Text(authState.errorMessage!),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email field
                          _buildFieldLabel('EMAIL', colors),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            placeholder: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: colors.mutedForeground,
                                ),
                                const SizedBox(width: 8),
                                const Text('name@medical-center.org'),
                              ],
                            ),
                            filled: true,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          if (_emailError != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _emailError!,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.destructive,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Password field
                          _buildFieldLabel('PASSWORD', colors),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            placeholder: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 16,
                                  color: colors.mutedForeground,
                                ),
                                const SizedBox(width: 8),
                                const Text('Enter your password'),
                              ],
                            ),
                            filled: true,
                            borderRadius: BorderRadius.circular(8),
                            features: [
                              InputFeature.passwordToggle(
                                mode: PasswordPeekMode.toggle,
                              ),
                            ],
                          ),
                          if (_passwordError != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _passwordError!,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.destructive,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),

                          // Sign In button
                          PrimaryButton(
                            onPressed: authState.isLoading ? null : _handleLogin,
                            size: const ButtonSize(1.1),
                            child: authState.isLoading
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
                    const SizedBox(height: 20),

                    // Create Account link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Need an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.mutedForeground,
                          ),
                        ),
                        GhostButton(
                          density: ButtonDensity.compact,
                          onPressed: () => context.go(RouteNames.signup),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: colors.mutedForeground,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colors.border.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Register as Practitioner
                    OutlineButton(
                      onPressed: () => context.go(RouteNames.register),
                      size: const ButtonSize(1.1),
                      child: const Column(
                        children: [
                          Text(
                            'Register as Practitioner',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Includes a standard patient account',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 14,
                          color: colors.mutedForeground.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Protected by HIPAA-compliant encryption',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.mutedForeground.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label,
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
