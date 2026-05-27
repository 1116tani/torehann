// lib/widgets/navigation/fog_effect_overlay.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FogEffectOverlay extends StatefulWidget {
  final double density; // 霧の濃さ（0.0 〜 1.0）

  const FogEffectOverlay({
    super.key,
    this.density = 0.65,
  });

  @override
  State<FogEffectOverlay> createState() => _FogEffectOverlayState();
}

class _FogEffectOverlayState extends State<FogEffectOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // 霧を無限にゆっくりと漂わせるためのアニメーション
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _FogPainter(
                timeValue: _animationController.value,
                density: widget.density,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FogPainter extends CustomPainter {
  final double timeValue;
  final double density;

  _FogPainter({required this.timeValue, required this.density});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 1️⃣ 画面の周辺部（四隅）を暗く＆霧深くするグラデーション（ケラレ効果）
    final edgeGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Colors.transparent,
        const Color(0xFF1E1710).withValues(alpha: 0.15 * density), // 内周
        const Color(0xFF160E08).withValues(alpha: 0.85 * density), // 外周（濃いセピア闇）
      ],
      stops: const [0.3, 0.7, 1.0],
    );

    paint.shader = edgeGradient.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    // 2️⃣ 漂流する3層の幻想霧（異なる速度・角度・不透明度の波を描写）
    paint.shader = null; // シェーダーをリセット

    // 霧の発生体（blob）の定義
    final List<_FogBlob> blobs = [
      _FogBlob(
        relativeCenter: const Offset(0.2, 0.25),
        radiusFactor: 0.5,
        speedFactor: 1.0,
        baseAngle: 0.0,
        opacity: 0.12 * density,
      ),
      _FogBlob(
        relativeCenter: const Offset(0.8, 0.3),
        radiusFactor: 0.6,
        speedFactor: 0.7,
        baseAngle: math.pi / 3,
        opacity: 0.15 * density,
      ),
      _FogBlob(
        relativeCenter: const Offset(0.4, 0.75),
        radiusFactor: 0.55,
        speedFactor: 1.2,
        baseAngle: math.pi / 1.5,
        opacity: 0.14 * density,
      ),
      _FogBlob(
        relativeCenter: const Offset(0.85, 0.8),
        radiusFactor: 0.45,
        speedFactor: 0.9,
        baseAngle: math.pi,
        opacity: 0.10 * density,
      ),
    ];

    for (final blob in blobs) {
      // 時間経過に伴うサイン波移動で揺らぐ位置を算出
      final angle = blob.baseAngle + (timeValue * 2 * math.pi * blob.speedFactor);
      final dx = math.cos(angle) * 35.0; // 左右への最大揺れ幅
      final dy = math.sin(angle) * 20.0; // 上下への最大揺れ幅

      final targetCenter = Offset(
        size.width * blob.relativeCenter.dx + dx,
        size.height * blob.relativeCenter.dy + dy,
      );

      final radius = size.width * blob.radiusFactor;

      // 霧のモコモコ感を出すグラデーション
      final blobGradient = RadialGradient(
        colors: [
          const Color(0xFF6B5848).withValues(alpha: blob.opacity), // 中心
          const Color(0xFF4A3728).withValues(alpha: blob.opacity * 0.4), // 中間
          Colors.transparent, // 外側へ消える
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      paint.shader = blobGradient.createShader(
        Rect.fromCircle(center: targetCenter, radius: radius),
      );

      canvas.drawCircle(targetCenter, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FogPainter oldDelegate) {
    return oldDelegate.timeValue != timeValue || oldDelegate.density != density;
  }
}

// 霧の塊データモデル
class _FogBlob {
  final Offset relativeCenter; // 画面幅基準の初期相対位置 (0.0〜1.0)
  final double radiusFactor;   // 画面幅に対する半径比率
  final double speedFactor;    // アニメーションのスピード係数
  final double baseAngle;      // 初期位相角
  final double opacity;        // 基本透明度

  _FogBlob({
    required this.relativeCenter,
    required this.radiusFactor,
    required this.speedFactor,
    required this.baseAngle,
    required this.opacity,
  });
}
