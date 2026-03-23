import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';
import '../../shared/widgets/record_card.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDJEQ4GHuX3OUt5xkumU67umXB0X1HhHsYAxq2yFVBGHa_In585LU-cDLJTZARn0koOK5A5z13x0g5pWVZUjypF7f9tQ3-V98qfaMbSshsVZY_nY-L7sDJOB15DR-L_kniJoTbge5UVKUV_w0CywE0DC5ao7ooCAfxW6Y0Aapx3EsYd8sKXRUUs9DsKMSllE6D0duczWuVKN97QRDou3hXdtnDGEQPuKaBctPdzd0sqA_bjIAEXekeszw0Gu-9OfGkVpbgDQfi1zK6I',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Medical Records',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF191c1e), // on-surface
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Comprehensive access to your clinical diagnostic history and medication documentation.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B), // slate-500
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Search & Filter Shell
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search records, doctors, or results...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF475569), size: 22), // slate-600
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab Navigation
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xCCF1F5F9), // slate-100/80
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
                          'ALL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004ac6), // primary
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'PRESCRIPTIONS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B), // slate-500
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'LABS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B), // slate-500
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vertical List Layout
            Column(
              children: [
                _buildLipidPanelCard(),
                const SizedBox(height: 16),
                _buildPrescriptionCard(),
                const SizedBox(height: 16),
                _buildRadiologyCard(),
                const SizedBox(height: 16),
                _buildVaccinationCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLipidPanelCard() {
    return RecordCard(
      icon: Icons.biotech_outlined,
      title: 'Full Lipid Panel',
      subtitle: 'Dr. Aris Thorne',
      tagLabel: 'Lab Report',
      dateString: 'Oct 24, 2023',
      primaryButtonLabel: 'View Results',
      onPrimaryTap: () {},
      onDownloadTap: () {},
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x80F8FAFC), // slate-50/50
          border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LDL CHOLESTEROL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8), // slate-400
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '142',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFba1a1a), // error
                            height: 1,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'mg/dL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x1Aba1a1a), // error/10
                    border: Border.all(color: const Color(0x1Aba1a1a)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'HIGH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFba1a1a), // error
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0), // slate-200
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 75,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFba1a1a), // error
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const Expanded(flex: 25, child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8), // slate-400
                  fontFamily: 'Plus Jakarta Sans',
                ),
                children: [
                  TextSpan(text: 'Reference Range: '),
                  TextSpan(
                    text: '<100',
                    style: TextStyle(
                      color: Color(0xFF334155), // slate-700
                      fontWeight: FontWeight.bold,
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

  Widget _buildPrescriptionCard() {
    return RecordCard(
      icon: Icons.medication_outlined,
      title: 'Amoxicillin',
      subtitle: 'City General Clinic',
      tagLabel: 'Active',
      dateString: 'Nov 12, 2023',
      primaryButtonLabel: 'Pharmacy Details',
      onPrimaryTap: () {},
      onDownloadTap: () {},
      isHighlighted: true,
      content: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x80F8FAFC), // slate-50/50
                border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DOSAGE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8), // slate-400
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '500mg • 3x Day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A), // slate-900
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x80F8FAFC), // slate-50/50
                border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DURATION',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8), // slate-400
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '10 Days Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A), // slate-900
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiologyCard() {
    return RecordCard(
      icon: Icons.visibility_outlined,
      title: 'Chest X-Ray',
      subtitle: "St. Mary's Radiology",
      tagLabel: 'Imaging',
      dateString: 'Sep 30, 2023',
      primaryButtonLabel: 'View Report',
      onPrimaryTap: () {},
      onDownloadTap: () {},
      content: Container(
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9), // slate-100
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC5LTfgy543n8mKqD_ganYSDBpD06GgcRgA5p8R8JzsuHw4Az-745fV6civupT-B1F42hEuC8F0Nu-VKVL1YyczciKVqwK95FSTUJYhg4papvJPf24NcdG4WUXVDT4bzeKN00LukdhkpRAOnOVTqM_I1YBCNOh8CnF4-a41GL0YAoWKsB7iJfct1TIPHkbJ2MARHa6J6Rv5e9OC3e90FuGOAi7VodfrIjoLMfCwHNo5Nl4xRGiTmL1s5b02pMRXjGABR-p02Ii7wvLE',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.1)),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x1A004ac6)), // primary/10
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Text(
                  'VIEW SCAN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004ac6), // primary
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

  Widget _buildVaccinationCard() {
    return RecordCard(
      icon: Icons.vaccines_outlined,
      title: 'Influenza Vaccine',
      subtitle: 'CVS Pharmacy',
      tagLabel: 'Immunization',
      dateString: 'Oct 05, 2023',
      primaryButtonLabel: 'View Certificate',
      onPrimaryTap: () {},
      onDownloadTap: () {},
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x80F8FAFC), // slate-50/50
          border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Annual quadrivalent flu shot administered. Patient observed for 15 minutes; no adverse reactions recorded.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF475569), // slate-600
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
