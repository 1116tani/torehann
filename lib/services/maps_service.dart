// lib/services/maps_service.dart

import 'dart:math' as math;

import '../models/spot_model.dart';

class MapsService {
  const MapsService();

  // ─────────────────────────────
  // 🗺️ ルート座標生成
  // ─────────────────────────────

  Future<List<RoutePoint>> getRoutePoints(List<SpotModel> spots) async {
    if (spots.isEmpty) return [];

    try {
      final List<RoutePoint> points = [];

      for (int i = 0; i < spots.length - 1; i++) {
        final start = spots[i];
        final end = spots[i + 1];

        // 📍 スタート地点
        points.add(RoutePoint(lat: start.lat, lng: start.lng));

        // ─────────────────────────────
        // 🌫️ 中間ポイント生成
        // 一本道にならないよう、
        // 少しだけ揺らした軌跡を作る
        // ─────────────────────────────

        final middlePoints = _generateFantasyCurve(start, end);

        points.addAll(middlePoints);
      }

      // 📍 最後の地点
      points.add(RoutePoint(lat: spots.last.lat, lng: spots.last.lng));

      // 💫 演出用ディレイ
      await Future.delayed(const Duration(milliseconds: 400));

      return points;
    } catch (e) {
      throw Exception('ルート軌跡の生成に失敗しました: $e');
    }
  }

  // ─────────────────────────────
  // 🌌 曲線生成
  // ─────────────────────────────

  List<RoutePoint> _generateFantasyCurve(SpotModel start, SpotModel end) {
    final List<RoutePoint> points = [];

    const segmentCount = 4;

    for (int i = 1; i <= segmentCount; i++) {
      final t = i / (segmentCount + 1);

      // 線形補間
      final baseLat = start.lat + (end.lat - start.lat) * t;

      final baseLng = start.lng + (end.lng - start.lng) * t;

      // 🌫️ 揺らぎ演出
      final wave = math.sin(t * math.pi) * 0.00025;

      final curveLat = baseLat + wave;

      final curveLng = baseLng - (wave * 0.8);

      points.add(RoutePoint(lat: curveLat, lng: curveLng));
    }

    return points;
  }
}

// ─────────────────────────────
// 📍 ルートポイント
// ─────────────────────────────

class RoutePoint {
  final double lat;

  final double lng;

  const RoutePoint({required this.lat, required this.lng});
}
