// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // アプリのメインカラー
  static const Color primary = Colors.orange;
  static const Color primaryDark = Color(0xFFE65100); // 濃いオレンジ（影などに）
  static const Color primaryLight = Color(0xFFFFCC80); // 薄いオレンジ

  // 背景色
  static const Color background = Colors.black87;
  static const Color surface = Color(0xFF1E1E1E); // ちょっと浮いた要素の黒
  static const Color glassSurface = Colors.white10; // ガラス風の半透明

  // 文字色
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textDisabled = Colors.white30;

  // アイコン
  static const Color iconActive = Colors.white;
  static const Color iconDisabled = Colors.grey;
}
