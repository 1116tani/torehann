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
    final leg = await getWalkingLeg(origin: origin, destination: destination);
    return leg?.points ?? const [];
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

    // Try Routes API (New)
    for (final apiKey in apiKeys) {
      final result = await _fetchWalkingLegRoutesApi(
        apiKey: apiKey,
        origin: origin,
        destination: destination,
      );
      if (result != null) return result;
    }

    // Try Legacy Directions API
    for (final apiKey in apiKeys) {
      final result = await _fetchWalkingLegHttp(
        apiKey: apiKey,
        origin: origin,
        destination: destination,
      );
      if (result != null) return result;
    }

    return null;
  }

  Future<WalkingLegResult?> _fetchWalkingLegRoutesApi({
    required String apiKey,
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await http.post(
        _routesApiUri,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline,routes.legs.steps.navigationInstruction,routes.legs.steps.distanceMeters,routes.legs.steps.polyline.encodedPolyline',
        },
        body: jsonEncode({
          'origin': _waypoint(origin),
          'destination': _waypoint(destination),
          'travelMode': 'WALK',
          'languageCode': 'ja',
          'units': 'METRIC',
        }),
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      
      final distance = route['distanceMeters'] as num? ?? 0;
      final durationStr = route['duration'] as String? ?? '0s';
      final duration = int.tryParse(durationStr.replaceAll('s', '')) ?? 0;

      final encoded = (route['polyline'] as Map<String, dynamic>?)?['encodedPolyline'] as String?;
      final points = _decodePolyline(encoded);
      
      final steps = <RouteStep>[];
      final legs = route['legs'] as List<dynamic>? ?? const [];
      for (final leg in legs) {
        final stepsData = (leg as Map<String, dynamic>)['steps'] as List<dynamic>? ?? const [];
        for (final sData in stepsData) {
          final step = sData as Map<String, dynamic>;
          final instruction = (step['navigationInstruction'] as Map<String, dynamic>?)?['instructions'] as String? ?? '';
          final dist = step['distanceMeters'] as num? ?? 0;
          steps.add(RouteStep(instruction: instruction, distanceMeters: dist.round()));
        }
      }

      return WalkingLegResult(
        points: points,
        distanceMeters: distance.round(),
        durationSeconds: duration,
        steps: steps,
      );
    } catch (e) {
      debugPrint('[Directions] Routes API failed: $e');
      return null;
    }
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
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';
      if (status != 'OK') return null;

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
      
      final stepsData = leg['steps'] as List<dynamic>? ?? const [];
      final steps = stepsData.map((s) {
        final instruction = (s['html_instructions'] as String? ?? '')
            .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
        final dist = (s['distance'] as Map<String, dynamic>?)?['value'] as num? ?? 0;
        return RouteStep(instruction: instruction, distanceMeters: dist.round());
      }).toList();

      return WalkingLegResult(
        points: points,
        distanceMeters: distance.round(),
        durationSeconds: duration.round(),
        steps: steps,
      );
    } catch (e) {
      debugPrint('[Directions] Legacy API failed: $e');
      return null;
    }
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
