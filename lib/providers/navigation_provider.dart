// lib/providers/navigation_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

class NavigationState {
  final RouteModel? currentRoute;
  final Set<String> visitedSpotIds;
  final bool isAdventureStarted;
  final double progress;
  final double? distanceToNextSpot;
  final SpotModel? nextSpot;
  final DateTime? adventureStartTime;

  const NavigationState({
    this.currentRoute,
    this.visitedSpotIds = const {},
    this.isAdventureStarted = false,
    this.progress = 0.0,
    this.distanceToNextSpot,
    this.nextSpot,
    this.adventureStartTime,
  });

  NavigationState copyWith({
    RouteModel? currentRoute,
    Set<String>? visitedSpotIds,
    bool? isAdventureStarted,
    double? progress,
    double? distanceToNextSpot,
    bool clearDistance = false,
    SpotModel? nextSpot,
    bool clearNextSpot = false,
    DateTime? adventureStartTime,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      visitedSpotIds: visitedSpotIds ?? this.visitedSpotIds,
      isAdventureStarted: isAdventureStarted ?? this.isAdventureStarted,
      progress: progress ?? this.progress,
      distanceToNextSpot: clearDistance
          ? null
          : (distanceToNextSpot ?? this.distanceToNextSpot),
      nextSpot: clearNextSpot ? null : (nextSpot ?? this.nextSpot),
      adventureStartTime: adventureStartTime ?? this.adventureStartTime,
    );
  }

  List<SpotModel> get routeSpots {
    final route = currentRoute;
    if (route == null) return const [];
    return route.generatedSpots;
  }
}

class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() => const NavigationState();

  void startAdventure(RouteModel route) {
    state = NavigationState(
      currentRoute: route,
      visitedSpotIds: const {},
      isAdventureStarted: true,
      progress: 0.0,
      adventureStartTime: DateTime.now(),
    );
    _initializeNextSpot();
  }

  void updateLocation(Position position) {
    if (!state.isAdventureStarted || state.currentRoute == null) return;

    final next = state.nextSpot;
    if (next == null) {
      state = state.copyWith(clearDistance: true);
      return;
    }

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      next.lat,
      next.lng,
    );

    state = state.copyWith(distanceToNextSpot: distance);
  }

  void checkInNextSpot() {
    if (!state.isAdventureStarted ||
        state.currentRoute == null ||
        state.nextSpot == null) {
      return;
    }

    final route = state.currentRoute!;
    final spots = {for (final s in route.generatedSpots) s.id: s};
    final updatedVisited = Set<String>.from(state.visitedSpotIds)
      ..add(state.nextSpot!.id);

    SpotModel? targetSpot;
    for (final spotId in route.spotIds) {
      if (!updatedVisited.contains(spotId)) {
        targetSpot = spots[spotId];
        break;
      }
    }

    final totalSpots = route.spotIds.length;
    final progress = totalSpots > 0
        ? (updatedVisited.length / totalSpots).clamp(0.0, 1.0)
        : 1.0;

    state = state.copyWith(
      visitedSpotIds: updatedVisited,
      nextSpot: targetSpot,
      clearNextSpot: targetSpot == null,
      distanceToNextSpot: null,
      clearDistance: targetSpot == null,
      progress: progress,
    );
  }

  void _initializeNextSpot() {
    if (state.currentRoute == null) return;
    final route = state.currentRoute!;
    final spots = {for (final s in route.generatedSpots) s.id: s};

    for (final spotId in route.spotIds) {
      if (!state.visitedSpotIds.contains(spotId)) {
        state = state.copyWith(nextSpot: spots[spotId]);
        break;
      }
    }
  }

  void forceCheckInNextSpot() => checkInNextSpot();

  void finishAdventure() {
    state = const NavigationState();
  }
}

final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
      NavigationNotifier.new,
    );
