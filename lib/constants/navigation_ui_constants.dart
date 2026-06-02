// lib/constants/navigation_ui_constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ナビゲーション画面のデザイン定数
class NavigationUiConstants {
  NavigationUiConstants._();

  static const Color sepia = Color(0xFFD6B06A); // ✨ プレミアムアンティークゴールド
  static const Color cream = Color(0xFF1D150F); // 🏰 ダークセピアベース背景
  static const Color creamBorder = Color(0xFF5C4033); // 枠線に使うダークウッドブラウン
  static const Color textDark = Color(0xFFF8F5EE); // 可読性抜群のクリームホワイト
  static const Color textMuted = Color(0xFFD2CCC2); // 補助用の明るいセピアグレー

  static const double routeLineWidth = 9;
  static const double arrivalRadiusMeters = 30;
  static const double offRouteThresholdMeters = 50;

  static TextStyle get serifTitle => GoogleFonts.notoSerifJp(
        fontSize: 20, // 💡 18 → 20 (大きく)
        fontWeight: FontWeight.w700,
        color: textDark,
        height: 1.3,
      );

  static TextStyle get serifBody => GoogleFonts.notoSerifJp(
        fontSize: 15, // 💡 14 → 15 (大きく)
        fontWeight: FontWeight.w500, // 💡 w400 → w500 (視認性向上)
        color: textDark,
        height: 1.5,
      );

  static TextStyle get serifCaption => GoogleFonts.notoSerifJp(
        fontSize: 13, // 💡 12 → 13 (大きく)
        fontWeight: FontWeight.w600, // 💡 w500 → w600 (視認性向上)
        color: textMuted,
        height: 1.4,
      );

  static NavigationUiScheme of(BuildContext context) {
    return NavigationUiScheme(context);
  }
}

class NavigationUiScheme {
  final BuildContext context;
  NavigationUiScheme(this.context);

  AppColors get _colors => AppColors.of(context);

  Color get sepia => _colors.primary;
  Color get cream => _colors.background;
  Color get creamBorder => _colors.border;
  Color get textDark => _colors.textPrimary;
  Color get textMuted => _colors.textMuted;

  TextStyle get serifTitle => GoogleFonts.notoSerifJp(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _colors.textPrimary,
        height: 1.3,
      );

  TextStyle get serifBody => GoogleFonts.notoSerifJp(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _colors.textPrimary,
        height: 1.5,
      );

  TextStyle get serifCaption => GoogleFonts.notoSerifJp(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _colors.textMuted,
        height: 1.4,
      );
}
