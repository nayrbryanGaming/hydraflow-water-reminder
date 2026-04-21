import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand Colors ──────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF2F80ED);      // HydraFlow Main
  static const Color secondaryAqua = Color(0xFF56CCF2);    // Hydration Wave
  static const Color accentMint = Color(0xFF6FCF97);       // Healthy Habit
  static const Color success = Color(0xFF6FCF97);          // Success UI (mapped to Mint)
  static const Color backgroundWhite = Color(0xFFF9FBFF);  // Clean Paper
  static const Color error = Color(0xFFEB5757);            // Error UI

  // ─── Deep UI Colors ────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0B0E14);   // Obsidian Night
  static const Color backgroundCardDark = Color(0xFF161B22);
  static const Color backgroundDeepSea = Color(0xFF05080F);

  // ─── Glassmorphism System ──────────────────────────────────────────
  static const Color glassBase = Color(0x1AFFFFFF);
  static const Color glassStroke = Color(0x33FFFFFF);
  static const Color glassBaseDark = Color(0x33000000);
  
  static LinearGradient glassGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark 
        ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
        : [Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.4)],
    );
  }

  // ─── Text System ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFF8FAFC);

  // ─── Premium Gradients ─────────────────────────────────────────────
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryAqua],
    stops: [0.0, 1.0],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentMint, Color(0xFF27AE60)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
  );

  // ─── Shadows ───────────────────────────────────────────────────────
  static List<BoxShadow> premiumShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}


