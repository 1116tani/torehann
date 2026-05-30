// lib/models/walking_leg_result.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Directions API 徒歩区間の結果（ポリライン + 距離・時間）
class WalkingLegResult {
  final List<LatLng> points;
  final int distanceMeters;
  final int durationSeconds;

  const WalkingLegResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)}km';
    }
    return '${distanceMeters}m';
  }

  String get durationLabel {
    final minutes = (durationSeconds / 60).ceil();
    if (minutes <= 1) return '徒歩1分';
    return '徒歩$minutes分';
  }
}
