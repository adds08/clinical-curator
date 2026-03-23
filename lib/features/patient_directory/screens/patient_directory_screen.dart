import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class PatientDirectoryScreen extends StatelessWidget {
  const PatientDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB8sXWfxUOTe6r1bg1QE8me0Oe6-4uSxL24u6_3BywEct0FOKJn8SAeKt4yNBXSTW7UuDSBIC1hQC-1K1xh8dJVJMGVOOqqZMrDU472Y8_o2aSkaYrY_qFYn7ZXUSHJkPf7WPcNY_0dbj6uV_4_UDVzqXmD5ateGIVQdMaR64TmsaUQVnUZ89Jr2HoIykSN6DSQ2c8S1aZJXEkLrMRk2H5DM2k80dGdNdbXdYQ7fgFp6PNH7J9J0BEo2ksuh7bHq8DP9YkFJDsttSmH',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Directory',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF191c1e), // on-surface
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage clinical intakes, assigned patient records, and real-time medical updates.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B), // slate-500
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('New Intake'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004ac6), // primary
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by name, ID, or condition...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF334155), size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // slate-100
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'All Patients',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004ac6), // primary
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Critical',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B), // slate-500
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Stable',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B), // slate-500
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Assigned Patients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF004ac6), // primary
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Assigned Patients',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const Text(
                  '2 PATIENTS ACTIVE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B), // slate-500
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Patient Card 1
            _buildPatientCard(
              name: 'Sunita Rajbhandari',
              id: 'PID-20442',
              condition: 'Post-Op Recovery',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDzEF7S7amlqd9wt5BXiD57Q0Qg_EowhfM_lMf_K6iBnF7tgeHMTq9s2Nod1rT7ds5EB2quW4_evUA9kp3B6ZQ_b8tFCe-uYezZV7XGvkFR7ZrF9ZtpD_aOQqwWD4KdwaHi1E2NnXt4W4nRWg0fz3kMkT7iKWjkyqpXVh9OXBui8nhGpTrT7bqr3yTWsq7b1X8euaJfjqdrFKS9FVkqfLVBNNR4k6CN_b3zS9uXrffQNk_GtZgpFCBhGj33qJtZ6gwkdLDy7OZ98sXo',
              ageStr: '42 yrs',
              bloodGroup: 'O+',
              status: 'Stable',
              isCritical: false,
            ),
            const SizedBox(height: 12),
            // Patient Card 2
            _buildPatientCard(
              name: 'Bikesh Shrestha',
              id: 'PID-20581',
              condition: 'Chronic Consultation',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6iV4hSDy70TTt691mHbUff_ksfVu08T_MLNsqqN8akBJOnXf1PyMlJzfD7LBY1geMS4iqGDN4nsi6NevFpo7HWuVH6uVoui3qCD2mWUpfcV8129OQ7Eyx7A_QiByxCwpzGhYRVkuuPYhrvVTVAOsNvHzK9EMbz2IyYPOxbSkrOxrePZ2yh03ktyQpSVU8hfwzYIrB5c3dYcAL5lEbfthWRFgXLgKUlWOgCuy4Jgi1EYd0dsHLH0aKkLOoAAM5_aBZarnbTxNloX8w',
              ageStr: '35 yrs',
              bloodGroup: 'A-',
              status: 'Critical',
              isCritical: true,
            ),
            const SizedBox(height: 16),

            // Quick Stats
            Row(
              children: [
                Expanded(child: _buildOccupancyStat()),
                const SizedBox(width: 12),
                Expanded(child: _buildCriticalStat()),
              ],
            ),
            const SizedBox(height: 24),

            // Clinical Updates Feed
            _buildClinicalUpdates(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard({
    required String name,
    required String id,
    required String condition,
    required String imageUrl,
    required String ageStr,
    required String bloodGroup,
    required String status,
    required bool isCritical,
  }) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // blue-50
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isCritical ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                            border: Border.all(color: isCritical ? const Color(0xFFDBE1FF) : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            id,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isCritical ? const Color(0xFF004ac6) : const Color(0xFF64748B),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          condition,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x80F8FAFC), // slate-50/50
              border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AGE / BLOOD GROUP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8), // slate-400
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Color(0xFF0F172A)),
                          const SizedBox(width: 4),
                          Text(
                            ageStr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('|', style: TextStyle(color: Color(0xFFCBD5E1))), // slate-300
                          ),
                          const Icon(Icons.bloodtype, size: 14, color: Color(0xFF0F172A)),
                          const SizedBox(width: 4),
                          Text(
                            bloodGroup,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'WARD STATUS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8), // slate-400
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCritical ? const Color(0x0Dba1a1a) : const Color(0xFFEFF6FF),
                        border: Border.all(color: isCritical ? Colors.transparent : const Color(0xFFDBE1FF)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isCritical ? const Color(0xFFba1a1a) : const Color(0xFF004ac6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history, size: 14),
                  label: const Text('View History'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.note_add, size: 14),
                  label: const Text('Add Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004ac6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    if (isCritical)
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: 4,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF004ac6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
        ),
      ),
  ],
);
  }

  Widget _buildOccupancyStat() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WARD OCCUPANCY',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8), // slate-400
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '82%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF004ac6), // primary
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 82,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF004ac6),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const Expanded(flex: 18, child: SizedBox()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalStat() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'CRITICAL ALERTS',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8), // slate-400
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '03',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFFba1a1a), // error
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalUpdates() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x80F1F5F9), // slate-100/50
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Clinical Updates',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Icon(Icons.sync, color: Color(0xFF004ac6), size: 18), // primary
            ],
          ),
          const SizedBox(height: 16),

          // Timeline logic simplified with row/containers
          Stack(
            children: [
              Positioned(
                left: 3.5,
                top: 0,
                bottom: 0,
                width: 1,
                child: Container(color: const Color(0xFFE2E8F0)),
              ),
              Column(
                children: [
                  _buildUpdateItem(
                    const Color(0xFF004ac6), // primary
                    '10:45 AM • PATHOLOGY',
                    'Lab Results: Patient #20442',
                    'CBC results uploaded for Sunita Rajbhandari. Hemoglobin stable at 12.8 g/dL.',
                  ),
                  _buildUpdateItem(
                    const Color(0xFF94A3B8), // slate-400
                    '09:12 AM • PHARMACY',
                    'Medication Dispatched',
                    'Refill for Metformin (500mg) processed for ward collection.',
                  ),
                  _buildUpdateItem(
                    const Color(0xFFba1a1a), // error
                    '08:30 AM • EMERGENCY',
                    'Admission Alert',
                    'New trauma intake arriving in 15 mins. Requesting ICU prep.',
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'VIEW FULL FEED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004ac6), // primary
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: Color(0xFF004ac6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(Color dotColor, String meta, String title, String body, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFf8fafc), width: 2), // surface background
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: dotColor,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569), // slate-600
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
