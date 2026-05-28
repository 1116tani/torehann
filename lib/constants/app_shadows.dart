// lib/constants/app_shadows.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  // ─────────────────────────────────
  // ☁ Soft
  // ─────────────────────────────────

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // ─────────────────────────────────
  // 🌑 Medium
  // ─────────────────────────────────

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.18),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  // ─────────────────────────────────
  // 🌌 Large
  // ─────────────────────────────────

  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.24),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

  // ─────────────────────────────────
  // ✨ Gold Glow
  // ─────────────────────────────────

  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.35),
      blurRadius: 24,
      spreadRadius: 1,
      offset: const Offset(0, 6),
    ),
  ];

  // ─────────────────────────────────
  // 🔮 Glass Shadow
  // ─────────────────────────────────

  static List<BoxShadow> glass = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // ─────────────────────────────────
  // 📜 Floating Sheet
  // ─────────────────────────────────

  static List<BoxShadow> floatingSheet = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.28),
      blurRadius: 32,
      offset: const Offset(0, -4),
    ),
  ];

  // ─────────────────────────────────
  // 🏆 Reward Popup
  // ─────────────────────────────────

  static List<BoxShadow> reward = [
    BoxShadow(
      color: AppColors.primaryLight.withValues(alpha: 0.30),
      blurRadius: 36,
      spreadRadius: 4,
      offset: const Offset(0, 0),
    ),
  ];
}
