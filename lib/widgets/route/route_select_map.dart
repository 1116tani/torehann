// lib/widgets/route/route_select_map.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/route_model.dart';
import '../../models/spot_model.dart';
import '../../services/directions_service.dart';

/// ルート選択画面用フルスクリーンマップ。
/// 複数ルートのポリライン表示・選択強調・カメラ追従・タップ切替を担う。
class RouteSelectMap extends ConsumerStatefulWidget {
  final List<RouteModel> routes;
  final Map<String, SpotModel> spots;
  final String? selectedRouteId;
  final String? mapStyle;
  final double topInset;
  final double bottomInset;
  final ValueChanged<String> onRouteTapped;
  final void Function(GoogleMapController controller)? onMapCreated;

  const RouteSelectMap({
    super.key,
    required this.routes,
    required this.spots,
    required this.selectedRouteId,
    required this.mapStyle,
    required this.topInset,
    required this.bottomInset,
    required this.onRouteTapped,
    this.onMapCreated,
  });

  @override
  ConsumerState<RouteSelectMap> createState() => _RouteSelectMapState();
}

class _RouteSelectMapState extends ConsumerState<RouteSelectMap> {
  GoogleMapController? _mapController;
  final Map<String, List<LatLng>> _routeLines = {};

  static const _defaultPosition = LatLng(35.681236, 139.767125);
  static const _routeEmerald = Color(0xFF34F26A);
  static const _routeEmeraldGlow = Color(0xFF57D6C9);

  @override
  void initState() {
    super.initState();
    _fetchAllRoutes();
  }

  @override
  void didUpdateWidget(covariant RouteSelectMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final routesChanged = !_sameRoutes(oldWidget.routes, widget.routes);
    if (routesChanged) {
      _fetchAllRoutes();
      return;
    }

    if (oldWidget.selectedRouteId != widget.selectedRouteId &&
        widget.selectedRouteId != null) {
      _animateToRoute(widget.selectedRouteId!);
    }
  }

