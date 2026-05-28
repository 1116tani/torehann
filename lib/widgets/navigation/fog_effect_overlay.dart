// lib/widgets/navigation/fog_effect_overlay.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

class FogEffectOverlay extends StatefulWidget {
  final double density;

  const FogEffectOverlay({super.key, this.density = 0.65});

  @override
  State<FogEffectOverlay> createState() => _FogEffectOverlayState();
}

class _FogEffectOverlayState extends State<FogEffectOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return RepaintBoundary(
            child: CustomPaint(
              size: Size.infinite,
              painter: _FogPainter(
                progress: _controller.value,
                density: widget.density,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FogPainter extends CustomPainter {
  final double progress;

  final double density;

  _FogPainter({required this.progress, required this.density});

  @override
  void paint(Canvas canvas, Size size) {
    // ─────────────────────────────
    // 🌑 周囲暗転
    // ─────────────────────────────

    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.15,
        colors: [
          Colors.transparent,
          const Color(0xFF1A120C).withValues(alpha: 0.18 * density),
          const Color(0xFF100A06).withValues(alpha: 0.82 * density),
        ],
        stops: const [0.45, 0.75, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, vignettePaint);

    // ─────────────────────────────
    // 🌫️ 漂う霧
    // ─────────────────────────────

    final fogBlobs = [
      _FogBlob(
        baseOffset: const Offset(0.15, 0.22),
        radiusFactor: 0.55,
        speed: 1.0,
        opacity: 0.10,
        angleOffset: 0,
      ),
      _FogBlob(
        baseOffset: const Offset(0.72, 0.18),
        radiusFactor: 0.48,
        speed: 0.8,
        opacity: 0.13,
        angleOffset: math.pi / 2,
      ),
      _FogBlob(
        baseOffset: const Offset(0.42, 0.72),
        radiusFactor: 0.65,
        speed: 1.3,
        opacity: 0.12,
        angleOffset: math.pi,
      ),
      _FogBlob(
        baseOffset: const Offset(0.9, 0.8),
        radiusFactor: 0.42,
        speed: 0.7,
        opacity: 0.09,
        angleOffset: math.pi / 3,
      ),
    ];

    for (final blob in fogBlobs) {
      final t = (progress * 2 * math.pi * blob.speed) + blob.angleOffset;

      final dx = math.cos(t) * 36;
      final dy = math.sin(t) * 22;

      final center = Offset(
        size.width * blob.baseOffset.dx + dx,
        size.height * blob.baseOffset.dy + dy,
      );

      final radius = size.width * blob.radiusFactor;

      final fogPaint = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30)
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF8A7766).withValues(alpha: blob.opacity * density),
            const Color(
              0xFF5A4638,
            ).withValues(alpha: blob.opacity * 0.45 * density),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, fogPaint);
    }

    // ─────────────────────────────
    // ✨ 微粒子
    // ─────────────────────────────

    final dustPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.025 * density);

    for (int i = 0; i < 40; i++) {
      final seed = i * 13.0;

      final x =
          (math.sin(progress * 2 * math.pi + seed) * 0.5 + 0.5) * size.width;

      final y =
          ((i / 40) * size.height +
              math.cos(progress * 2 * math.pi + seed) * 12) %
          size.height;

      final r = (i % 3 + 1).toDouble();

      canvas.drawCircle(Offset(x, y), r, dustPaint);
    }

    // ─────────────────────────────
    // 🌫️ 全体ぼかし膜
    // ─────────────────────────────

    final overlayPaint = Paint()
      ..color = const Color(0xFF2C2318).withValues(alpha: 0.04 * density)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawRect(Offset.zero & size, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _FogPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.density != density;
  }
}

// ─────────────────────────────
// 🌫️ Fog Data
// ─────────────────────────────

class _FogBlob {
  final Offset baseOffset;

  final double radiusFactor;

  final double speed;

  final double opacity;

  final double angleOffset;

  const _FogBlob({
    required this.baseOffset,
    required this.radiusFactor,
    required this.speed,
    required this.opacity,
    required this.angleOffset,
  });
}
