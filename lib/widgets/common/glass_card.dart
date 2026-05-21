// lib/widgets/common/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/colors.dart'; // 💡 AppColorsをインポート

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.15, // 💡 少しだけ濃く
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
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
            // 💡 ゴールド（Primary）をうっすら混ぜた魔法のガラス
            color: AppColors.primary.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2), // 💡 縁もゴールドに光らせる
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
