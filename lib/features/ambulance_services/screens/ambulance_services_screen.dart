import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';

class AmbulanceServicesScreen extends StatelessWidget {
  const AmbulanceServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCz-ayE5vcxhVJBeZYkDcmLWMHI6KPKuMNt7F5PsRnZiKEnXdQcXHlg5IRy8KDqdJny8iWWoLLsoswJL1i13j5cjwA-du5kOHTiVkzcG9kCjbsVo7RB40lCAqaOFHgsBM2nHAw0lZoCVZ6aHtzx2pt62RIIlHSXV368gvQye7MbU2Gv9HoiLvo-_hW_oX5jntNOYKfy5B83x_ubGbTRt_D9vg8dW3KDud5l8s9g5RbjjdfrcKfaWrEBoEJsHQQP8mIzH-gxUfxSg8lJ',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Urgent Action Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFba1a1a), // error
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.emergency, color: Colors.white, size: 120),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Urgent Action Required?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Immediate medical emergency assistance is available 24/7. Connect directly to the national dispatch center.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xCCFFFFFF), // white/80
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.call, size: 18, color: Color(0xFFba1a1a)),
                              label: const Text('Call 102'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFba1a1a),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Color(0x4DFFFFFF)), // white/30
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              child: const Text('Guidelines'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Response Status
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'RESPONSE STATUS',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8), // slate-400
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Active Coverage',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004ac6), // primary
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '8-12 mins',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569), // slate-600
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981), // emerald-500
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '14 Providers',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569), // slate-600
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF004ac6), // primary
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF004ac6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Location Map
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Location',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Color(0xFF004ac6), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '824 Oak Ridge Lane, Medical District',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9), // slate-100
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004ac6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 180,
                    color: const Color(0xFFF1F5F9),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.8,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDpXVOwjtVILHSAj8HziNQ1KmRVFpiPbJvz8V2yH-4xaJY-L57GkGn06rELznnS7olNRDMN4GBvIlgCnTcNBvJBGCRM9cuXmwLcVTV9bnq8m3W3xOrHhiiPBpNNfM7AlnAwms-9eKWZmEG2xXDYsqemrF0GDP8wxHc6tBRdlrhRgPKxkKZHAGNHquE_3fddHt6y_uw64gNkbagXHF8dLZu_1_dewLC2tPRbEADGsVKdrRJOXYeZZTpXT8PfHN4cfvlED_ef4yAvzeuS',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(color: const Color(0x0D004ac6)), // primary/5
                        ),
                        Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF004ac6),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x66000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nearby Providers Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nearby Providers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Certified emergency response teams',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text(
                        'View Map',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004ac6),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 11, color: Color(0xFF004ac6)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Provider Cards
            _buildProviderCard(
              icon: Icons.local_hospital,
              iconColor: const Color(0xFF004ac6), // primary
              iconBgColor: const Color(0xFFEFF6FF), // blue-50
              name: 'St. Jude Medical',
              meta: 'Distance: 1.2 km • ETA: 6 mins',
              statusText: 'Available',
              statusColor: const Color(0xFF047857), // emerald-700
              statusBgColor: const Color(0xFFECFDF5), // emerald-50
              statusBorderColor: const Color(0xFFD1FAE5), // emerald-100
              isAvailable: true,
            ),
            const SizedBox(height: 12),
            _buildProviderCard(
              icon: Icons.minor_crash,
              iconColor: const Color(0xFFba1a1a), // error
              iconBgColor: const Color(0xFFF8FAFC), // slate-50
              name: 'City Public Response',
              meta: 'Distance: 3.8 km • ETA: 14 mins',
              statusText: 'En Route',
              statusColor: const Color(0xFFB45309), // amber-700
              statusBgColor: const Color(0xFFFFFBEB), // amber-50
              statusBorderColor: const Color(0xFFFEF3C7), // amber-100
              isAvailable: false,
              isWaitlist: true,
            ),
            const SizedBox(height: 12),
            _buildProviderCard(
              icon: Icons.masks, // medical_mask approximation
              iconColor: const Color(0xFF004ac6),
              iconBgColor: const Color(0xFFEFF6FF),
              name: 'Elite Heart Center',
              meta: 'Distance: 4.5 km • ETA: 18 mins',
              statusText: 'Available',
              statusColor: const Color(0xFF047857),
              statusBgColor: const Color(0xFFECFDF5),
              statusBorderColor: const Color(0xFFD1FAE5),
              isAvailable: true,
            ),
            const SizedBox(height: 24),

            // Information Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFDBE1FF), // primary-fixed
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x4D004ac6)), // primary-fixed-dim/30 ~
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
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
                      children: [
                        const Text(
                          'Response Tiers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00174b), // on-primary-fixed
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'AI-assisted screening determines if you need basic (BLS) or advanced cardiac life support (ACLS).',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00174b), // on-primary-fixed
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Learn about response levels',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004ac6),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.east, size: 10, color: Color(0xFF004ac6)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String name,
    required String meta,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    required Color statusBorderColor,
    required bool isAvailable,
    bool isWaitlist = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 4,
            offset: Offset(0, 2),
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
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meta,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  border: Border.all(color: statusBorderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isWaitlist ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWaitlist ? const Color(0xFFF1F5F9) : const Color(0xFF004ac6),
                    foregroundColor: isWaitlist ? const Color(0xFF94A3B8) : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    isWaitlist ? 'Waitlist' : 'Dispatch',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // slate-100
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline, color: Color(0xFF475569), size: 18), // slate-600
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
