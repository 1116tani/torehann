// lib/constants/app_shadows.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  // ─────────────────────────────────
  // ☁ Soft
  // ─────────────────────────────────

  static List<BoxShadow> soft(bool isDark) => [
        BoxShadow(
          color: (isDark ? Colors.black : const Color(0xFF1A1A1A)).withValues(alpha: 0.12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  // ─────────────────────────────────
  // 🌑 Medium
  // ─────────────────────────────────

  static List<BoxShadow> medium(bool isDark) => [
        BoxShadow(
          color: (isDark ? Colors.black : const Color(0xFF1A1A1A)).withValues(alpha: 0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  // ─────────────────────────────────
  // ✨ Gold Glow
  // ─────────────────────────────────

  static List<BoxShadow> goldGlow(bool isDark) => [
        BoxShadow(
          color: (isDark ? AppColors.dark.primary : AppColors.light.primary)
              .withValues(alpha: 0.35),
          blurRadius: 24,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
      ];

  // ─────────────────────────────────
  // 🔮 Glass Shadow
  // ─────────────────────────────────

  static List<BoxShadow> glass(bool isDark) => [
        BoxShadow(
          color: (isDark ? Colors.black : const Color(0xFF1A1A1A)).withValues(alpha: 0.16),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  // ─────────────────────────────────
  // 📜 Floating Sheet
  // ─────────────────────────────────

  static List<BoxShadow> floatingSheet(bool isDark) => [
        BoxShadow(
          color: (isDark ? Colors.black : const Color(0xFF1A1A1A)).withValues(alpha: 0.28),
          blurRadius: 32,
          offset: const Offset(0, -4),
        ),
      ];

  // ─────────────────────────────────
  // 🎨 Theme-aware Shadows Scheme
  // ─────────────────────────────────

  static AppShadowsScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppShadowsScheme(isDark);
  }
}

class AppShadowsScheme {
  final bool isDark;
  AppShadowsScheme(this.isDark);

  List<BoxShadow> get soft => AppShadows.soft(isDark);
  List<BoxShadow> get medium => AppShadows.medium(isDark);
  List<BoxShadow> get goldGlow => AppShadows.goldGlow(isDark);
  List<BoxShadow> get glass => AppShadows.glass(isDark);
  List<BoxShadow> get floatingSheet => AppShadows.floatingSheet(isDark);
}


