// lib/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color border;
  final Color divider;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color speechText;
  final Color speechBubble;
  final Color speechAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color glass;
  final Color glassBorder;
  final Color selectedItem;
  final Color routeLine;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.border,
    required this.divider,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.speechText,
    required this.speechBubble,
    required this.speechAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.glass,
    required this.glassBorder,
    required this.selectedItem,
    required this.routeLine,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? border,
    Color? divider,
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? speechText,
    Color? speechBubble,
    Color? speechAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? glass,
    Color? glassBorder,
    Color? selectedItem,
    Color? routeLine,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      speechText: speechText ?? this.speechText,
      speechBubble: speechBubble ?? this.speechBubble,
      speechAccent: speechAccent ?? this.speechAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      glass: glass ?? this.glass,
      glassBorder: glassBorder ?? this.glassBorder,
      selectedItem: selectedItem ?? this.selectedItem,
      routeLine: routeLine ?? this.routeLine,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      speechText: Color.lerp(speechText, other.speechText, t)!,
      speechBubble: Color.lerp(speechBubble, other.speechBubble, t)!,
      speechAccent: Color.lerp(speechAccent, other.speechAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      selectedItem: Color.lerp(selectedItem, other.selectedItem, t)!,
      routeLine: Color.lerp(routeLine, other.routeLine, t)!,
    );
  }

  static const dark = AppColors(
    background: Color(0xFF15110D),
    surface: Color(0xFF33271D),
    surfaceLight: Color(0xFF463426),
    border: Color(0xFF5C4033),
    divider: Color(0xFF4A3728),
    primary: Color(0xFFD6B06A),
    primaryLight: Color(0xFFF6D28F),
    primaryDark: Color(0xFFB8860B),
    secondary: Color(0xFFC8A97A),
    speechText: Color(0xFF2C2C2C),
    speechBubble: Color(0xFFF1DFC2),
    speechAccent: Color(0xFFD6B06A),
    textPrimary: Color(0xFFF8F5EE),
    textSecondary: Color(0xFFD2CCC2),
    textMuted: Color(0xFF9E9689),
    textDisabled: Color(0xFF6B6560),
    glass: Color(0x18FFFFFF),
    glassBorder: Color(0x33FFFFFF),
    selectedItem: Color(0xFF4A3520),
    routeLine: Color(0xFF2ECC71),
  );

  static const light = AppColors(
    background: Color(0xFFF4E8CE),
    surface: Color(0xFFFFFAEF),
    surfaceLight: Color(0xFFF9EFD9),

    border: Color(0xFFD8C59D),
    divider: Color(0xFFE6D6B5),

    primary: Color(0xFFB8860B),
    primaryLight: Color(0xFFD6B06A),
    primaryDark: Color(0xFF8B6B00),

    secondary: Color(0xFF7C6440),

    speechText: Color(0xFF2D2417),
    speechBubble: Color(0xFFFFFAEF),
    speechAccent: Color(0xFFB8860B),

    textPrimary: Color(0xFF2D2417),
    textSecondary: Color(0xFF5F523F),
    textMuted: Color(0xFF8A7B61),
    textDisabled: Color(0xFFB7AA92),

    glass: Color(0x22FFF6E2),
    glassBorder: Color(0x44B8860B),

    selectedItem: Color(0xFFF4E6C5),
    routeLine: Color(0xFF00A86B),
  );

  // Helper method
  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? dark;
  }

  // Common colors that don't change
  static const Color success = Color(0xFF62E6B8);
  static const Color warning = Color(0xFFFFC857);
  static const Color error = Color(0xFFFF7B7B);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color parchment = Color(0xFFF3E7C9);
  static const Color parchmentDark = Color(0xFFE0D0AA);

  // Ranks (Legacy support)
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
}
