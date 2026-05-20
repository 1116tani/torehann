// lib/widgets/common/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

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
    this.opacity = 0.1,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        // これが背景をボカすエフェクト
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity), // ほんのり白を混ぜる
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              // カードの縁を細く光らせてシャープに見せる
              color: Colors.white.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
