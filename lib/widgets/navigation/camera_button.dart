// lib/widgets/navigation/camera_button.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_shadows.dart';

// ─────────────────────────────
// 📸 Camera Button
// ─────────────────────────────

class CameraButton extends StatefulWidget {
  final VoidCallback onPressed;

  final double size;

  final bool showPulse;

  const CameraButton({
    super.key,
    required this.onPressed,
    this.size = 72,
    this.showPulse = true,
  });

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;

  late final AnimationController _pulseController;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // ─────────────────────────
    // 🔄 魔法陣回転
    // ─────────────────────────

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    // ─────────────────────────
    // ✨ 外側パルス
    // ─────────────────────────

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();

    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSize = widget.size + 28;

    return AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: AppDurations.fast,

      curve: Curves.easeOut,

      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },

        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },

        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },

        onTap: widget.onPressed,

        child: SizedBox(
          width: totalSize,
          height: totalSize,

          child: Stack(
            alignment: Alignment.center,

            children: [
              // ─────────────────────
              // ✨ 呼吸する光
              // ─────────────────────
              if (widget.showPulse)
                AnimatedBuilder(
                  animation: _pulseController,

                  builder: (_, __) {
                    final pulse = _pulseController.value;

                    return Container(
                      width: widget.size + (pulse * 16),

                      height: widget.size + (pulse * 16),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: 0.10 - (pulse * 0.05),
                            ),

                            blurRadius: 28 + (pulse * 12),

                            spreadRadius: 4 + (pulse * 4),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // ─────────────────────
              // 🪄 魔法陣
              // ─────────────────────
              RotationTransition(
                turns: _rotationController,

                child: CustomPaint(
                  size: Size(totalSize, totalSize),

                  painter: _MagicCirclePainter(),
                ),
              ),

              // ─────────────────────
              // 📸 本体
              // ─────────────────────
              Container(
                width: widget.size,
                height: widget.size,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const RadialGradient(
                    colors: [Color(0xFF473526), Color(0xFF2B2118)],

                    radius: 0.95,
                  ),

                  border: Border.all(color: AppColors.primary, width: 2),

                  boxShadow: AppShadows.goldGlow,
                ),

                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    // 内側リング
                    Container(
                      width: widget.size - 10,

                      height: widget.size - 10,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.18),
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.photo_camera,

                      color: AppColors.textPrimary,

                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────
// 🪄 Magic Circle Painter
// ─────────────────────────────

class _MagicCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 2;

    // ─────────────────────────
    // 外円
    // ─────────────────────────

    final outerPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, outerPaint);

    // ─────────────────────────
    // 点線リング
    // ─────────────────────────

    final dashPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashCount = 32;

    for (int i = 0; i < dashCount; i++) {
      final start = i * (2 * math.pi / dashCount);

      const sweep = 0.08;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),

        start,

        sweep,

        false,

        dashPaint,
      );
    }

    // ─────────────────────────
    // 星型ライン
    // ─────────────────────────

    final starPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();

    const points = 12;

    for (int i = 0; i < points; i++) {
      final angle = i * (2 * math.pi / points);

      final targetAngle = (i + 5) * (2 * math.pi / points);

      final p1 = Offset(
        center.dx + math.cos(angle) * (radius - 8),

        center.dy + math.sin(angle) * (radius - 8),
      );

      final p2 = Offset(
        center.dx + math.cos(targetAngle) * (radius - 8),

        center.dy + math.sin(targetAngle) * (radius - 8),
      );

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      }

      path.lineTo(p2.dx, p2.dy);
    }

    path.close();

    canvas.drawPath(path, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
