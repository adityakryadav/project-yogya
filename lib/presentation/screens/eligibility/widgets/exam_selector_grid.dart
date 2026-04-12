import '../../../../core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/exam_data.dart';
import '../../../../core/constants/app_animations.dart';

class ExamSelectorGrid extends StatelessWidget {
  final List<ExamInfo> exams;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  ExamSelectorGrid({
    super.key,
    required this.exams,
    required this.selectedIds,
    required this.onToggle,
  });

  Color _getCategoryColor(BuildContext context, String category) {
    switch (category) {
      case 'UPSC':
        return Color(0xFF6C5CE7);
      case 'SSC':
        return Color(0xFF00B894);
      case 'Banking':
        return Color(0xFF0984E3);
      case 'Defence':
        return Color(0xFFE17055);
      case 'Railways':
        return Color(0xFFFDAA5E);
      default:
        return Theme.of(context).extension<ThemeColors>()!.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.35,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        final isSelected = selectedIds.contains(exam.id);
        final color = _getCategoryColor(context, exam.category);
        final themeColors = Theme.of(context).extension<ThemeColors>()!;

        return GestureDetector(
          onTap: ()  => onToggle(exam.id),
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.12)
                  : themeColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : themeColors.glassBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exam.icon,
                      style: TextStyle(fontSize: 22),
                    ),
                    if (isSelected)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check_rounded,
                            color: Colors.white, size: 14),
                      ),
                  ],
                ),
                Spacer(),
                Text(
                  exam.code,
                  style: TextStyle(
                    color: isSelected ? color : context.colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  exam.conductingBody,
                  style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
