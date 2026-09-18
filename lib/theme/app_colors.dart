import 'package:flutter/material.dart';

/// CEO design pack tokens — single source of truth for EcoAR Kerkennah.
class AppColors {
  AppColors._();

  // Core palette (CEO ranges)
  static const primaryTeal = Color(0xFF123F4A);
  static const primaryTealMid = Color(0xFF175B68);
  static const accentGold = Color(0xFFC9A227);
  static const accentGoldDeep = Color(0xFFB98B2E);
  static const backgroundCream = Color(0xFFF8F4EC);
  static const creamAlt = Color(0xFFFAF7F0);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF5B6670);
  static const textSecondaryAlt = Color(0xFF6B7280);
  static const inputBorder = Color(0xFFE4E0D8);

  // Aliases (existing call sites)
  static const navy = primaryTeal;
  static const navyDeep = Color(0xFF0A2A30);
  static const teal = primaryTeal;
  static const gold = accentGold;
  static const goldSoft = Color(0xFFD4AF37);
  static const cream = backgroundCream;
  static const creamDark = Color(0xFFF1EEE7);
  static const white = cardWhite;
  static const textPrimary = primaryTeal;
  static const border = inputBorder;
  static const orangeAccent = Color(0xFFE08A3C);
}

/// Layout tokens — radii, shadows, spacing.
class AppLayout {
  AppLayout._();

  static const double radiusCard = 26;
  static const double radiusSheet = 28;
  static const double radiusPill = 999;
  static const double radiusMedium = 16;
  static const double paddingCard = 22;
  static const double paddingScreen = 24;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get sheetShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];
}
