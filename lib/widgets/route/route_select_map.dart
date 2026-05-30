// lib/widgets/route/route_select_map.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/app_colors.dart';
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
  final double bottomInset;
  final ValueChanged<String> onRouteTapped;
  final void Function(GoogleMapController controller)? onMapCreated;

  const RouteSelectMap({
    super.key,
    required this.routes,
    required this.spots,
    required this.selectedRouteId,
    required this.mapStyle,
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

    if (fromIds.length >= 2) return fromIds;
    if (route.generatedSpots.length >= 2) return route.generatedSpots;
    return fromIds.isNotEmpty ? fromIds : route.generatedSpots;
  }

  Future<void> _fetchAllRoutes() async {
    if (widget.routes.isEmpty) return;

    final routesSnapshot = List<RouteModel>.from(widget.routes);
    final directions = ref.read(directionsServiceProvider);
    final lines = <String, List<LatLng>>{};

    await Future.wait(
      routesSnapshot.map((route) async {
        final routeSpots = _routeSpots(route);
        if (routeSpots.length < 2) {
          lines[route.id] = routeSpots
              .map((spot) => LatLng(spot.lat, spot.lng))
              .toList(growable: false);
          return;
        }

        final origin = LatLng(routeSpots.first.lat, routeSpots.first.lng);
        final destination = LatLng(routeSpots.last.lat, routeSpots.last.lng);
        final waypoints = routeSpots
            .sublist(1, routeSpots.length - 1)
            .map((spot) => LatLng(spot.lat, spot.lng))
            .toList(growable: false);

        final points = await directions.getDirectionsRoute(
          origin: origin,
          destination: destination,
          waypoints: waypoints,
        );
        lines[route.id] = points;
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

    final points = _routeLines[routeId];
    if (points == null || points.isEmpty) {
      final spots = _routeSpots(
        widget.routes.firstWhere((route) => route.id == routeId),
      );
      if (spots.isEmpty) return;
      await _safeAnimateCamera(
        controller,
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(spots.first.lat, spots.first.lng),
            zoom: 14,
            tilt: 45,
          ),
        ),
      );
      return;
    }

    if (points.length == 1) {
      await _safeAnimateCamera(
        controller,
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 15, tilt: 45),
        ),
      );
      return;
    }

    final bounds = _boundsFromPoints(points);
    final padding = _cameraPadding();
    await _safeAnimateCamera(
      controller,
      CameraUpdate.newLatLngBounds(bounds, padding),
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
    final maxPadding = screenHeight * 0.45;
    return math.min(math.max(48, widget.bottomInset * 0.35), maxPadding);
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
            width: 16,
            color: AppColors.primary.withValues(alpha: 0.35),
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
              ? AppColors.primaryDark
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
      polylines: _buildPolylines(),
    );
  }
}
