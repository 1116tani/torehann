// lib/services/directions_service.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class DirectionsService {
  static final Uri _routesApiUri = Uri.https(
    'routes.googleapis.com',
    '/directions/v2:computeRoutes',
  );

  final _polylinePoints = PolylinePoints();

  /// Google Routes APIから道路に沿った徒歩ルート座標を取得します。
  /// APIキー未設定やAPIエラー時だけ、スポット同士の直線にフォールバックします。
  Future<List<LatLng>> getDirectionsRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> waypoints = const [],
  }) async {
    final fallback = [origin, ...waypoints, destination];
    final apiKey = ApiConstants.googleMapsApiKey;

    if (apiKey.isEmpty) {
      debugPrint('Routes API key is empty. Falling back to straight route.');
      return fallback;
    }

    try {
      final response = await http.post(
        _routesApiUri,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'routes.polyline.encodedPolyline,routes.legs.polyline.encodedPolyline,routes.legs.steps.polyline.encodedPolyline',
        },
        body: jsonEncode({
          'origin': _waypoint(origin),
          'destination': _waypoint(destination),
          if (waypoints.isNotEmpty)
            'intermediates': waypoints.map(_waypoint).toList(),
          'travelMode': 'WALK',
          'computeAlternativeRoutes': false,
          'polylineQuality': 'HIGH_QUALITY',
          'polylineEncoding': 'ENCODED_POLYLINE',
          'languageCode': 'ja',
          'units': 'METRIC',
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Routes API HTTP ${response.statusCode}: ${response.body}');
        return fallback;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return fallback;

      final route = routes.first as Map<String, dynamic>;
      final stepPoints = _decodeStepPolylines(route);
      if (stepPoints.length >= 2) return stepPoints;

      final legPoints = _decodeLegPolylines(route);
      if (legPoints.length >= 2) return legPoints;

      final routePoints = _decodePolyline(
        (route['polyline'] as Map<String, dynamic>?)?['encodedPolyline']
            as String?,
      );
      if (routePoints.length >= 2) return routePoints;
    } catch (e) {
      debugPrint('Routes API fetch failed: $e');
    }

    return fallback;
  }

  Map<String, dynamic> _waypoint(LatLng point) {
    return {
      'location': {
        'latLng': {'latitude': point.latitude, 'longitude': point.longitude},
      },
    };
  }

  List<LatLng> _decodeStepPolylines(Map<String, dynamic> route) {
    final result = <LatLng>[];
    final legs = route['legs'] as List<dynamic>? ?? const [];

    for (final leg in legs) {
      final steps =
          (leg as Map<String, dynamic>)['steps'] as List<dynamic>? ?? const [];
      for (final step in steps) {
        final encoded =
            ((step as Map<String, dynamic>)['polyline']
                    as Map<String, dynamic>?)?['encodedPolyline']
                as String?;
        _appendPoints(result, _decodePolyline(encoded));
      }
    }

    return result;
  }

  List<LatLng> _decodeLegPolylines(Map<String, dynamic> route) {
    final result = <LatLng>[];
    final legs = route['legs'] as List<dynamic>? ?? const [];

    for (final leg in legs) {
      final encoded =
          ((leg as Map<String, dynamic>)['polyline']
                  as Map<String, dynamic>?)?['encodedPolyline']
              as String?;
      _appendPoints(result, _decodePolyline(encoded));
    }

    return result;
  }

  List<LatLng> _decodePolyline(String? encoded) {
    if (encoded == null || encoded.isEmpty) return [];

    return _polylinePoints.decodePolyline(encoded).map((point) {
      return LatLng(point.latitude, point.longitude);
    }).toList();
  }

  void _appendPoints(List<LatLng> target, List<LatLng> points) {
    for (final point in points) {
      if (target.isEmpty || target.last != point) {
        target.add(point);
      }
    }
  }
}

final directionsServiceProvider = Provider<DirectionsService>((ref) {
  return DirectionsService();
});
