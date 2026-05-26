// lib/widgets/home/map_overlay.dart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class MapOverlay extends StatelessWidget {
  const MapOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // ─────────────────────────────
            // 🌌 周囲だけを少し暗くする
            // 真っ黒じゃなく暖色の影
            // ─────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.15,
                  colors: [
                    Colors.transparent,
                    Color(0x662B2118),
                  ],
                  stops: [0.72, 1.0],
                ),
              ),
            ),

            // ─────────────────────────────
            // 🗺 地図全体をほんの少しセピア化
            // ─────────────────────────────
            Container(
              color: const Color(0x222B2118),
            ),

            // ─────────────────────────────
            // ✨ 羅針盤・魔法陣
            // ─────────────────────────────
            Opacity(
              opacity: 0.18,
              child: CustomPaint(
                size: Size.infinite,
                painter: _AntiqueCompassPainter(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────
// 🧭 羅針盤Painter
// ─────────────────────────────────

class _AntiqueCompassPainter extends CustomPainter {
  final Color color;

  _AntiqueCompassPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width * 0.38;

    // ─────────────────────────────
    // 外円
    // ─────────────────────────────

    final outerPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, radius, outerPaint);

    final innerPaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawCircle(center, radius - 14, innerPaint);

    // ─────────────────────────────
    // 方位線
    // ─────────────────────────────

    final linePaint = Paint()
      ..color = color.withOpacity(0.14)
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);

      final innerRadius =
          i.isEven
              ? radius * 0.78
              : radius * 0.88;

      final start = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );

      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(start, end, linePaint);
    }

    // ─────────────────────────────
    // 海図グリッド
    // ─────────────────────────────

    final gridPaint = Paint()
      ..color = color.withOpacity(0.035)
      ..strokeWidth = 0.6;

    const step = 72.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}