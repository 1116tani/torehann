// lib/widgets/navigation/compass_widget.dart

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/spot_model.dart';

class CompassWidget extends StatefulWidget {
  final Position? currentPosition;
  final SpotModel? targetSpot;
  final double size;

  const CompassWidget({
    super.key,
    required this.currentPosition,
    required this.targetSpot,
    this.size = 160,
  });

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  double _calculateBearing() {
    if (widget.currentPosition == null || widget.targetSpot == null) {
      return 0;
    }

    final bearing = Geolocator.bearingBetween(
      widget.currentPosition!.latitude,
      widget.currentPosition!.longitude,
      widget.targetSpot!.lat,
      widget.targetSpot!.lng,
    );

    return bearing * (math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    final isSearching =
        widget.currentPosition == null || widget.targetSpot == null;

    final angle = _calculateBearing();

    return Positioned(
      top: 120,
      left: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xAA221A14),
              border: Border.all(color: const Color(0x66D6B06A), width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0x33D6B06A),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🌌 外周エフェクト
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_scanController),
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _CompassGlowPainter(),
                  ),
                ),

                // 🧭 盤面
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CompassFacePainter(),
                ),

                // 🪄 針
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: isSearching
                        ? _scanController.value * math.pi * 2
                        : angle,
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value,
                      child: CustomPaint(
                        size: Size(widget.size * 0.72, widget.size * 0.72),
                        painter: _CompassNeedlePainter(searching: isSearching),
                      ),
                    );
                  },
                ),

                // ⚫ 中央ピン
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD6B06A),
                    border: Border.all(
                      color: const Color(0xFF5E4322),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────
// 🌌 外周グロー
// ─────────────────────────────

class _CompassGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 6;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x33D6B06A);

    for (int i = 0; i < 24; i++) {
      final angle = i * (math.pi * 2 / 24);

      final start = Offset(
        center.dx + math.cos(angle) * (radius - 8),
        center.dy + math.sin(angle) * (radius - 8),
      );

      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────
// 🧭 羅針盤盤面
// ─────────────────────────────

class _CompassFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2;

    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x99D6B06A);

    canvas.drawCircle(center, radius - 6, outerPaint);

    final tickPaint = Paint()
      ..strokeWidth = 1
      ..color = const Color(0x66F5EDD8);

    for (int i = 0; i < 360; i += 15) {
      final angle = i * math.pi / 180;

      final major = i % 90 == 0;

      final tickLength = major ? 14.0 : 7.0;

      final start = Offset(
        center.dx + math.cos(angle) * (radius - 26),
        center.dy + math.sin(angle) * (radius - 26),
      );

      final end = Offset(
        center.dx + math.cos(angle) * (radius - 26 + tickLength),
        center.dy + math.sin(angle) * (radius - 26 + tickLength),
      );

      canvas.drawLine(start, end, tickPaint);
    }

    _drawDirection(canvas, center, radius, 'N', -math.pi / 2);

    _drawDirection(canvas, center, radius, 'E', 0);

    _drawDirection(canvas, center, radius, 'S', math.pi / 2);

    _drawDirection(canvas, center, radius, 'W', math.pi);
  }

  void _drawDirection(
    Canvas canvas,
    Offset center,
    double radius,
    String text,
    double angle,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFD6B06A),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    final offset = Offset(
      center.dx + math.cos(angle) * (radius - 34) - painter.width / 2,
      center.dy + math.sin(angle) * (radius - 34) - painter.height / 2,
    );

    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────
// 🪄 羅針盤の針
// ─────────────────────────────

class _CompassNeedlePainter extends CustomPainter {
  final bool searching;

  _CompassNeedlePainter({required this.searching});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final northPaint = Paint()
      ..color = searching ? const Color(0xFFD6B06A) : const Color(0xFFCC4444)
      ..style = PaintingStyle.fill;

    final southPaint = Paint()
      ..color = const Color(0xFF3A2A1E)
      ..style = PaintingStyle.fill;

    final northPath = Path()
      ..moveTo(center.dx, 0)
      ..lineTo(center.dx - 8, center.dy)
      ..lineTo(center.dx, center.dy - 10)
      ..lineTo(center.dx + 8, center.dy)
      ..close();

    final southPath = Path()
      ..moveTo(center.dx, size.height)
      ..lineTo(center.dx - 6, center.dy)
      ..lineTo(center.dx, center.dy + 10)
      ..lineTo(center.dx + 6, center.dy)
      ..close();

    canvas.drawPath(southPath, southPaint);
    canvas.drawPath(northPath, northPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
