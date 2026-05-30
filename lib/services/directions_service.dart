// lib/services/directions_service.dart

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/walking_leg_result.dart';

class DirectionsService {
  static final Uri _routesApiUri = Uri.https(
    'routes.googleapis.com',
    '/directions/v2:computeRoutes',
  );

  static final Uri _legacyDirectionsUri =
      Uri.https('maps.googleapis.com', '/maps/api/directions/json');

  final _polylinePoints = PolylinePoints();

  Future<List<LatLng>> getDirectionsRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> waypoints = const [],
  }) async {
    final apiKeys = _candidateApiKeys();

    if (apiKeys.isEmpty) {
      debugPrint('Routes API key is empty.');
      return const [];
    }

    for (final apiKey in apiKeys) {
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
          debugPrint(
            'Routes API HTTP ${response.statusCode}: ${response.body}',
          );
          continue;
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>? ?? const [];
        if (routes.isEmpty) continue;

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
    }

    return const [];
  }

  Future<List<LatLng>> getMultiStopWalkingRoute(List<LatLng> stops) async {
    if (stops.isEmpty) return const [];
    if (stops.length == 1) return stops;

    final merged = <LatLng>[];
    for (var i = 0; i < stops.length - 1; i++) {
      final segment = await getDirectionsRoute(
        origin: stops[i],
        destination: stops[i + 1],
      );
      _appendPoints(merged, segment);
    }

    return merged;
  }

  /// Google Directions API（mode=walking）で区間のルート・距離・時間を取得
  Future<WalkingLegResult?> getWalkingLeg({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final apiKeys = _candidateApiKeys();
    if (apiKeys.isEmpty) {
      debugPrint('[Directions] API key is empty.');
      return null;
    }

    for (final apiKey in apiKeys) {
      final result = await _fetchWalkingLegHttp(
        apiKey: apiKey,
        origin: origin,
        destination: destination,
      );
      if (result != null) return result;
    }

    final points = await getDirectionsRoute(
      origin: origin,
      destination: destination,
    );
    if (points.length >= 2) {
      final distance = _estimatePathMeters(points);
      return WalkingLegResult(
        points: points,
        distanceMeters: distance.round(),
        durationSeconds: (distance / 1.25).round(),
      );
    }

    return null;
  }

  Future<WalkingLegResult?> _fetchWalkingLegHttp({
    required String apiKey,
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final uri = _legacyDirectionsUri.replace(
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'mode': 'walking',
          'key': apiKey,
          'language': 'ja',
        },
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        debugPrint('[Directions] HTTP ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';
      if (status != 'OK') {
        debugPrint('[Directions] status=$status ${data['error_message']}');
        return null;
      }

      final routes = data['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      final legs = route['legs'] as List<dynamic>? ?? const [];
      if (legs.isEmpty) return null;

      final leg = legs.first as Map<String, dynamic>;
      final distance =
          (leg['distance'] as Map<String, dynamic>?)?['value'] as num? ?? 0;
      final duration =
          (leg['duration'] as Map<String, dynamic>?)?['value'] as num? ?? 0;

      final encoded = (route['overview_polyline']
              as Map<String, dynamic>?)?['points']
          as String?;
      final points = _decodePolyline(encoded);
      if (points.length < 2) return null;

      return WalkingLegResult(
        points: points,
        distanceMeters: distance.round(),
        durationSeconds: duration.round(),
      );
    } catch (e) {
      debugPrint('[Directions] walking leg failed: $e');
      return null;
    }
  }

  double _estimatePathMeters(List<LatLng> points) {
    var total = 0.0;
    for (var i = 0; i < points.length - 1; i++) {
      total += _haversineMeters(points[i], points[i + 1]);
    }
    return total;
  }

  double _haversineMeters(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final dLat = _toRad(b.latitude - a.latitude);
    final dLng = _toRad(b.longitude - a.longitude);
    final lat1 = _toRad(a.latitude);
    final lat2 = _toRad(b.latitude);
    final h = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  double _toRad(double deg) => deg * math.pi / 180.0;

  List<String> _candidateApiKeys() {
    return [
      ApiConstants.googleDirectionsApiKey.trim(),
      ApiConstants.googleMapsApiKey.trim(),
      ApiConstants.googlePlacesApiKey.trim(),
    ].where((key) => key.isNotEmpty).toSet().toList(growable: false);
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
