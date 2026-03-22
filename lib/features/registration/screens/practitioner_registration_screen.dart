import 'package:flutter/material.dart';

class PractitionerRegistrationScreen extends StatelessWidget {
  const PractitionerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb), // surface
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Practitioner Registration',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A), // slate-900
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D4ED8)), // blue-700
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Help Center',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D4ED8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B), // slate-500
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0x80E2E8F0), height: 1), // slate-200/50
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 672), // max-w-2xl
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE1FF), // primary-fixed
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x4D004ac6)), // primary-fixed-dim/30
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info, color: Color(0xFF004ac6), size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Identity Synchronisation',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00174b), // on-primary-fixed
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Registering as a practitioner automatically creates a user/patient FHIR-based account too. This ensures a unified medical history within the national health ecosystem.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xE600174b), // on-primary-fixed/90
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf2f4f6), // surface-container-low
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
                          blurRadius: 24,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Professional Credentials',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191c1e), // on-surface
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please provide your official medical registration details for verification.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF434655), // on-surface-variant
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Form Fields
                        _buildFormField(
                          'FULL NAME',
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Dr. Samir K. Shrestha',
                              filled: true,
                              fillColor: const Color(0xFFe0e3e5), // surface-container-highest
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                'MEDICAL ID/LICENSE NUMBER',
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'NMC-XXXXX',
                                    filled: true,
                                    fillColor: const Color(0xFFe0e3e5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildFormField(
                                'SPECIALIZATION',
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFe0e3e5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  initialValue: 'General Medicine',
                                  items: ['General Medicine', 'Cardiology', 'Pediatrics', 'Neurology', 'Orthopedics']
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
                                      .toList(),
                                  onChanged: (val) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildFormField(
                          'HEALTHCARE FACILITY',
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'e.g. Tribhuvan University Teaching Hospital',
                              prefixIcon: const Icon(Icons.local_hospital, color: Color(0xFF434655), size: 20),
                              filled: true,
                              fillColor: const Color(0xFFe0e3e5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildFormField(
                          'WORK EMAIL',
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'name@hospital.org.np',
                              filled: true,
                              fillColor: const Color(0xFFe0e3e5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Verification Notice
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFf2f4f6), // surface-container-low
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified_user_outlined, color: Color(0xFF737686), size: 24), // outline
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your credentials will be verified against the Nepal Medical Council database. This process usually takes 24-48 hours.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF434655), // on-surface-variant
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004ac6), // primary
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0x33004ac6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Submit for Verification',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Secondary Info / Bento
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf2f4f6), // surface-container-low
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.security, color: Color(0xFF004ac6), size: 24),
                            SizedBox(height: 12),
                            Text(
                              'Privacy First',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191c1e), // on-surface
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'All professional data is encrypted and handled according to the National Health Data Privacy Guidelines.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF434655), // on-surface-variant
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf2f4f6), // surface-container-low
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.account_tree, color: Color(0xFF004ac6), size: 24),
                            SizedBox(height: 12),
                            Text(
                              'Unified ID',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF191c1e), // on-surface
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Access both your clinical dashboard and personal health records with a single set of credentials.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF434655), // on-surface-variant
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF545f73), // secondary
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
