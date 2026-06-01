// lib/constants/app_text_styles.dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // ─────────────────────────────────
  // 🏷 Titles
  // ─────────────────────────────────

  static const titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    height: 1.2,
    shadows: [
      Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 📜 Body
  // ─────────────────────────────────

  static const bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    height: 1.4,
  );

  // ─────────────────────────────────
  // 📝 Subtitle / Caption
  // ─────────────────────────────────

  static const subtitle = TextStyle(
    fontSize: 13,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontSize: 11,
    letterSpacing: 0.3,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 📊 Stats
  // ─────────────────────────────────

  static const statLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.1,
  );

  static const statMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  // ─────────────────────────────────
  // 🔘 Button
  // ─────────────────────────────────

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // ─────────────────────────────────
  // ✨ Special Fantasy Styles
  // ─────────────────────────────────

  static const adventureTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.3,
  );

  static const fantasy = TextStyle(
    fontSize: 13,
    fontStyle: FontStyle.italic,
    height: 1.6,
    letterSpacing: 0.3,
  );

  /// 気分・難易度ボタンのラベル（選択中）
  static const moodLabelSelected = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// 気分・難易度ボタンのラベル（未選択）
  static const moodLabelUnselected = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// 難易度の説明テキスト
  static const modeDescription = TextStyle(
    fontSize: 13,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 🏷 Label / Tag
  // ─────────────────────────────────

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  // ─────────────────────────────────
  // 🎨 Theme-aware Styles Scheme
  // ─────────────────────────────────

  static AppTextStyleScheme of(BuildContext context) {
    return AppTextStyleScheme(context);
  }
}

class AppTextStyleScheme {
  final BuildContext context;
  AppTextStyleScheme(this.context);

  AppColors get _colors => AppColors.of(context);

  TextStyle get titleLarge => AppTextStyles.titleLarge.copyWith(color: _colors.textPrimary);
  TextStyle get titleMedium => AppTextStyles.titleMedium.copyWith(color: _colors.textPrimary);
  TextStyle get titleSmall => AppTextStyles.titleSmall.copyWith(color: _colors.textPrimary);

  TextStyle get bodyLarge => AppTextStyles.bodyLarge.copyWith(color: _colors.textPrimary);
  TextStyle get bodyMedium => AppTextStyles.bodyMedium.copyWith(color: _colors.textPrimary);
  TextStyle get bodySmall => AppTextStyles.bodySmall.copyWith(color: _colors.textPrimary);

  TextStyle get subtitle => AppTextStyles.subtitle.copyWith(color: _colors.textSecondary);
  TextStyle get caption => AppTextStyles.caption.copyWith(color: _colors.textMuted);

  TextStyle get statLarge => AppTextStyles.statLarge.copyWith(color: _colors.textPrimary);
  TextStyle get statMedium => AppTextStyles.statMedium.copyWith(color: _colors.textPrimary);

  TextStyle get button => AppTextStyles.button.copyWith(color: _colors.textPrimary);

  TextStyle get adventureTitle => AppTextStyles.adventureTitle.copyWith(color: _colors.textPrimary);
  TextStyle get fantasy => AppTextStyles.fantasy.copyWith(color: _colors.textSecondary);

  TextStyle get moodLabelSelected => AppTextStyles.moodLabelSelected.copyWith(color: _colors.primary);
  TextStyle get moodLabelUnselected => AppTextStyles.moodLabelUnselected.copyWith(color: _colors.textMuted);
  TextStyle get modeDescription => AppTextStyles.modeDescription.copyWith(color: _colors.textSecondary);

  TextStyle get label => AppTextStyles.label.copyWith(color: _colors.textPrimary);
  TextStyle get sectionHeader => AppTextStyles.sectionHeader.copyWith(color: _colors.textMuted);
}


