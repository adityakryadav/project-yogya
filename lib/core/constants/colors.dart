import 'package:flutter/material.dart';

class AppColors {
  // PRIMARY
  static const Color primary = Color(0xFF3B5BDB);
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color primaryLight = Color(0xFF748FFC);
  static const Color accent = Color(0xFF5C7CFA);

  // STATUS
  static const Color eligible = Color(0xFF2ECC71);
  static const Color ineligible = Color(0xFFE74C3C);
  static const Color partial = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // BACKGROUNDS
  static const Color bgDark = Color(0xFF0F1123);
  static const Color bgCard = Color(0xFF1A1D3A);
  static const Color bgCardLight = Color(0xFF252A4A);
  static const Color bgLight = Color(0xFFEEF1F8);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFF15172F);

  // TEXT
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textHint = Color(0xFF6B6B80);
  static const Color textGrey = Color(0xFF757575);

  // GLASSMORPHISM
  static Color glassWhite = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.12);
  static Color glassHighlight = Colors.white.withOpacity(0.15);

  // URGENCY
  static const Color urgencyHigh = Color(0xFFFF4757);
  static const Color urgencyMedium = Color(0xFFFFA502);
  static const Color urgencyLow = Color(0xFF2ED573);

  // GRADIENTS
  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF3B5BDB), Color(0xFF0F1123)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B5BDB), Color(0xFF748FFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1A1D3A), Color(0xFF252A4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient eligibleGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ineligibleGradient = LinearGradient(
    colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient loginGradient = LinearGradient(
    colors: [Color(0xFFF0F3FF), Color(0xFFE8EDFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}