// lib/widgets/navigation/navigation_map_layer.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/spot_model.dart';
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

class _GoogleMapLayer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,

      myLocationButtonEnabled: false,

      zoomControlsEnabled: false,

      compassEnabled: false,

      mapToolbarEnabled: false,

      buildingsEnabled: true,

      trafficEnabled: false,

      initialCameraPosition: CameraPosition(
        target: currentPosition != null
            ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
            : (spots.isNotEmpty
                  ? LatLng(spots.first.lat, spots.first.lng)
                  : const LatLng(35.6812, 139.7671)),

        zoom: 16,

        tilt: 45,
      ),

      style: darkMapStyle,

      onMapCreated: (controller) {
        onMapCreated?.call(controller);
      },

      markers: spots.map((spot) {
        final isVisited = visitedSpotIds.contains(spot.id);

        final isNext = nextSpot?.id == spot.id;

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

          patterns: [PatternItem.dot, PatternItem.gap(10)],

          points: spots.map((spot) => LatLng(spot.lat, spot.lng)).toList(),
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