  bool _sameRoutes(List<RouteModel> a, List<RouteModel> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id ||
          a[i].spotIds.join(',') != b[i].spotIds.join(',')) {
        return false;
      }
    }
    return true;
  }

  List<SpotModel> _routeSpots(RouteModel route) {
    final fromIds = route.spotIds
        .map((id) => widget.spots[id])
        .whereType<SpotModel>()
        .toList(growable: false);

    if (fromIds.isNotEmpty) return fromIds;
    return route.generatedSpots;
  }

  Future<void> _fetchAllRoutes() async {
    if (widget.routes.isEmpty) return;

    final routesSnapshot = List<RouteModel>.from(widget.routes);
    final directions = ref.read(directionsServiceProvider);
    final lines = <String, List<LatLng>>{};

    await Future.wait(
      routesSnapshot.map((route) async {
        final routeSpots = _routeSpots(route);
        if (routeSpots.isEmpty) {
          lines[route.id] = const [];
          return;
        }

        if (routeSpots.length == 1) {
          lines[route.id] = [
            LatLng(routeSpots.first.lat, routeSpots.first.lng),
          ];
          return;
        }

        final stops = routeSpots
            .map((spot) => LatLng(spot.lat, spot.lng))
            .toList(growable: false);

        lines[route.id] = await directions.getMultiStopWalkingRoute(stops);
      }),
    );

    if (!mounted) return;

    setState(() {
      _routeLines
        ..clear()
        ..addAll(lines);
    });

    final selectedId =
        widget.selectedRouteId ?? routesSnapshot.firstOrNull?.id;
    if (selectedId != null) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (mounted) _animateToRoute(selectedId);
    }
  }

  LatLng _initialTarget() {
    final selected = widget.selectedRouteId;
    if (selected != null) {
      final cached = _routeLines[selected];
      if (cached != null && cached.isNotEmpty) return cached.first;
    }

    for (final route in widget.routes) {
      final spots = _routeSpots(route);
      if (spots.isNotEmpty) {
        return LatLng(spots.first.lat, spots.first.lng);
      }
    }

    return _defaultPosition;
  }

  Future<void> _animateToRoute(String routeId) async {
    final controller = _mapController;
    if (controller == null) return;

    final route = widget.routes.firstWhere((r) => r.id == routeId);
    final spots = _routeSpots(route);
    final points = _routeLines[routeId] ?? [];

    final allPoints = [
      ...points,
      ...spots.map((s) => LatLng(s.lat, s.lng)),
    ];
    if (allPoints.isEmpty) return;

    if (allPoints.length == 1) {
      await _safeAnimateCamera(
        controller,
        CameraUpdate.newCameraPosition(
          CameraPosition(target: allPoints.first, zoom: 15, tilt: 45),
        ),
      );
      return;
    }

    final bounds = _boundsFromPoints(allPoints);
    await _safeAnimateCamera(
      controller,
      CameraUpdate.newLatLngBounds(bounds, _cameraPadding()),
    );
  }

  Future<void> _safeAnimateCamera(
    GoogleMapController controller,
    CameraUpdate update,
  ) async {
    try {
      await controller.animateCamera(update);
    } catch (e) {
      debugPrint('RouteSelectMap camera animation failed: $e');
    }
  }

  double _cameraPadding() {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottom = math.min(
      math.max(48.0, widget.bottomInset * 0.35),
      screenHeight * 0.42,
    );
    final top = math.min(widget.topInset + 16.0, screenHeight * 0.15);
    return math.max(bottom, top).toDouble();
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    if ((maxLat - minLat).abs() < 0.001 && (maxLng - minLng).abs() < 0.001) {
      const delta = 0.004;
      return LatLngBounds(
        southwest: LatLng(minLat - delta, minLng - delta),
        northeast: LatLng(maxLat + delta, maxLng + delta),
      );
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Set<Polyline> _buildPolylines() {
    final selectedId = widget.selectedRouteId;
    final polylines = <Polyline>{};

    for (final route in widget.routes) {
      final points = _routeLines[route.id];
      if (points == null || points.length < 2) continue;

      final isSelected = route.id == selectedId;

      if (isSelected) {
        polylines.add(
          Polyline(
            polylineId: PolylineId('${route.id}_glow'),
            points: points,
            width: 18,
            color: _routeEmeraldGlow.withValues(alpha: 0.4),
            geodesic: false,
            zIndex: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),
        );
      }

      polylines.add(
        Polyline(
          polylineId: PolylineId('${route.id}_line'),
          points: points,
          width: isSelected ? 8 : 3,
          color: isSelected
              ? _routeEmerald
              : const Color(0xFF6B6560).withValues(alpha: 0.55),
          geodesic: false,
          zIndex: isSelected ? 20 : 8,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          consumeTapEvents: !isSelected,
          onTap: isSelected ? null : () => widget.onRouteTapped(route.id),
        ),
      );

      if (!isSelected) {
        polylines.add(
          Polyline(
            polylineId: PolylineId(route.id),
            points: points,
            width: 22,
            color: Colors.transparent,
            geodesic: false,
            zIndex: 15,
            consumeTapEvents: true,
            onTap: () => widget.onRouteTapped(route.id),
          ),
        );
      }
    }

    return polylines;
  }

  Set<Marker> _buildMarkers() {
    final selectedId = widget.selectedRouteId;
    final markers = <Marker>{};

    for (final route in widget.routes) {
      if (route.id != selectedId) continue;

      final spots = _routeSpots(route);
      for (var i = 0; i < spots.length; i++) {
        final spot = spots[i];
        final isStart = i == 0;
        final isGoal = i == spots.length - 1 && spots.length > 1;
        final title =
            spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name;

        markers.add(
          Marker(
            markerId: MarkerId('${route.id}_${spot.id}'),
            position: LatLng(spot.lat, spot.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isStart
                  ? BitmapDescriptor.hueCyan
                  : isGoal
                  ? BitmapDescriptor.hueOrange
                  : BitmapDescriptor.hueYellow,
            ),
            infoWindow: InfoWindow(
              title: title,
              snippet: isStart
                  ? 'スタート'
                  : isGoal
                  ? 'ゴール'
                  : 'スポット $i',
            ),
            zIndexInt: isStart || isGoal ? 3 : 2,
          ),
        );
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: true,
      trafficEnabled: false,
      style: widget.mapStyle,
      initialCameraPosition: CameraPosition(
        target: _initialTarget(),
        zoom: 14,
        tilt: 45,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        widget.onMapCreated?.call(controller);
      },
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
    );
  }
}
