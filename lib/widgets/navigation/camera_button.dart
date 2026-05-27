// lib/widgets/navigation/camera_button.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class CameraButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;

  const CameraButton({
    super.key,
    required this.onPressed,
    this.size = 72.0,
  });

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // 周囲の魔法陣を回転させるアニメーション
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: widget.size + 24,
          height: widget.size + 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1️⃣ 背後で光り、ゆっくり回る魔法サークル（カスタムペイント）
              RotationTransition(
                turns: _rotationController,
                child: CustomPaint(
                  size: Size(widget.size + 24, widget.size + 24),
                  painter: _MagicCirclePainter(),
                ),
              ),

              // 2️⃣ ボタン本体（金枠＋ガラス風デザイン）
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF3D2B1F), // 中央部
                      Color(0xFF2C2318), // 縁部
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFC8A97A),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8A97A).withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.photo_camera,
                    color: Color(0xFFF5EDD8),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 💮 シャッターの背景で回る魔導の幾何学サークルを描画するペインター
class _MagicCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 2;

    // 外側の点線円
    final dashPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const int dashCount = 36;
    for (int i = 0; i < dashCount; i++) {
      final angleStart = i * (2 * math.pi / dashCount);
      final angleEnd = angleStart + (math.pi / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: maxRadius),
        angleStart,
        angleEnd - angleStart,
        false,
        dashPaint,
      );
    }

    // 内側の補助円
    canvas.drawCircle(center, maxRadius - 6, paint..color = const Color(0xFFC8A97A).withValues(alpha: 0.3));

    // 星型（十二角形の幾何学線）
    final path = Path();
    const int points = 12;
    for (int i = 0; i < points; i++) {
      final angle = i * (2 * math.pi / points);
      // 隣り合う頂点ではなく、5つ隣の頂点と結ぶことで美しい多角形の星を作る
      final nextAngle = (i + 5) * (2 * math.pi / points);

      final p1 = Offset(
        center.dx + math.cos(angle) * (maxRadius - 3),
        center.dy + math.sin(angle) * (maxRadius - 3),
      );
      final p2 = Offset(
        center.dx + math.cos(nextAngle) * (maxRadius - 3),
        center.dy + math.sin(nextAngle) * (maxRadius - 3),
      );

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
    }
    path.close();
    canvas.drawPath(path, paint..color = const Color(0xFFC8A97A).withValues(alpha: 0.18));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
