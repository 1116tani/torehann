// lib/widgets/navigation/compass_widget.dart
import 'dart:math' as math;
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
    this.size = 180,
  });

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  double _lastAngle = 0.0;

  @override
  void initState() {
    super.initState();
    // 羅針盤が探索中（ターゲット未定・位置不明）のときにゆっくり回るアニメーション
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  double _calculateBearing() {
    if (widget.currentPosition == null || widget.targetSpot == null) {
      return 0.0;
    }

    // Geolocatorを使って目的地への方位角（真北基準で時計回りの角度 -180〜+180）を計算する
    final bearing = Geolocator.bearingBetween(
      widget.currentPosition!.latitude,
      widget.currentPosition!.longitude,
      widget.targetSpot!.lat,
      widget.targetSpot!.lng,
    );

    // ラジアンに変換 (360度表記へ補正)
    final radians = bearing * (math.pi / 180.0);
    _lastAngle = radians;
    return radians;
  }

  @override
  Widget build(BuildContext context) {
    final isScanning = widget.currentPosition == null || widget.targetSpot == null;
    final angle = _calculateBearing();

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2C2318), // ダークウッド
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFFC8A97A).withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1️⃣ 羅針盤の盤面（背景・目盛り）
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CompassFacePainter(),
          ),

          // 2️⃣ 針の回転（探索中はスピン、検知時は目的地の方角へアニメーション）
          AnimatedBuilder(
            animation: _spinController,
            builder: (context, child) {
              final finalAngle = isScanning 
                  ? _spinController.value * 2 * math.pi 
                  : angle;

              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: _lastAngle, end: finalAngle),
                duration: Duration(milliseconds: isScanning ? 0 : 500),
                curve: Curves.easeOutBack,
                builder: (context, animatedAngle, child) {
                  return Transform.rotate(
                    angle: animatedAngle,
                    child: CustomPaint(
                      size: Size(widget.size * 0.8, widget.size * 0.8),
                      painter: _CompassNeedlePainter(isScanning: isScanning),
                    ),
                  );
                },
              );
            },
          ),

          // 3️⃣ センターピン (金属鋲)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE4C38E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(color: const Color(0xFF8B6C3F), width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// 🧭 羅針盤のアンティークな盤面を描画するペインター
class _CompassFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. 外殻の金枠
    final goldPaint = Paint()
      ..color = const Color(0xFFC8A97A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius - 4, goldPaint);

    final thinGoldPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius - 10, thinGoldPaint);

    // 2. 内側の古紙調円形
    final bgPaint = Paint()
      ..color = const Color(0xFF3D2B1F).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 11, bgPaint);

    // 3. 羅針盤の目盛り（5度刻みの細線と、15度ごとの中線、30度ごとの太線）
    final tickPaint = Paint()
      ..color = const Color(0xFF8B7355).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 360; i += 15) {
      final angle = i * math.pi / 180;
      final isMajor = i % 90 == 0;
      final isMedium = i % 45 == 0 && !isMajor;

      final tickLength = isMajor ? 12.0 : (isMedium ? 8.0 : 5.0);
      tickPaint.strokeWidth = isMajor ? 1.5 : 1.0;
      tickPaint.color = isMajor ? const Color(0xFFC8A97A) : const Color(0xFF8B7355).withValues(alpha: 0.7);

      final startPos = Offset(
        center.dx + math.cos(angle) * (radius - 12 - tickLength),
        center.dy + math.sin(angle) * (radius - 12 - tickLength),
      );
      final endPos = Offset(
        center.dx + math.cos(angle) * (radius - 12),
        center.dy + math.sin(angle) * (radius - 12),
      );
      canvas.drawLine(startPos, endPos, tickPaint);
    }

    // 4. 方位文字 (N, E, S, W) の描画
    const textStyle = TextStyle(
      color: Color(0xFFE4C38E),
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
      fontSize: 13,
      letterSpacing: 1.0,
    );

    final directions = {
      'N': -math.pi / 2,
      'E': 0.0,
      'S': math.pi / 2,
      'W': math.pi,
    };

    directions.forEach((text, angle) {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 文字を円周上に綺麗に配置
      final offsetRadius = radius - 32;
      final textPos = Offset(
        center.dx + math.cos(angle) * offsetRadius - textPainter.width / 2,
        center.dy + math.sin(angle) * offsetRadius - textPainter.height / 2,
      );
      textPainter.paint(canvas, textPos);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧭 羅針盤の「魔導の針」を描画するペインター
class _CompassNeedlePainter extends CustomPainter {
  final bool isScanning;

  _CompassNeedlePainter({required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final length = size.width / 2;

    // 針のパスを作成 (魔導の槍・スピアヘッド風の鋭利な形状)
    final northPath = Path();
    northPath.moveTo(center.dx, center.dy);
    northPath.lineTo(center.dx - 6, center.dy - 10);
    northPath.lineTo(center.dx - 2, center.dy - length + 10);
    northPath.lineTo(center.dx, center.dy - length); // 北を指す鋭い先端
    northPath.lineTo(center.dx + 2, center.dy - length + 10);
    northPath.lineTo(center.dx + 6, center.dy - 10);
    northPath.close();

    // 影付きの北指針（ルビーレッドか魔法のゴールド）
    final northPaint = Paint()
      ..color = isScanning 
          ? const Color(0xFFC8A97A) // 探索中はゴールド
          : const Color(0xFFCC3333) // 検知時は赤く光る！
      ..style = PaintingStyle.fill;
    
    // 北指針の立体感を出すための半分影
    final northShadowPath = Path();
    northShadowPath.moveTo(center.dx, center.dy);
    northShadowPath.lineTo(center.dx - 6, center.dy - 10);
    northShadowPath.lineTo(center.dx - 2, center.dy - length + 10);
    northShadowPath.lineTo(center.dx, center.dy - length);
    northShadowPath.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    // 南指針 (青銅または闇黒の針)
    final southPath = Path();
    southPath.moveTo(center.dx, center.dy);
    southPath.lineTo(center.dx - 5, center.dy + 10);
    southPath.lineTo(center.dx - 1, center.dy + length - 10);
    southPath.lineTo(center.dx, center.dy + length); // 南を指す先端
    southPath.lineTo(center.dx + 1, center.dy + length - 10);
    southPath.lineTo(center.dx + 5, center.dy + 10);
    southPath.close();

    final southPaint = Paint()
      ..color = const Color(0xFF4A3728) // 深い古木色
      ..style = PaintingStyle.fill;

    // 描画実行
    canvas.drawPath(southPath, southPaint);
    canvas.drawPath(northPath, northPaint);
    canvas.drawPath(northShadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
