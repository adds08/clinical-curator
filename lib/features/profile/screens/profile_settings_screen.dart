import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _doctorMode = true;
  bool _biometricLogin = true;
  bool _criticalAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb), // surface
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDt8e4tLhRqd72HgSy9rM8KzJJyZLKJSYLv4bQsaNstesjVmZGDGhUgJ1EdcHJXYhrr-KbsFs2HPNxsqHPLaXhCdG2P_x4By12--D0tFfMfX7gvKJ3LzhxVIPEyNjhwQEUkSeVYK06oZXXZwMBEVrqh32Hpn2AOgLO_KZog3sUNgFYPWzCA3TqT3w-PfuzEEyBsmzp4RnTHsr3XEhnaqvclI2o-JAF76QqmF3KErXRogueisYU0r9KvNX7lq5AIIEUS-Kk8aHx4BeZW',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Profile
        onTap: (index) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Section
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
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: const Color(0xFFd5e0f8), // secondary-container
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFf2f4f6), width: 4),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBKJMx0quWjP47ZhmchmZb6im6FU6CbfWxagetcK2vI8mdJXrLrklxt-vu-jX2N3_evpQiUxuqx5cthAxbq6X60XKJZhoPZHIbgevYoL5gkYHAF2vJwdBKmr2Nuc7oLFZEbYKvLx3OGc_x4GN21kxe7T31qBEnlq2TRSpA6nmggHnvK9ug6764eB3KcRi6kFSt7p25hMHrZJKe_btt7uXc3gnD5Q62Fyz3EtX_wSd427Vx9RyZtBDAmDCYsAXlbQitwaAylJhKieydG',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(8, 8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF004ac6), // primary
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.verified, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dr. Arpan K. Sharma',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191c1e), // on-surface
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Senior Consultant • Cardiology',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF586377), // on-secondary-container
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe6e8ea), // surface-container-high
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'MEDICAL ID: 8842-X',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF434655), // on-surface-variant
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x1A004ac6), // primary/10
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ADMIN ACCESS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004ac6), // primary
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Active Workspace
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: Color(0xFF004ac6), width: 4), // primary
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                  right: BorderSide(color: Color(0xFFE2E8F0)),
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF), // blue-50
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.sticky_note_2_outlined, color: Color(0xFF004ac6), size: 24),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'ACTIVE WORKSPACE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004ac6), // primary
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Doctor Mode',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A), // slate-900
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: _doctorMode,
                        onChanged: (val) {
                          setState(() {
                            _doctorMode = val;
                          });
                        },
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF004ac6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x80F8FAFC), // slate-50/50
                      border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Switch to Patient view to manage personal health records and appointment history.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569), // slate-600
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004ac6), // primary
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0x33004ac6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Switch Workspace',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // System Preferences
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
                    Row(
                      children: const [
                        Icon(Icons.settings, color: Color(0xFF004ac6), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'System Preferences',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191c1e), // on-surface
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'DISPLAY LANGUAGE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF545f73), // secondary
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFe0e3e5), // surface-container-highest
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      initialValue: 'English (US)',
                      items: ['English (US)', 'Hindi (IN)', 'Spanish (ES)']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf2f4f6), // surface-container-low
                              border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.fingerprint, color: Color(0xFF737686), size: 20), // outline
                                    SizedBox(width: 12),
                                    Text(
                                      'Biometric Login',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF191c1e), // on-surface
                                      ),
                                    ),
                                  ],
                                ),
                                Checkbox(
                                  value: _biometricLogin,
                                  onChanged: (val) {
                                    setState(() {
                                      _biometricLogin = val ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF004ac6),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf2f4f6), // surface-container-low
                              border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.notifications_active_outlined, color: Color(0xFF737686), size: 20), // outline
                                    SizedBox(width: 12),
                                    Text(
                                      'Critical Alerts',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF191c1e), // on-surface
                                      ),
                                    ),
                                  ],
                                ),
                                Checkbox(
                                  value: _criticalAlerts,
                                  onChanged: (val) {
                                    setState(() {
                                      _criticalAlerts = val ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF004ac6),
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
            const SizedBox(height: 32),

            // Privacy & Danger Zone
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf2f4f6), // surface-container-low
                      border: Border.all(color: const Color(0x1Ac3c6d7)), // outline-variant/10
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_person_outlined, color: Color(0xFF004ac6), size: 24),
                        const SizedBox(height: 12),
                        const Text(
                          'Privacy & Data',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191c1e), // on-surface
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPrivacyLink(Icons.description_outlined, 'Activity Logs'),
                        const SizedBox(height: 12),
                        _buildPrivacyLink(Icons.security_outlined, 'Manage Permissions'),
                        const SizedBox(height: 12),
                        _buildPrivacyLink(Icons.history_outlined, 'Session History'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0x1Affdad6), // error-container/10
                      border: Border.all(color: const Color(0x1Aba1a1a)), // error/10
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.logout, color: Color(0xFFba1a1a), size: 24), // error
                        const SizedBox(height: 12),
                        const Text(
                          'Danger Zone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191c1e), // on-surface
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Securely end your current session. All unsaved clinical entries will be cached.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF434655), // on-surface-variant
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.exit_to_app, size: 18),
                            label: const Text('Sign Out'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFba1a1a), // error
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0x33ba1a1a),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Version 2.4.0-Clinical (Stable)',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0x9993000a), // on-error-container/60
                            ),
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
    );
  }

  Widget _buildPrivacyLink(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF434655), size: 18), // on-surface-variant
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF434655), // on-surface-variant
            ),
          ),
        ],
      ),
    );
  }
}
