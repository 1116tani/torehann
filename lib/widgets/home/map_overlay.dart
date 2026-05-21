// lib/widgets/home/map_overlay.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // 💡 羅針盤を描くために数学の魔法を使うよ！

class MapOverlay extends StatelessWidget {
  const MapOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned.fill(
      // 💡 IgnorePointerを入れることで、この層をすり抜けて下のマップを操作できるよ！
      child: IgnorePointer(
        child: Container(
          // 📜 画面のフチを少し暗くして、古いレンズや羊皮紙を覗き込んでいる風にする魔法
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                Colors.transparent,
                theme.scaffoldBackgroundColor.withValues(
                  alpha: 0.8,
                ), // フチを背景色（闇色）で締める
              ],
              stops: const [0.4, 1.0],
            ),
          ),
          child: Opacity(
            opacity: 0.35, // 💡 うっすらと魔法陣を浮かび上がらせるよ
            child: CustomPaint(
              size: Size.infinite,
              painter: _AntiqueCompassPainter(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}

// 🧭 羅針盤と古い地図のグリッドを描く特製ペインター
class _AntiqueCompassPainter extends CustomPainter {
  final Color color;
  _AntiqueCompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 1️⃣ 外側の魔法円を描く
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius - 10, paint..strokeWidth = 0.5);

    // 2️⃣ 羅針盤のトゲトゲ（8方位）を描く
    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      // 斜め方向は少し線を短くするオシャレ
      final innerRadius = i % 2 == 0 ? radius * 0.8 : radius * 0.9;

      final p1 = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(p1, p2, paint);
    }

    // 3️⃣ 背景にうっすらとした緯度・経度の海図グリッドを引く
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const double step = 60.0; // ちょっと広めのマス目にしてアンティーク感アップ

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
