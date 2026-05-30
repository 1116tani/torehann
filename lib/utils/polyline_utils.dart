// lib/utils/polyline_utils.dart

import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// ポリライン上の最短距離（メートル）を返す
double distanceToPolylineMeters(LatLng point, List<LatLng> polyline) {
  if (polyline.isEmpty) return double.infinity;
  if (polyline.length == 1) {
    return Geolocator.distanceBetween(
      point.latitude,
      point.longitude,
      polyline.first.latitude,
      polyline.first.longitude,
    );
  }

  var minDistance = double.infinity;
  for (var i = 0; i < polyline.length - 1; i++) {
    final d = _distanceToSegmentMeters(point, polyline[i], polyline[i + 1]);
    if (d < minDistance) minDistance = d;
  }
  return minDistance;
}

double _distanceToSegmentMeters(LatLng p, LatLng a, LatLng b) {
  final ax = a.longitude;
  final ay = a.latitude;
  final bx = b.longitude;
  final by = b.latitude;
  final px = p.longitude;
  final py = p.latitude;

  final dx = bx - ax;
  final dy = by - ay;

  if (dx == 0 && dy == 0) {
    return Geolocator.distanceBetween(py, px, ay, ax);
  }

  final t = ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy);
  final clamped = t.clamp(0.0, 1.0);
  final projLat = ay + clamped * dy;
  final projLng = ax + clamped * dx;

  return Geolocator.distanceBetween(py, px, projLat, projLng);
}

String formatDistance(double meters) {
  if (meters >= 1000) {
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }
  return '${meters.round()}m';
}

String formatWalkingDuration(int seconds) {
  final minutes = math.max(1, (seconds / 60).ceil());
  return '徒歩$minutes分';
}
