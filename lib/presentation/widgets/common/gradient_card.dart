import '../../../core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool isGlass;
  final VoidCallback? onTap;

  GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius = 16,
    this.padding,
    this.isGlass = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isGlass ? null : (gradient ?? context.colors.darkCardGradient),
          color: isGlass ? context.colors.glassWhite : null,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isGlass ? context.colors.glassBorder : Colors.transparent,
            width: 1,
          ),
          boxShadow: isGlass
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
        ),
        padding: padding ?? EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
