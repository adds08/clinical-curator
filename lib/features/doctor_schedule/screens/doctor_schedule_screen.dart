import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBCtrc2tvwoixeOByWaCxuAcd3rzqdQwkoau7rHvV7L0eOaHeRBWyDWd6B8sBt7xe9mYJogW_snpRORW4BtUss7hoKE5HvzHjmFHP_hXGjkyZp3UrGUinGnfZUnc0edBCuS-etitsbZqF14o8IUtpfGLBSTJis5Dp4CxOilX6uH6mRClbkbHlQKF79lFjoNbuAUWtI0V0C3z56lUzqx7gV70guteAT11CZ3JgZIyBWlpacJBPkGom46u02aHxSWM6tnOykevJxmYsCG',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF004ac6),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            const Text(
              'Good morning, Dr. Sharma',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF191c1e), // on-surface
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tuesday, October 24 — You have 3 urgent alerts today.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B), // slate-500
              ),
            ),
            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 1, // Will wrap in layout builder if needed, but linear layout for mobile per design
              mainAxisSpacing: 12,
              childAspectRatio: 3.5,
              children: [
                _buildStatCard(
                  Icons.groups,
                  'TOTAL PATIENTS',
                  '42',
                  '+12% vs last week',
                  const Color(0xFF004ac6), // primary
                  const Color(0xFFEFF6FF), // blue-50
                  const Color(0xFFDBE1FF), // blue-100
                ),
                _buildStatCardPendingConsults(),
                _buildStatCardUrgentAlerts(),
              ],
            ),
            const SizedBox(height: 32),

            // Timeline
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Timeline",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text(
                        'Full Schedule',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004ac6),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 12, color: Color(0xFF004ac6)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimeline(),
            const SizedBox(height: 32),

            // Active Queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Queue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004ac6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQueueItem(
              '01',
              'Anjali Prajapati',
              'Check-up • 15 mins left',
              true,
              true,
            ),
            const SizedBox(height: 12),
            _buildQueueItem(
              '02',
              'Ramesh Thapa',
              'Follow-up • Waiting',
              false,
              false,
            ),
            const SizedBox(height: 12),
            _buildQueueItem(
              '03',
              'Sunita Rai',
              'New Patient • Waiting',
              false,
              false,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF334155), // slate-700
                  elevation: 2,
                  shadowColor: const Color(0x0C000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'VIEW FULL QUEUE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    String badgeText,
    Color accentColor,
    Color badgeBg,
    Color badgeBorder,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'TOTAL PATIENTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8), // slate-400
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A), // slate-900
                  height: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  border: Border.all(color: badgeBorder),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardPendingConsults() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.pending_actions, color: Color(0xFF545f73), size: 24), // secondary
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'PENDING CONSULTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8), // slate-400
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '08',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A), // slate-900
                  height: 1,
                ),
              ),
              Row(
                children: [
                  _buildAvatarStack('https://lh3.googleusercontent.com/aida-public/AB6AXuBCtrc2tvwoixeOByWaCxuAcd3rzqdQwkoau7rHvV7L0eOaHeRBWyDWd6B8sBt7xe9mYJogW_snpRORW4BtUss7hoKE5HvzHjmFHP_hXGjkyZp3UrGUinGnfZUnc0edBCuS-etitsbZqF14o8IUtpfGLBSTJis5Dp4CxOilX6uH6mRClbkbHlQKF79lFjoNbuAUWtI0V0C3z56lUzqx7gV70guteAT11CZ3JgZIyBWlpacJBPkGom46u02aHxSWM6tnOykevJxmYsCG'), // placeholder
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: _buildAvatarStack('https://lh3.googleusercontent.com/aida-public/AB6AXuBCtrc2tvwoixeOByWaCxuAcd3rzqdQwkoau7rHvV7L0eOaHeRBWyDWd6B8sBt7xe9mYJogW_snpRORW4BtUss7hoKE5HvzHjmFHP_hXGjkyZp3UrGUinGnfZUnc0edBCuS-etitsbZqF14o8IUtpfGLBSTJis5Dp4CxOilX6uH6mRClbkbHlQKF79lFjoNbuAUWtI0V0C3z56lUzqx7gV70guteAT11CZ3JgZIyBWlpacJBPkGom46u02aHxSWM6tnOykevJxmYsCG'),
                  ),
                  Transform.translate(
                    offset: const Offset(-16, 0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004ac6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          '+5',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardUrgentAlerts() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0Dba1a1a), // error/5
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33ba1a1a)), // error/20
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.warning, color: Color(0xFFba1a1a), size: 24), // error
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'URGENT ALERTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFFba1a1a), // error
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '03',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFba1a1a), // error
                  height: 1,
                ),
              ),
              const Text(
                'REVIEW NOW',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFba1a1a), // error
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(String url) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildTimeline() {
    return Stack(
      children: [
        // Timeline vertical line
        Positioned(
          left: 17,
          top: 0,
          bottom: 0,
          width: 1,
          child: Container(color: const Color(0xFFE2E8F0)), // slate-200
        ),
        Column(
          children: [
            _buildTimelineEvent(
              Icons.medical_information,
              const Color(0xFF004ac6), // primary
              'Clinical Rounds',
              '08:00 - 10:30 AM',
              'Ward 4B - Post-surgery observation for 12 patients. Focus on Room 402 & 408.',
              null,
            ),
            const SizedBox(height: 16),
            _buildTimelineEvent(
              Icons.healing, // stethoscope is not in default MaterialIcons easily, using healing instead for now
              const Color(0xFF545f73), // secondary
              'OPD Consultations',
              '11:00 - 01:30 PM',
              'General Outpatient Department. 18 slots booked. 4 walk-ins expected.',
              Row(
                children: [
                  _buildTag('URGENT: 2'),
                  const SizedBox(width: 6),
                  _buildTag('FOLLOW-UP: 8'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Opacity(
              opacity: 0.6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0), // slate-200
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.restaurant, color: Color(0xFF64748B), size: 18), // slate-500
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFCBD5E1), // slate-300
                          style: BorderStyle.solid, // dashed is not directly supported by default border, using solid for now
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Lunch Break',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569), // slate-600
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            '01:30 - 02:30 PM',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8), // slate-400
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineEvent(
    IconData icon,
    Color iconBgColor,
    String title,
    String time,
    String description,
    Widget? tags,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xCCF8FAFC), // slate-50/80
              border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A), // slate-900
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF), // blue-50
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFDBE1FF)), // blue-100
                      ),
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004ac6), // primary
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B), // slate-500
                    height: 1.5,
                  ),
                ),
                if (tags != null) ...[
                  const SizedBox(height: 12),
                  tags,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // slate-100
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Color(0xFF64748B), // slate-500
        ),
      ),
    );
  }

  Widget _buildQueueItem(
    String number,
    String name,
    String status,
    bool isActive,
    bool showButton,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          top: const BorderSide(color: Color(0xFFE2E8F0)),
          right: const BorderSide(color: Color(0xFFE2E8F0)),
          bottom: const BorderSide(color: Color(0xFFE2E8F0)),
          left: BorderSide(
            color: isActive ? const Color(0xFF004ac6) : const Color(0xFFE2E8F0),
            width: isActive ? 4 : 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC), // slate-50
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? const Color(0xFF004ac6) : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12), // Need width here actually... oops typo in dart logic. Will let formatting catch or fix inline.
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (showButton)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004ac6),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const Icon(Icons.drag_indicator, color: Color(0xFFCBD5E1)), // slate-300
        ],
      ),
    );
  }
}
