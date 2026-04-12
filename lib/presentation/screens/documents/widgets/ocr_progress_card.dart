import '../../../../core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/providers/ocr_provider.dart';

class OcrProgressCard extends StatelessWidget {
  final OcrState ocrState;

  OcrProgressCard({super.key, required this.ocrState});

  // Determine which layer is currently processing
  String get _currentLayer {
    final progress = ocrState.progress;
    if (progress < 0.25) return 'Layer 1 of 4';
    if (progress < 0.50) return 'Layer 2 of 4';
    if (progress < 0.75) return 'Layer 3 of 4';
    return 'Layer 4 of 4';
  }

  String get _layerDescription {
    final progress = ocrState.progress;
    if (progress < 0.25) return 'Image Pre-processing';
    if (progress < 0.50) return 'Layout Detection';
    if (progress < 0.75) return 'Text Extraction';
    return 'Structured Data Parsing';
  }

  @override
  Widget build(BuildContext context) {
    final progress = ocrState.progress;
    final message  = ocrState.statusMessage;
    final percent  = (progress * 100).toInt();

    return Container(
      padding:    EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:        context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: context.colors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: context.colors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.document_scanner_rounded,
                    color: Colors.white, size: 24),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Extracting Marks Data...',
                      style: TextStyle(
                        color:      context.colors.textPrimary,
                        fontSize:   16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Processing $_currentLayer',
                      style: TextStyle(
                        color:      context.colors.textHint,
                        fontSize:   12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage counter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    color:      context.colors.primaryLight,
                    fontSize:   18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Indigo-to-pink gradient progress bar (Section 7.2.6)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: context.colors.bgCardLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3B5BDB),
                          Color(0xFF7C3AED),
                          Color(0xFFE91E90),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.primary.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Current step description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.bgCardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.primaryLight,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    _layerDescription,
                    style: TextStyle(
                      color:      context.colors.textSecondary,
                      fontSize:   12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Step badges — 4 layers
          Row(
            children: [
              _buildStepBadge(context, 'Pre-process', progress >= 0.25, progress >= 0.0 && progress < 0.25),
              SizedBox(width: 6),
              _buildStepBadge(context, 'Layout', progress >= 0.50, progress >= 0.25 && progress < 0.50),
              SizedBox(width: 6),
              _buildStepBadge(context, 'Text', progress >= 0.75, progress >= 0.50 && progress < 0.75),
              SizedBox(width: 6),
              _buildStepBadge(context, 'Parse', progress >= 1.0, progress >= 0.75 && progress < 1.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepBadge(BuildContext context, String label, bool isDone, bool isActive) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (isDone) {
      bgColor = context.colors.eligible.withOpacity(0.15);
      borderColor = context.colors.eligible.withOpacity(0.4);
      textColor = context.colors.eligible;
      icon = Icons.check_rounded;
    } else if (isActive) {
      bgColor = context.colors.primary.withOpacity(0.15);
      borderColor = context.colors.primary;
      textColor = context.colors.primaryLight;
    } else {
      bgColor = context.colors.bgCardLight;
      borderColor = context.colors.glassBorder;
      textColor = context.colors.textHint;
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 9),
              SizedBox(width: 2),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}