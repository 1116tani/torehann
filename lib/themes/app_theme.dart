// lib/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AppTheme {
  // ダークテーマの定義
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      // カラーパレットのベース
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),

      // ボタンの共通デザイン
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0, // 今っぽいフラットなデザイン
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 角丸
          ),
        ),
      ),

      // 丸いボタン（FloatingActionButton）の共通デザイン
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
      ),
    );
  }
}
