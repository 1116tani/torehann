// lib/constants/app_gradients.dart

import 'package:flutter/material.dart';

class AppGradients {
  // ─────────────────────────────────
  // ✨ Gold
  // ─────────────────────────────────

  static LinearGradient gold(bool isDark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFFFFE0A3), const Color(0xFFD6B06A)]
            : [const Color(0xFFF6D28F), const Color(0xFFB8860B)],
      );

  // ─────────────────────────────────
  // 🌑 Background
  // ─────────────────────────────────

  static LinearGradient background(bool isDark) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFF2B2118), const Color(0xFF181411)]
            : [const Color(0xFFF8F5EE), const Color(0xFFF3E7C9)],
      );

  // ─────────────────────────────────
  // 📜 Sheet Gradient
  // ─────────────────────────────────

  static LinearGradient sheet(bool isDark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xEE33271D), const Color(0xEE1E1814)]
            : [const Color(0xEEF3E7C9), const Color(0xEEEBDDBA)],
      );

  // ─────────────────────────────────
  // 🌌 Map Overlay
  // ─────────────────────────────────

  static RadialGradient mapOverlay(bool isDark) => RadialGradient(
        center: Alignment.center,
        radius: 1.15,
        colors: [
          Colors.transparent,
          isDark ? const Color(0x662B2118) : const Color(0x44D0C0A0),
        ],
        stops: const [0.72, 1.0],
      );

  // ─────────────────────────────────
  // 🔮 Glass Effect
  // ─────────────────────────────────

  static LinearGradient glass(bool isDark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0x33FFFFFF), const Color(0x11FFFFFF)]
            : [const Color(0x33000000), const Color(0x11000000)],
      );

  // ─────────────────────────────────
  // 🏆 Rare Reward
  // ─────────────────────────────────

  static LinearGradient rareReward(bool isDark) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFFFF2C7),
          const Color(0xFFFFD86B),
          const Color(0xFFB8860B),
        ],
      );

  // ─────────────────────────────────
  // 🎨 Theme-aware Gradients Scheme
  // ─────────────────────────────────

  static AppGradientsScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppGradientsScheme(isDark);
  }
}

class AppGradientsScheme {
  final bool isDark;
  AppGradientsScheme(this.isDark);

  LinearGradient get gold => AppGradients.gold(isDark);
  LinearGradient get background => AppGradients.background(isDark);
  LinearGradient get sheet => AppGradients.sheet(isDark);
  RadialGradient get mapOverlay => AppGradients.mapOverlay(isDark);
  LinearGradient get glass => AppGradients.glass(isDark);
  LinearGradient get rareReward => AppGradients.rareReward(isDark);
}


