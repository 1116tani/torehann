// lib/constants/app_gradients.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  // ─────────────────────────────────
  // ✨ Gold
  // ─────────────────────────────────

  static const LinearGradient gold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE0A3),
      Color(0xFFD6B06A),
    ],
  );

  // ─────────────────────────────────
  // 🌑 Dark Background
  // ─────────────────────────────────

  static const LinearGradient dark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2B2118),
      Color(0xFF181411),
    ],
  );

  // ─────────────────────────────────
  // 📜 Sheet Gradient
  // ─────────────────────────────────

  static const LinearGradient sheet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xEE33271D),
      Color(0xEE1E1814),
    ],
  );

  // ─────────────────────────────────
  // 🌌 Map Overlay
  // ─────────────────────────────────

  static const RadialGradient mapOverlay = RadialGradient(
    center: Alignment.center,
    radius: 1.15,
    colors: [
      Colors.transparent,
      Color(0x662B2118),
    ],
    stops: [0.72, 1.0],
  );

  // ─────────────────────────────────
  // 🔮 Glass Effect
  // ─────────────────────────────────

  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF),
      Color(0x11FFFFFF),
    ],
  );

  // ─────────────────────────────────
  // 🏆 Rare Reward
  // ─────────────────────────────────

  static const LinearGradient rareReward = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF2C7),
      Color(0xFFFFD86B),
      Color(0xFFB8860B),
    ],
  );

  // ─────────────────────────────────
  // 🔘 Button
  // ─────────────────────────────────

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF6D28F),
      Color(0xFFD6B06A),
    ],
  );
}