// lib/themes/app_theme.dart

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return base.copyWith(
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.background,

      primaryColor: AppColors.primary,

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      // ─────────────────────────────────
      // 🎨 Color Scheme
      // ─────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,

        secondary: AppColors.secondary,

        surface: AppColors.surface,

        onPrimary: AppColors.textDark,
        onSecondary: AppColors.textDark,

        onSurface: AppColors.textPrimary,

        error: AppColors.error,
      ),

      // ─────────────────────────────────
      // 📝 Typography
      // ─────────────────────────────────
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,

        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,

        labelLarge: AppTextStyles.button,
      ),

      // ─────────────────────────────────
      // 🏛 AppBar
      // ─────────────────────────────────
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        backgroundColor: Colors.transparent,

        foregroundColor: AppColors.textPrimary,

        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconM,
        ),

        titleTextStyle: AppTextStyles.titleMedium,
      ),

      // ─────────────────────────────────
      // 🎴 Card
      // ─────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,

        elevation: 0,

        shadowColor: Colors.transparent,

        margin: const EdgeInsets.all(AppSizes.p8),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),

          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // ─────────────────────────────────
      // 🔘 Elevated Button
      // ─────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: AppColors.primary,

          foregroundColor: AppColors.textDark,

          disabledBackgroundColor: AppColors.disabled,

          disabledForegroundColor: AppColors.textDisabled,

          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.p16,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),

            side: const BorderSide(color: AppColors.border, width: 1),
          ),

          textStyle: AppTextStyles.button,
        ),
      ),

      // ─────────────────────────────────
      // 🔲 Outlined Button
      // ─────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,

          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),

          side: const BorderSide(color: AppColors.border),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),

          textStyle: AppTextStyles.button,
        ),
      ),

      // ─────────────────────────────────
      // 🔘 Text Button
      // ─────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,

          textStyle: AppTextStyles.button.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─────────────────────────────────
      // 🧭 Bottom Sheet
      // ─────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
      ),

      // ─────────────────────────────────
      // 💬 Dialog
      // ─────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),

          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // ─────────────────────────────────
      // ✨ Floating Action Button
      // ─────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,

        foregroundColor: AppColors.textDark,

        elevation: 0,
      ),

      // ─────────────────────────────────
      // 📍 Divider
      // ─────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ─────────────────────────────────
      // 📥 Input
      // ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.surfaceLight,

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
      ),

      // ─────────────────────────────────
      // 🎚 Slider
      // ─────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,

        inactiveTrackColor: AppColors.surfaceLight,

        thumbColor: AppColors.primaryLight,

        overlayColor: AppColors.primary.withValues(alpha: 0.2),

        trackHeight: 4,
      ),

      // ─────────────────────────────────
      // 🔄 Switch
      // ─────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.textMuted;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }

          return AppColors.surfaceLight;
        }),
      ),

      // ─────────────────────────────────
      // 💬 SnackBar
      // ─────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,

        contentTextStyle: AppTextStyles.bodyMedium,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
