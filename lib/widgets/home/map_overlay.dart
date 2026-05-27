// lib/widgets/home/map_overlay.dart

import 'dart:math' as math;

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
            // 🌌 全体セピア
            // ─────────────────────────────
            Container(color: const Color(0x1F2B2118)),

            // ─────────────────────────────
            // ✨ 上下グラデーション
            // 暗くしすぎない
            // ─────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [
                    AppColors.background.withValues(alpha: 0.18),

                    Colors.transparent,

                    Colors.transparent,

                    AppColors.background.withValues(alpha: 0.14),
                  ],

                  stops: const [0.0, 0.18, 0.82, 1.0],
                ),
              ),
            ),

            // ─────────────────────────────
            // 🧭 羅針盤
            // ─────────────────────────────
            Center(
              child: Opacity(
                opacity: 0.12,

                child: CustomPaint(
                  size: const Size(260, 260),

                  painter: _CompassPainter(color: AppColors.primary),
                ),
              ),
            ),

            // ─────────────────────────────
            // 🗺 海図グリッド
            // ─────────────────────────────
            Opacity(
              opacity: 0.04,

              child: CustomPaint(
                size: Size.infinite,

                painter: _GridPainter(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────
// 🧭 Compass
// ─────────────────────────────────

class _CompassPainter extends CustomPainter {
  final Color color;

  _CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width * 0.42;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, paint);

    canvas.drawCircle(center, radius - 12, paint..strokeWidth = 0.7);

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);

      final inner = i.isEven ? radius * 0.72 : radius * 0.84;

      final p1 = Offset(
        center.dx + math.cos(angle) * inner,

        center.dy + math.sin(angle) * inner,
      );

      final p2 = Offset(
        center.dx + math.cos(angle) * radius,

        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ─────────────────────────────────
// 🗺 Grid
// ─────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const step = 82.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
