// lib/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AppTheme {
  // ダークテーマの定義
  static ThemeData get darkTheme {
    // 💡 修正ポイント：ThemeData.dark() ではなく、ここを最新の書き方に直したよ！
    final baseTheme = ThemeData(brightness: Brightness.dark);

    return baseTheme.copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      // 🏰 カラーパレットのベース全体を世界観に合わせるよ！
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        onPrimary: AppColors.background, // ゴールドの上の文字は暗い色にして読みやすく
        onSurface: AppColors.textPrimary,
      ),

      // 📜 テキストテーマ（標準の文字色を羊皮紙ホワイトにする魔法）
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: const TextStyle(color: AppColors.textPrimary),
        bodyMedium: const TextStyle(color: AppColors.textSecondary),
        titleLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 🏛️ アプリバーの共通デザイン
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 4,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),

      // ⚔️ ボタンの共通デザイン（有効時と無効時で自動で色が切り替わるよ）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background, // 文字はセピア背景色でクッキリ
          disabledBackgroundColor: AppColors.border, // 無効時は暗い茶色に
          disabledForegroundColor: AppColors.textMuted,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 角丸
            side: const BorderSide(
              color: AppColors.border,
              width: 1,
            ), // うっすらアンティークな枠線
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
      ),

      // 🔮 丸いボタン（FloatingActionButton）の共通デザイン
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 6,
      ),

      // 🎴 カードの共通デザイン
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
    );
  }
}
