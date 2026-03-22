import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget content;
  final String tagLabel;
  final String dateString;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onDownloadTap;
  final bool isHighlighted;

  const RecordCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.tagLabel,
    required this.dateString,
    required this.primaryButtonLabel,
    required this.onPrimaryTap,
    required this.onDownloadTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: const Color(0xFFE2E8F0)), // slate-200
          right: BorderSide(color: const Color(0xFFE2E8F0)),
          bottom: BorderSide(color: const Color(0xFFE2E8F0)),
          left: BorderSide(
            color: isHighlighted ? const Color(0xFF004ac6) : const Color(0xFFE2E8F0),
            width: isHighlighted ? 4 : 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000), // ~0.05 opacity black
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x07000000), // ~0.03 opacity black
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // blue-50
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF004ac6), // primary
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A), // slate-900
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B), // slate-500
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // slate-100
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  tagLabel.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B), // slate-500
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                dateString.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8), // slate-400
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrimaryTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004ac6), // primary
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    primaryButtonLabel.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // slate-100
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onDownloadTap,
                  icon: const Icon(
                    Icons.download_outlined,
                    color: Color(0xFF475569), // slate-600
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
