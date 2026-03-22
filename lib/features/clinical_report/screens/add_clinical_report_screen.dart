import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class AddClinicalReportScreen extends StatelessWidget {
  const AddClinicalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb), // surface
      appBar: const TopAppBar(
        title: 'The Clinical Curator',
        profileImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBzd0eoXP_2XRy3WJm-LNWcvjIfX6T9XO2RSS4yRlWAZMbVg0Htv4lSp6TIkDJ-LEk4wJNR2NxKrZKR5eDW4goJTcvPZ6moCGj4qVb6fNazX0LT3i2VE1JeQVbPuNxNVbr1KmR6in9uh530xQS6cnrT_ewUORwHXc4_q3D_ZrhTc1JjLqDmMf5CB5yYyiyO9yE98aH7TAUyWwseq9F927oyzW-omAc3Lh-TwelUheCQbHRf8lv7ajAvkdW0v48JT_AmCH93Og4Js0sD',
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Records is highlighted in the mock
        onTap: (index) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            Row(
              children: [
                const Text(
                  'Patients',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF586377), // on-secondary-container
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF586377)),
                const SizedBox(width: 8),
                const Text(
                  'Siddhartha Thapa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF586377),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF586377)),
                const SizedBox(width: 8),
                const Text(
                  'New Clinical Report',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF004ac6), // primary
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Clinical Report Entry',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191c1e), // on-surface
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),

            // Responsive Layout - Column for mobile
            _buildPatientProfile(),
            const SizedBox(height: 24),
            _buildFileUploadSection(),
            const SizedBox(height: 24),
            _buildEntryForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1E), // subtle shadow
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // blue-50
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBekraJ4Mn8_n_3p7iKEh8jvRivaukDYRCmOtkSq0j64Mq381aubLAGlKA3ar-b85s8u4Q7jlsgXX64W_LdzxO77Drej0_9G7jA4m6IvF8DlzgLD34x6h0xlFdYmRnhmnyg-Q8RhKVxVBRQzSKJauFzE-XhBiiA6Cv6ybfEc6zaLC-SW9Ed-6jBmR6tKgJsJqazgz13QEuUecfSM8840ZIBWPhISjhtk1rerK2ZV-jQCKSCWvsYgZiUQVzfgqHJ_qCXNP3FlShiDfZ8',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Siddhartha Thapa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191c1e), // on-surface
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Patient ID: #MED-88291',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF586377), // on-secondary-container
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x33c3c6d7)), // outline-variant/20
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AGE / SEX',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF737686), // outline
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '32 / Male',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191c1e), // on-surface
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BLOOD TYPE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF737686), // outline
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFffdad6), // error-container
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'B Positive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF93000a), // on-error-container
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFf2f4f6), // surface-container-low
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.attach_file, color: Color(0xFF004ac6), size: 18), // primary
              SizedBox(width: 8),
              Text(
                'Attachments & Diagnostic Imagery',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191c1e), // on-surface
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0x80c3c6d7), // outline-variant/50
                style: BorderStyle.solid, // Note: dashed border usually requires custom painter, using solid for now
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload, color: Color(0xFF737686), size: 36), // outline
                const SizedBox(height: 8),
                const Text(
                  'Drag and drop medical files',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Support for DICOM, PDF, JPEG',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF586377), // on-secondary-container
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004ac6), // primary
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  child: const Text('Select Files'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFe0e3e5), // surface-container-highest
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.description, color: Color(0xFF004ac6), size: 16), // primary
                    SizedBox(width: 8),
                    Text(
                      'Previous_Labs.pdf',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.close, color: Color(0xFFba1a1a), size: 16), // error
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1E),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  'REPORT DATE',
                  TextField(
                    decoration: InputDecoration(
                      hintText: '2023-10-27',
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
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFormField(
                  'DEPARTMENT',
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
                    initialValue: 'Internal Medicine',
                    items: ['Internal Medicine', 'Cardiology', 'Neurology', 'Radiology']
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
            'PRIMARY DIAGNOSIS',
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter clinical diagnosis',
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
          _buildFormField(
            'CLINICAL NOTES',
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Detailed observations, patient history nuances...',
                filled: true,
                fillColor: const Color(0xFFe0e3e5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildFormField(
            'TREATMENT PLAN',
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Medications, lifestyle changes, follow-up schedule...',
                filled: true,
                fillColor: const Color(0xFFe0e3e5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Actions
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_done, size: 18),
              label: const Text('Save Report to Registry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004ac6), // primary
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                shadowColor: const Color(0x33004ac6), // primary/20
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Save & Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe6e8ea), // surface-container-high
                      foregroundColor: const Color(0xFF191c1e), // on-surface
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF004ac6), // primary
                      side: const BorderSide(color: Color(0x33004ac6)), // primary/20
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    child: const Text('Cancel Entry'),
                  ),
                ),
              ),
            ],
          ),
        ],
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
