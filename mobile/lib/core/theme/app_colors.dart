import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand Colors ──────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF2F80ED);
  static const Color secondaryAqua = Color(0xFF56CCF2);
  static const Color accentMint = Color(0xFF6FCF97);

  // ─── Background ────────────────────────────────────────────────────
  static const Color backgroundWhite = Color(0xFFF9FBFF);
  static const Color backgroundOcean = Color(0xFFE3F2FD);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0A1628);
  static const Color backgroundCardDark = Color(0xFF132136);
  static const Color backgroundDeepSea = Color(0xFF05101E);

  // ─── Glassmorphism ────────────────────────────────────────────────
  static Color glassWhite = Colors.white.withOpacity(0.08);
  static Color glassWhiteHeavy = Colors.white.withOpacity(0.25);
  static Color glassDark = const Color(0xFF0A1628).withOpacity(0.4);
  static Color glassBorder = Colors.white.withOpacity(0.2);

  // ─── Text ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A2B4A);
  static const Color textSecondary = Color(0xFF5A7194);
  static const Color textHint = Color(0xFFB0C4DE);

  // ─── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6FCF97), Color(0xFF43B78D)],
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
  );

  static const LinearGradient darkOceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1628), Color(0xFF132136)],
  );

  // ─── Status Colors ─────────────────────────────────────────────────
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2994A);
  static const Color error = Color(0xFFEB5757);
  static const Color info = Color(0xFF2F80ED);

  // ─── Hydration Level Colors ────────────────────────────────────────
  static const Color hydrationLow = Color(0xFFEB5757);
  static const Color hydrationMedium = Color(0xFFF2994A);
  static const Color hydrationGood = Color(0xFF6FCF97);
  static const Color hydrationExcellent = Color(0xFF2F80ED);

  // ─── Divider / Border ──────────────────────────────────────────────
  static const Color divider = Color(0xFFE8F0FE);
  static const Color border = Color(0xFFD0E4FF);

  // ─── Shadow ────────────────────────────────────────────────────────
  static const Color shadow = Color(0xFF2F80ED);
  static Color shadowHeavy = const Color(0xFF000000).withOpacity(0.12);
  static Color shadowGlow = const Color(0xFF2F80ED).withOpacity(0.4);
}
