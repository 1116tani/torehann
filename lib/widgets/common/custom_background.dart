// lib/widgets/common/custom_background.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_gradients.dart';
import '../../constants/app_shadows.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  /// 背景にぼかしを入れるか
  final bool useBlur;

  /// vignette（周囲暗転）を入れるか
  final bool useVignette;

  /// 上下グラデーションを入れるか
  final bool useOverlayGradient;

  /// 羅針盤などの装飾を重ねるか
  final Widget? overlay;

  const CustomBackground({
    super.key,
    required this.child,
    this.useBlur = false,
    this.useVignette = true,
    this.useOverlayGradient = true,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─────────────────────────────
        // 🌌 Base Background
        // ─────────────────────────────
        Container(decoration: const BoxDecoration(gradient: AppGradients.dark)),

        // ─────────────────────────────
        // ✨ 暖色セピアレイヤー
        // ─────────────────────────────
        Container(color: const Color(0x221A140F)),

        // ─────────────────────────────
        // 🌫 ガラスぼかし
        // ─────────────────────────────
        if (useBlur)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.transparent),
          ),

        // ─────────────────────────────
        // 🗺 上下オーバーレイ
        // ─────────────────────────────
        if (useOverlayGradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x802B2118),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x992B2118),
                ],
                stops: [0.0, 0.18, 0.72, 1.0],
              ),
            ),
          ),

        // ─────────────────────────────
        // 🌑 vignette
        // ─────────────────────────────
        if (useVignette)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.15,
                colors: [Colors.transparent, Color(0x662B2118)],
                stops: [0.72, 1.0],
              ),
            ),
          ),

        // ─────────────────────────────
        // 🔮 Decorative Overlay
        // ─────────────────────────────
        if (overlay != null) overlay!,

        // ─────────────────────────────
        // 📜 Main Content
        // ─────────────────────────────
        Positioned.fill(child: child),
      ],
    );
  }
}
