import 'package:flutter/material.dart';

class SecureLoginScreen extends StatelessWidget {
  const SecureLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb), // surface
      body: Stack(
        children: [
          // Background blurry circles
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 384, // 96 * 4
                  height: 384,
                  decoration: const BoxDecoration(
                    color: Color(0x33004ac6), // primary/20
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004ac6).withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      // Simulate blur by not having sharp edges. A true blur needs BackdropFilter or MaskFilter,
                      // but basic container opacity works well enough for background circles in Flutter
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448), // max-w-md
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Badges & Icon
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe6e8ea), // surface-container-high
                            border: Border.all(color: const Color(0x4Dc3c6d7)), // outline-variant/30
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.verified, color: Color(0xFF004ac6), size: 14), // primary
                              SizedBox(width: 8),
                              Text(
                                'OFFICIAL REGISTERED SYSTEM',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545f73), // secondary
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000), // xl shadow approx
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF004ac6), // primary
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.medical_services, color: Colors.white, size: 36),
                          ),
                        ),
                        const SizedBox(height: 24),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 32, // approx text-3xl/4xl
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191c1e), // on-surface
                              letterSpacing: -0.5,
                              height: 1.2,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                            children: [
                              TextSpan(text: 'Welcome Back to\n'),
                              TextSpan(
                                text: 'The Clinical Curator',
                                style: TextStyle(color: Color(0xFF004ac6)), // primary
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Precision-driven health management for practitioners. Securely access patient registries and diagnostic insights.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF545f73), // secondary
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'WORK EMAIL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF545f73), // secondary
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'name@medical-center.org',
                            hintStyle: const TextStyle(color: Color(0x99737686)), // outline/60
                            prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF737686), size: 20), // outline
                            filled: true,
                            fillColor: const Color(0xFFf2f4f6), // surface-container-low
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0x4Dc3c6d7)), // outline-variant/30
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0x4Dc3c6d7)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'PASSWORD',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545f73), // secondary
                                  letterSpacing: 1,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF004ac6), // primary
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Color(0x99737686)), // outline/60
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF737686), size: 20), // outline
                            filled: true,
                            fillColor: const Color(0xFFf2f4f6), // surface-container-low
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0x4Dc3c6d7)), // outline-variant/30
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0x4Dc3c6d7)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004ac6), // primary
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0x33004ac6), // primary/20
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Need a patient account? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF434655), // on-surface-variant
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004ac6), // primary
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: Container(height: 1, color: const Color(0x4Dc3c6d7))), // outline-variant/30
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF737686), // outline
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            Expanded(child: Container(height: 1, color: const Color(0x4Dc3c6d7))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF004ac6), // primary
                              side: const BorderSide(color: Color(0x33004ac6), width: 2), // primary/20
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Register as a Practitioner',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Practitioner roles include a standard patient account',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xCC004ac6), // primary opacity
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Secure Access Footer
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container(height: 1, color: const Color(0x33c3c6d7))), // outline-variant/20
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'SECURE ACCESS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF737686), // outline
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Expanded(child: Container(height: 1, color: const Color(0x33c3c6d7))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.verified_user, color: Color(0xFF004ac6), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'HIPAA Compliant',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF434655), // on-surface-variant
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: const [
                                Icon(Icons.lock, color: Color(0xFF004ac6), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  '256-bit Encryption',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF434655), // on-surface-variant
                                  ),
                                ),
                              ],
                            ),
                          ],
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
}
