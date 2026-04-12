import 'package:flutter/animation.dart';

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration splash = Duration(milliseconds: 1200);
  static const Duration pageTransition = Duration(milliseconds: 350);

  // Curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve sharpCurve = Curves.easeOutQuart;
  static const Curve entryCurve = Curves.easeOutBack;

  // Stagger delay for list items
  static Duration staggerDelay(int index) =>
      Duration(milliseconds: 80 * index);
}
