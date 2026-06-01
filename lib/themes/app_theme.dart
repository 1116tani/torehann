// lib/themes/app_theme.dart

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme => _buildTheme(isDark: true);
  static ThemeData get lightTheme => _buildTheme(isDark: false);

  static ThemeData _buildTheme({required bool isDark}) {
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    final colors = isDark ? AppColors.dark : AppColors.light;
    final primary = colors.primary;
    final background = colors.background;
    final surface = colors.surface;
    final textPrimary = colors.textPrimary;
    final border = colors.border;
    final divider = colors.divider;

    return base.copyWith(
      brightness: isDark ? Brightness.dark : Brightness.light,

      scaffoldBackgroundColor: background,

      primaryColor: primary,

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      extensions: [
        isDark ? AppColors.dark : AppColors.light,
      ],

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
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      // ─────────────────────────────────
      // 🏛 AppBar
      // ─────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        backgroundColor: Colors.transparent,

        foregroundColor: textPrimary,

        iconTheme: IconThemeData(
          color: textPrimary,
          size: AppSizes.iconM,
        ),

        titleTextStyle: AppTextStyles.titleMedium.copyWith(color: textPrimary),
      ),

      // ─────────────────────────────────
      // 🎴 Card
      // ─────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,

        elevation: 0,

        shadowColor: Colors.transparent,

        margin: const EdgeInsets.all(AppSizes.p8),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),

          side: BorderSide(color: border, width: 1),
        ),
      ),

      // ─────────────────────────────────
      // 🔘 Elevated Button
      // ─────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: primary,

          foregroundColor: isDark ? AppColors.textDark : Colors.white,

          disabledBackgroundColor: isDark ? const Color(0xFF4A4440) : Colors.grey[300],

          disabledForegroundColor: isDark ? const Color(0xFF6B6560) : Colors.grey[500],

          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.p16,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),

            side: BorderSide(color: border, width: 1),
          ),

          textStyle: AppTextStyles.button,
        ),
      ),

      // ─────────────────────────────────
      // 🔲 Outlined Button
      // ─────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,

          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),

          side: BorderSide(color: border),

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
          foregroundColor: primary,

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
        backgroundColor: surface,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),

          side: BorderSide(color: border),
        ),
      ),

      // ─────────────────────────────────
      // ✨ Floating Action Button
      // ─────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,

        foregroundColor: isDark ? AppColors.textDark : Colors.white,

        elevation: 0,
      ),

      // ─────────────────────────────────
      // 📍 Divider
      // ─────────────────────────────────
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      // ─────────────────────────────────
      // 📥 Input
      // ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: colors.surfaceLight,

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textMuted,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: BorderSide(color: border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: BorderSide(color: border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          borderSide: BorderSide(color: primary, width: 1.4),
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
        activeTrackColor: primary,

        inactiveTrackColor: colors.surfaceLight,

        thumbColor: colors.primaryLight,

        overlayColor: primary.withValues(alpha: 0.2),

        trackHeight: 4,
      ),

      // ─────────────────────────────────
      // 🔄 Switch
      // ─────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }

          return colors.textMuted;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryDark;
          }

          return colors.surfaceLight;
        }),
      ),

      // ─────────────────────────────────
      // 💬 SnackBar
      // ─────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,

        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textPrimary),

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),

          side: BorderSide(color: border),
        ),
      ),
    );
  }
}

