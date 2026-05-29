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
    if (_hasSpotsChanged(oldWidget.spots, widget.spots)) {
      _fetchRoute();
    }
  }

  bool _hasSpotsChanged(List<SpotModel> oldSpots, List<SpotModel> newSpots) {
    if (oldSpots.length != newSpots.length) return true;
    for (int i = 0; i < oldSpots.length; i++) {
      if (oldSpots[i].lat != newSpots[i].lat || oldSpots[i].lng != newSpots[i].lng) {
        return true;
      }
    }
    return false;
  }

  Future<void> _fetchRoute() async {
    if (widget.spots.length < 2) {
      if (mounted) {
        setState(() {
          _polylinePoints = widget.spots.map((s) => LatLng(s.lat, s.lng)).toList();
        });
      }
      return;
    }

    try {
      final origin = LatLng(widget.spots.first.lat, widget.spots.first.lng);
      final destination = LatLng(widget.spots.last.lat, widget.spots.last.lng);
      final waypoints = widget.spots
          .sublist(1, widget.spots.length - 1)
          .map((s) => LatLng(s.lat, s.lng))
          .toList();

      final points = await ref.read(directionsServiceProvider).getDirectionsRoute(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );

      if (mounted) {
        setState(() {
          _polylinePoints = points;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _polylinePoints = widget.spots.map((s) => LatLng(s.lat, s.lng)).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routePoints = _polylinePoints.isNotEmpty
        ? _polylinePoints
        : widget.spots.map((spot) => LatLng(spot.lat, spot.lng)).toList();

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
            ? LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude)
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

      markers: widget.spots.map((spot) {
        final isVisited = widget.visitedSpotIds.contains(spot.id);

        final isNext = widget.nextSpot?.id == spot.id;

        return Marker(
          markerId: MarkerId(spot.id),

          position: LatLng(spot.lat, spot.lng),

          infoWindow: InfoWindow(
            title: spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name,

            snippet: spot.aiFlavorText,
          ),

          icon: BitmapDescriptor.defaultMarkerWithHue(
            isVisited
                ? BitmapDescriptor.hueYellow
                : (isNext
                      ? BitmapDescriptor.hueRed
                      : BitmapDescriptor.hueViolet),
          ),
        );
      }).toSet(),

      polylines: {
        Polyline(
          polylineId: const PolylineId('adventure_route'),

          width: 5,

          color: const Color(0xFFC8A97A),

          geodesic: true,

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
