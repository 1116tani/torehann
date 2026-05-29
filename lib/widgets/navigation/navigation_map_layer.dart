// lib/widgets/navigation/navigation_map_layer.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/spot_model.dart';
import '../../services/directions_service.dart';
import 'retro_mock_map.dart';

class NavigationMapLayer extends StatelessWidget {
  final bool useGoogleMap;

  final Position? currentPosition;

  final List<SpotModel> spots;

  final Set<String> visitedSpotIds;

  final SpotModel? nextSpot;

  final GoogleMapController? mapController;

  final String? darkMapStyle;

  final Function(GoogleMapController controller)? onMapCreated;

  const NavigationMapLayer({
    super.key,
    required this.useGoogleMap,
    required this.currentPosition,
    required this.spots,
    required this.visitedSpotIds,
    required this.nextSpot,
    required this.mapController,
    required this.darkMapStyle,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),

      switchInCurve: Curves.easeOutCubic,

      switchOutCurve: Curves.easeInCubic,

      child: useGoogleMap
          ? _GoogleMapLayer(
              key: const ValueKey('google_map'),

              currentPosition: currentPosition,

              spots: spots,

              visitedSpotIds: visitedSpotIds,

              nextSpot: nextSpot,

              darkMapStyle: darkMapStyle,

              onMapCreated: onMapCreated,
            )
          : _RetroMapLayer(
              key: const ValueKey('retro_map'),

              currentPosition: currentPosition,

              spots: spots,

              visitedSpotIds: visitedSpotIds,

              nextSpot: nextSpot,
            ),
    );
  }
}

// ─────────────────────────────
// 🛰️ Google Map
// ─────────────────────────────

class _GoogleMapLayer extends ConsumerStatefulWidget {
  final Position? currentPosition;

  final List<SpotModel> spots;

  final Set<String> visitedSpotIds;

  final SpotModel? nextSpot;

  final String? darkMapStyle;

  final Function(GoogleMapController controller)? onMapCreated;

  const _GoogleMapLayer({
    super.key,
    required this.currentPosition,
    required this.spots,
    required this.visitedSpotIds,
    required this.nextSpot,
    required this.darkMapStyle,
    required this.onMapCreated,
  });

  @override
  ConsumerState<_GoogleMapLayer> createState() => _GoogleMapLayerState();
}

class _GoogleMapLayerState extends ConsumerState<_GoogleMapLayer> {
  List<LatLng> _polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  @override
  void didUpdateWidget(covariant _GoogleMapLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasSpotsChanged(oldWidget.spots, widget.spots) ||
        oldWidget.nextSpot?.id != widget.nextSpot?.id ||
        _hasPositionChanged(
          oldWidget.currentPosition,
          widget.currentPosition,
        )) {
      _fetchRoute();
    }
  }

  bool _hasSpotsChanged(List<SpotModel> oldSpots, List<SpotModel> newSpots) {
    if (oldSpots.length != newSpots.length) return true;
    for (int i = 0; i < oldSpots.length; i++) {
      if (oldSpots[i].lat != newSpots[i].lat ||
          oldSpots[i].lng != newSpots[i].lng) {
        return true;
      }
    }
    return false;
  }

  bool _hasPositionChanged(Position? oldPosition, Position? newPosition) {
    if (oldPosition == null || newPosition == null) {
      return oldPosition != newPosition;
    }

    return Geolocator.distanceBetween(
          oldPosition.latitude,
          oldPosition.longitude,
          newPosition.latitude,
          newPosition.longitude,
        ) >
        15;
  }

  Future<void> _fetchRoute() async {
    if (widget.nextSpot == null) {
      if (mounted) {
        setState(() {
          _polylinePoints = const [];
        });
      }
      return;
    }

    try {
      final origin = _currentOrigin();
      final destination = LatLng(widget.nextSpot!.lat, widget.nextSpot!.lng);

      final points = await ref
          .read(directionsServiceProvider)
          .getDirectionsRoute(origin: origin, destination: destination);

      if (mounted) {
        setState(() {
          _polylinePoints = points;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _polylinePoints = [
            _currentOrigin(),
            LatLng(widget.nextSpot!.lat, widget.nextSpot!.lng),
          ];
        });
      }
    }
  }

  LatLng _currentOrigin() {
    if (widget.currentPosition != null) {
      return LatLng(
        widget.currentPosition!.latitude,
        widget.currentPosition!.longitude,
      );
    }

    if (widget.spots.isNotEmpty) {
      return LatLng(widget.spots.first.lat, widget.spots.first.lng);
    }

    if (widget.nextSpot != null) {
      return LatLng(widget.nextSpot!.lat, widget.nextSpot!.lng);
    }

    return const LatLng(35.6812, 139.7671);
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = _polylinePoints.isNotEmpty
        ? _polylinePoints
        : [
            if (widget.nextSpot != null) ...[
              _currentOrigin(),
              LatLng(widget.nextSpot!.lat, widget.nextSpot!.lng),
            ],
          ];

    return GoogleMap(
      myLocationEnabled: true,

      myLocationButtonEnabled: false,

      zoomControlsEnabled: false,

      compassEnabled: false,

      mapToolbarEnabled: false,

      buildingsEnabled: true,

      trafficEnabled: false,

      initialCameraPosition: CameraPosition(
        target: widget.currentPosition != null
            ? LatLng(
                widget.currentPosition!.latitude,
                widget.currentPosition!.longitude,
              )
            : (widget.spots.isNotEmpty
                  ? LatLng(widget.spots.first.lat, widget.spots.first.lng)
                  : const LatLng(35.6812, 139.7671)),

        zoom: 16,

        tilt: 45,
      ),

      style: widget.darkMapStyle,

      onMapCreated: (controller) {
        widget.onMapCreated?.call(controller);
      },

      markers: {
        if (widget.nextSpot != null)
          Marker(
            markerId: MarkerId(widget.nextSpot!.id),
            position: LatLng(widget.nextSpot!.lat, widget.nextSpot!.lng),
            infoWindow: InfoWindow(
              title: widget.nextSpot!.aiStoryName.isNotEmpty
                  ? widget.nextSpot!.aiStoryName
                  : widget.nextSpot!.name,
              snippet: widget.nextSpot!.aiFlavorText,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
          ),
      },

      polylines: {
        Polyline(
          polylineId: const PolylineId('adventure_route'),

          width: 7,

          color: const Color(0xFF34F26A),

          geodesic: false,

          zIndex: 10,

          points: routePoints,
        ),
      },
    );
  }
}

// ─────────────────────────────
// 🗺️ Retro Map
// ─────────────────────────────

class _RetroMapLayer extends StatelessWidget {
  final Position? currentPosition;

  final List<SpotModel> spots;

  final Set<String> visitedSpotIds;

  final SpotModel? nextSpot;

  const _RetroMapLayer({
    super.key,
    required this.currentPosition,
    required this.spots,
    required this.visitedSpotIds,
    required this.nextSpot,
  });

  @override
  Widget build(BuildContext context) {
    return RetroMockMap(
      currentPosition: currentPosition,

      spots: spots,

      visitedSpotIds: visitedSpotIds,

      nextSpot: nextSpot,
    );
  }
}
