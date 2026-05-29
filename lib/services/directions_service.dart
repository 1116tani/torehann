// lib/services/directions_service.dart

import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class DirectionsService {
  final _polylinePoints = PolylinePoints();

  /// Google Maps Directions API から徒歩ルートの折れ線（Polyline）座標を取得します。
  /// 失敗した場合は、直線（origin -> waypoints -> destination）をフォールバックとして返します。
  Future<List<LatLng>> getDirectionsRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> waypoints = const [],
  }) async {
    final apiKey = ApiConstants.googleMapsApiKey;
    if (apiKey.isEmpty) {
      // APIキーがない場合は直線フォールバック
      return [origin, ...waypoints, destination];
    }

    try {
      final originStr = '${origin.latitude},${origin.longitude}';
      final destStr = '${destination.latitude},${destination.longitude}';

      String waypointsParam = '';
      if (waypoints.isNotEmpty) {
        final formattedWaypoints = waypoints
            .map((w) => '${w.latitude},${w.longitude}')
            .join('|');
        waypointsParam = '&waypoints=$formattedWaypoints';
      }

      final url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$originStr'
          '&destination=$destStr'
          '$waypointsParam'
          '&mode=walking'
          '&language=ja'
          '&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;

        if (status == 'OK') {
          final routes = data['routes'] as List<dynamic>?;
          if (routes != null && routes.isNotEmpty) {
            final overviewPolyline = routes[0]['overview_polyline'] as Map<String, dynamic>?;
            if (overviewPolyline != null) {
              final pointsStr = overviewPolyline['points'] as String?;
              if (pointsStr != null && pointsStr.isNotEmpty) {
                final decodedPoints = _polylinePoints.decodePolyline(pointsStr);
                return decodedPoints
                    .map((p) => LatLng(p.latitude, p.longitude))
                    .toList();
              }
            }
          }
        }
      }
    } catch (_) {
      // ネットワークエラー等の場合は直線フォールバックに移行
    }

    // フォールバック処理
    return [origin, ...waypoints, destination];
  }
}

// ─────────────────────────────
// 🛰️ Provider 登録
// ─────────────────────────────
final directionsServiceProvider = Provider<DirectionsService>((ref) {
  return DirectionsService();
});
