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
    color: AppColors.textPrimary,
    letterSpacing: 1,
    height: 1.2,
    shadows: [
      Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 📜 Body
  // 可読性優先
  // ─────────────────────────────────

  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ─────────────────────────────────
  // 📝 Subtitle / Caption
  // ─────────────────────────────────

  static const subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontSize: 11,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 📊 Stats
  // ─────────────────────────────────

  static const statLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryLight,
    letterSpacing: 0.5,
    height: 1.1,
  );

  static const statMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  // ─────────────────────────────────
  // 🔘 Button
  // ─────────────────────────────────

  static const button = TextStyle(
    fontSize: 16, // 少し大きく
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // ─────────────────────────────────
  // ✨ Special Fantasy Styles
  // ─────────────────────────────────

  static const adventureTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
    height: 1.3,
  );

  static const fantasy = TextStyle(
    fontSize: 13,
    fontStyle: FontStyle.italic,
    color: AppColors.secondary,
    height: 1.6,
    letterSpacing: 0.3,
  );

  /// 気分・難易度ボタンのラベル（選択中）
  static const moodLabelSelected = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.2,
  );

  /// 気分・難易度ボタンのラベル（未選択）
  static const moodLabelUnselected = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.modeTextUnselected, // さっき追加した色
    height: 1.2,
  );

  /// 難易度の説明テキスト（未選択でも読める明るさ）
  static const modeDescription = TextStyle(
    fontSize: 13,
    color: AppColors.modeTextUnselected,
    height: 1.3,
  );

  // ─────────────────────────────────
  // 🏷 Label / Tag
  // チップ・タグ用
  // ─────────────────────────────────

  /// タグ・チップのテキスト
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
    letterSpacing: 0.3,
  );

  /// セクションヘッダーの小見出し
  static const sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 1.5,
  );
}
