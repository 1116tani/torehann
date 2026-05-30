// lib/constants/navigation_ui_constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ナビゲーション画面のデザイン定数
class NavigationUiConstants {
  NavigationUiConstants._();

  static const Color sepia = Color(0xFF8B7355);
  static const Color cream = Color(0xFFFDF8F0);
  static const Color creamBorder = Color(0xFFE8DFD0);
  static const Color textDark = Color(0xFF3D2B1F);
  static const Color textMuted = Color(0xFF7A6A58);

  static const double routeLineWidth = 5;
  static const double arrivalRadiusMeters = 30;
  static const double offRouteThresholdMeters = 50;

  static TextStyle get serifTitle => GoogleFonts.notoSerifJp(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textDark,
        height: 1.3,
      );

  static TextStyle get serifBody => GoogleFonts.notoSerifJp(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textDark,
        height: 1.5,
      );

  static TextStyle get serifCaption => GoogleFonts.notoSerifJp(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMuted,
        height: 1.4,
      );
}
