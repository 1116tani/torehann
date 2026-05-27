// lib/widgets/common/glass_card.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_shadows.dart';
import '../../constants/app_sizes.dart';

class GlassCard extends StatelessWidget {
  final Widget child;

  final double blur;

  final EdgeInsetsGeometry padding;

  final double borderRadius;

  final double? opacity;

  final bool useBorder;

  final bool useShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = AppSizes.blurM,
    this.padding = const EdgeInsets.all(AppSizes.p16),
    this.borderRadius = AppRadius.card,
    this.opacity,
    this.useBorder = true,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),

        child: Container(
          padding: padding,

          decoration: BoxDecoration(
            // 🌌 半透明のダークブラウン
            color: opacity != null
                ? AppColors.sheetBackground.withValues(alpha: opacity!)
                : AppColors.sheetBackground,

            borderRadius: BorderRadius.circular(borderRadius),

            border: useBorder
                ? Border.all(color: AppColors.glassBorder, width: 1)
                : null,

            boxShadow: useShadow ? AppShadows.glass : null,
          ),

          child: child,
        ),
      ),
    );
  }
}
