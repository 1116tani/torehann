// lib/services/navigation_service.dart

import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../models/spot_model.dart';
import '../services/location_service.dart';

class NavigationService {
  final LocationService _locationService;

  NavigationService(this._locationService);

  // ─────────────────────────────
  // 📍 目的地までの距離
  // meter
  // ─────────────────────────────

  double calculateDistanceToSpot({
    required Position currentPosition,
    required SpotModel spot,
  }) {
    return _locationService.calculateDistance(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: spot.lat,
      endLng: spot.lng,
    );
  }

  // ─────────────────────────────
  // 🧭 目的地の方角
  // degree
  // ─────────────────────────────

  double calculateBearingToSpot({
    required Position currentPosition,
    required SpotModel spot,
  }) {
    return _locationService.calculateBearing(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: spot.lat,
      endLng: spot.lng,
    );
  }

  // ─────────────────────────────
  // ✨ 到達判定
  // ─────────────────────────────

  bool isArrivedAtSpot({
    required Position currentPosition,
    required SpotModel spot,

    // 到達半径
    double arrivalDistance = 20,
  }) {
    final distance = calculateDistanceToSpot(
      currentPosition: currentPosition,
      spot: spot,
    );

    return distance <= arrivalDistance;
  }

  // ─────────────────────────────
  // 🗺️ 最寄りスポット取得
  // ─────────────────────────────

  SpotModel? findNearestSpot({
    required Position currentPosition,
    required List<SpotModel> spots,
  }) {
    if (spots.isEmpty) return null;

    SpotModel nearestSpot = spots.first;

    double nearestDistance = calculateDistanceToSpot(
      currentPosition: currentPosition,
      spot: nearestSpot,
    );

    for (final spot in spots) {
      final distance = calculateDistanceToSpot(
        currentPosition: currentPosition,
        spot: spot,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestSpot = spot;
      }
    }

    return nearestSpot;
  }

  // ─────────────────────────────
  // 🧭 次スポット取得
  // 未訪問の先頭を返す
  // ─────────────────────────────

  SpotModel? getNextSpot({
    required List<SpotModel> routeSpots,
    required Set<String> visitedSpotIds,
  }) {
    try {
      return routeSpots.firstWhere((spot) => !visitedSpotIds.contains(spot.id));
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────
  // 📜 進行率
  // 0.0 ~ 1.0
  // ─────────────────────────────

  double calculateProgress({
    required int visitedCount,
    required int totalCount,
  }) {
    if (totalCount == 0) return 0;

    return visitedCount / totalCount;
  }

  // ─────────────────────────────
  // 🧭 コンパス回転角
  // ラジアン変換
  // ─────────────────────────────

  double bearingToRadians(double bearing) {
    return bearing * (math.pi / 180);
  }

  // ─────────────────────────────
  // 📍 表示用距離テキスト
  // ─────────────────────────────

  String formatDistance(double distance) {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }

    return '${distance.toStringAsFixed(0)} m';
  }

  // ─────────────────────────────
  // ✨ 距離に応じた探索状態
  // ─────────────────────────────

  String getDistanceDescription(double distance) {
    if (distance <= 20) {
      return 'すぐ近くに反応があります';
    }

    if (distance <= 50) {
      return '強い痕跡を感じます';
    }

    if (distance <= 150) {
      return '微かな気配があります';
    }

    if (distance <= 300) {
      return '遠くで何かが呼んでいます';
    }

    return '霧の向こうに目的地があります';
  }
}
