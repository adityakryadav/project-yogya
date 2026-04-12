import '../../../../core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onScan;
  final VoidCallback onEligibility;
  final VoidCallback onTimeline;

  QuickActionsRow({
    super.key,
    required this.onScan,
    required this.onEligibility,
    required this.onTimeline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
              _buildAction(
                context,
                icon: Icons.document_scanner_rounded,
                label: 'Scan\nDocument',
                color: Color(0xFF6C5CE7),
                onTap: onScan,
              ),
            SizedBox(width: 12),
              _buildAction(
                context,
                icon: Icons.verified_rounded,
                label: 'Check\nEligibility',
                color: Color(0xFF00B894),
                onTap: onEligibility,
              ),
            SizedBox(width: 12),
              _buildAction(
                context,
                icon: Icons.timeline_rounded,
                label: 'View\nTimeline',
                color: Color(0xFFFDAA5E),
                onTap: onTimeline,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.glassBorder),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
