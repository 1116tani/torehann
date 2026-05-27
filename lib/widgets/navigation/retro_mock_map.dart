// lib/widgets/navigation/retro_mock_map.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/spot_model.dart';

class RetroMockMap extends StatelessWidget {
  final Position? currentPosition;
  final List<SpotModel> spots;
  final Set<String> visitedSpotIds;
  final SpotModel? nextSpot;

  const RetroMockMap({
    super.key,
    required this.currentPosition,
    required this.spots,
    required this.visitedSpotIds,
    required this.nextSpot,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Container(
        color: const Color(0xFF2C2318),
        child: const Center(
          child: Text(
            '地図を展開しています...',
            style: TextStyle(color: Color(0xFFC8A97A)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double mapSize = math.max(constraints.maxWidth, constraints.maxHeight) * 1.5;

        // 💡 InteractiveViewerを使うことで、キャンバスの拡大縮小・ドラッグ移動を標準でサポート！
        return Container(
          color: const Color(0xFF2C2318), // 闇背景
          child: InteractiveViewer(
            maxScale: 4.0,
            minScale: 0.5,
            boundaryMargin: EdgeInsets.all(mapSize * 0.2),
            child: SizedBox(
              width: mapSize,
              height: mapSize,
              child: Stack(
                children: [
                  // 1️⃣ 羊皮紙のグリッド背景と経路ラインの描画
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RetroMapPainter(
                        spots: spots,
                        visitedSpotIds: visitedSpotIds,
                        currentPosition: currentPosition,
                        nextSpot: nextSpot,
                      ),
                    ),
                  ),

                  // 2️⃣ スポット＆プレイヤーアイコンを重ねる
                  ..._buildMapElements(mapSize),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 緯度経度からキャンバス上のXY座標に変換するマッピング関数
  Offset _mapLatLngToOffset(double lat, double lng, double size) {
    // 描画する全座標の範囲を求める
    double minLat = spots.map((s) => s.lat).reduce(math.min);
    double maxLat = spots.map((s) => s.lat).reduce(math.max);
    double minLng = spots.map((s) => s.lng).reduce(math.min);
    double maxLng = spots.map((s) => s.lng).reduce(math.max);

    if (currentPosition != null) {
      minLat = math.min(minLat, currentPosition!.latitude);
      maxLat = math.max(maxLat, currentPosition!.latitude);
      minLng = math.min(minLng, currentPosition!.longitude);
      maxLng = math.max(maxLng, currentPosition!.longitude);
    }

    // 範囲が狭すぎる場合（同じ地点など）のセーフガード
    final latRange = (maxLat - minLat).abs() < 0.0001 ? 0.001 : (maxLat - minLat);
    final lngRange = (maxLng - minLng).abs() < 0.0001 ? 0.001 : (maxLng - minLng);

    // 余白（マージン）を15%持たせる
    const paddingFactor = 0.2;
    final padding = size * paddingFactor;
    final drawSize = size - (padding * 2);

    // 緯度はY軸（上が大きく下に進むにつれて小さくなるため逆転させる）
    final double y = padding + drawSize - ((lat - minLat) / latRange) * drawSize;
    // 経度はX軸
    final double x = padding + ((lng - minLng) / lngRange) * drawSize;

    return Offset(x, y);
  }

  List<Widget> _buildMapElements(double size) {
    final elements = <Widget>[];

    // 🟢 スポットピンの配置
    for (int i = 0; i < spots.length; i++) {
      final spot = spots[i];
      final pos = _mapLatLngToOffset(spot.lat, spot.lng, size);
      final isVisited = visitedSpotIds.contains(spot.id);
      final isNext = nextSpot?.id == spot.id;

      elements.add(
        Positioned(
          left: pos.dx - 24,
          top: pos.dy - 48,
          child: _MapPinWidget(
            index: i + 1,
            isVisited: isVisited,
            isNext: isNext,
            spot: spot,
          ),
        ),
      );
    }

    // 🛰️ プレイヤーの現在地ピン配置
    if (currentPosition != null) {
      final playerPos = _mapLatLngToOffset(
        currentPosition!.latitude,
        currentPosition!.longitude,
        size,
      );

      elements.add(
        Positioned(
          left: playerPos.dx - 18,
          top: playerPos.dy - 18,
          child: const _PlayerMarkerWidget(),
        ),
      );
    }

    return elements;
  }
}

// 📜 地図の背景グリッド・方位線・経路を描画するペインター
class _RetroMapPainter extends CustomPainter {
  final List<SpotModel> spots;
  final Set<String> visitedSpotIds;
  final Position? currentPosition;
  final SpotModel? nextSpot;

  _RetroMapPainter({
    required this.spots,
    required this.visitedSpotIds,
    required this.currentPosition,
    required this.nextSpot,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3D2B1F)
      ..style = PaintingStyle.fill;

    // 1. 全体をセピア木調背景に
    canvas.drawRect(Offset.zero & size, paint);

    final linePaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // 2. 海図風の放射状ガイドライン（グリッド）を描画
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.25, linePaint);
    canvas.drawCircle(center, size.width * 0.4, linePaint);

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * size.width,
          center.dy + math.sin(angle) * size.width,
        ),
        linePaint,
      );
    }

    // 3. ルート全体の接続ライン（鎖のような点線）
    final pathPaint = Paint()
      ..color = const Color(0xFFC8A97A).withValues(alpha: 0.45)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < spots.length - 1; i++) {
      final p1 = _mapLatLngToOffset(spots[i].lat, spots[i].lng, size.width);
      final p2 = _mapLatLngToOffset(spots[i+1].lat, spots[i+1].lng, size.width);

      // 点線を描画する
      _drawDashedLine(canvas, p1, p2, pathPaint);
    }
  }

  // 点線の描画ヘルパー
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 6.0;
    const double dashSpace = 4.0;

    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double distance = math.sqrt(dx * dx + dy * dy);

    double xMultiplier = dx / distance;
    double yMultiplier = dy / distance;

    double currentDist = 0.0;
    while (currentDist < distance) {
      canvas.drawLine(
        Offset(p1.dx + currentDist * xMultiplier, p1.dy + currentDist * yMultiplier),
        Offset(
          p1.dx + math.min(currentDist + dashWidth, distance) * xMultiplier,
          p1.dy + math.min(currentDist + dashWidth, distance) * yMultiplier,
        ),
        paint,
      );
      currentDist += dashWidth + dashSpace;
    }
  }

  // 同等のマッピング関数（Painter内での描画用）
  Offset _mapLatLngToOffset(double lat, double lng, double size) {
    double minLat = spots.map((s) => s.lat).reduce(math.min);
    double maxLat = spots.map((s) => s.lat).reduce(math.max);
    double minLng = spots.map((s) => s.lng).reduce(math.min);
    double maxLng = spots.map((s) => s.lng).reduce(math.max);

    if (currentPosition != null) {
      minLat = math.min(minLat, currentPosition!.latitude);
      maxLat = math.max(maxLat, currentPosition!.latitude);
      minLng = math.min(minLng, currentPosition!.longitude);
      maxLng = math.max(maxLng, currentPosition!.longitude);
    }

    final latRange = (maxLat - minLat).abs() < 0.0001 ? 0.001 : (maxLat - minLat);
    final lngRange = (maxLng - minLng).abs() < 0.0001 ? 0.001 : (maxLng - minLng);

    const paddingFactor = 0.2;
    final padding = size * paddingFactor;
    final drawSize = size - (padding * 2);

    final double y = padding + drawSize - ((lat - minLat) / latRange) * drawSize;
    final double x = padding + ((lng - minLng) / lngRange) * drawSize;

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant _RetroMapPainter oldDelegate) {
    return oldDelegate.currentPosition != currentPosition ||
        oldDelegate.visitedSpotIds.length != visitedSpotIds.length ||
        oldDelegate.nextSpot?.id != nextSpot?.id;
  }
}

// 📍 個別スポットを描画するピンWidget
class _MapPinWidget extends StatelessWidget {
  final int index;
  final bool isVisited;
  final bool isNext;
  final SpotModel spot;

  const _MapPinWidget({
    required this.index,
    required this.isVisited,
    required this.isNext,
    required this.spot,
  });

  @override
  Widget build(BuildContext context) {
    Color pinColor = const Color(0xFF7A5C3A); // 未開放（グレー茶）
    if (isVisited) {
      pinColor = const Color(0xFFB8860B); // 訪問済み（ダークゴールド）
    } else if (isNext) {
      pinColor = const Color(0xFFCC3333); // 現在の標的（アクティブレッド）
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ピンの吹き出し
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2318),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: pinColor, width: 1),
          ),
          child: Text(
            spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name,
            style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 9),
          ),
        ),
        const SizedBox(height: 2),

        // ピンアイコン本体
        Stack(
          alignment: Alignment.center,
          children: [
            if (isNext)
              // 現在の目的地なら波動を広げるアニメーション（モック用）
              const _PulseCircle(),
            Icon(
              isVisited ? Icons.check_circle : (isNext ? Icons.location_on : Icons.stars),
              color: pinColor,
              size: isNext ? 32 : 24,
            ),
          ],
        ),
      ],
    );
  }
}

// 波動を広げるサークル
class _PulseCircle extends StatefulWidget {
  const _PulseCircle();

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 32 + (24 * _controller.value),
          height: 32 + (24 * _controller.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFCC3333).withValues(alpha: 0.3 * (1.0 - _controller.value)),
          ),
        );
      },
    );
  }
}

// 🛰️ 現在地を示すマーカー
class _PlayerMarkerWidget extends StatelessWidget {
  const _PlayerMarkerWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 外側の青いグロー
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF57D6C9).withValues(alpha: 0.35),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF57D6C9).withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
        ),
        // 内側の白丸
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        // コアとなる青いドット
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF57D6C9),
          ),
        ),
      ],
    );
  }
}
