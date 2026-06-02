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
  final double walkedDistanceKm;
  final int steps;
  final Position? lastPosition;
  final bool hasDeparted;
  final bool isArrivedAtCurrentSpot;
  final List<String> capturedPhotos;
  final List<String> torenyanLines;

  const NavigationState({
    this.currentRoute,
    this.visitedSpotIds = const {},
    this.isAdventureStarted = false,
    this.progress = 0.0,
    this.distanceToNextSpot,
    this.nextSpot,
    this.adventureStartTime,
    this.walkedDistanceKm = 0.0,
    this.steps = 0,
    this.lastPosition,
    this.hasDeparted = false,
    this.isArrivedAtCurrentSpot = false,
    this.capturedPhotos = const [],
    this.torenyanLines = const [],
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
    double? walkedDistanceKm,
    int? steps,
    Position? lastPosition,
    bool clearLastPosition = false,
    bool? hasDeparted,
    bool? isArrivedAtCurrentSpot,
    List<String>? capturedPhotos,
    List<String>? torenyanLines,
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
      walkedDistanceKm: walkedDistanceKm ?? this.walkedDistanceKm,
      steps: steps ?? this.steps,
      lastPosition: clearLastPosition ? null : (lastPosition ?? this.lastPosition),
      hasDeparted: hasDeparted ?? this.hasDeparted,
      isArrivedAtCurrentSpot: isArrivedAtCurrentSpot ?? this.isArrivedAtCurrentSpot,
      capturedPhotos: capturedPhotos ?? this.capturedPhotos,
      torenyanLines: torenyanLines ?? this.torenyanLines,
    );
  }

  List<SpotModel> get routeSpots {
    final route = currentRoute;
    if (route == null) return const [];
    return route.generatedSpots;
  }
}

class NavigationNotifier extends Notifier<NavigationState> {
  static const _linesBeforeDepart = [
    '出発の準備はいいにゃ？「出発する」を押して進むにゃ！',
    'ここから物語が始まるにゃ。準備はバッチリかにゃ？',
  ];
  static const _linesDeparted = [
    'さあ、出発にゃ！次のスポットへ向かって歩こう！',
    '一歩ずつ進んでいこうにゃ。何が見つかるか楽しみだにゃ！',
    '足元に気をつけて、のんびり進もうにゃ！',
  ];
  static const _linesApproaching = [
    'もうすぐ目的地だにゃ！周りをよく見てみるにゃ！',
    'あそこに見えるのがスポットだにゃ。到着ボタンの準備をするにゃ！',
    '目的地はすぐそこにゃ。よく頑張ったにゃ！',
  ];
  static const _linesArrived = [
    '到着したにゃ！お疲れ様だにゃ！',
    'ここがチェックポイントだにゃ！少し休憩するにゃ？',
    '無事に到着にゃ！周辺の景色を楽しんでにゃ！',
  ];
  static const _linesOffRoute = [
    '道から外れちゃったにゃ…？元のルートに戻ろうにゃ。',
    'あれれ、迷子になっちゃったにゃ？ルートを探そうにゃ。',
    'ちょっと寄り道にゃ？気をつけて戻るにゃ。',
  ];
  static const _linesCompleted = [
    'すべてのスポットを巡ったにゃ！最高の冒険だったにゃ！',
    '冒険完了だにゃ！結果を報告しに行くにゃ！',
    'お疲れ様だにゃ！君は立派な冒険者だにゃ！',
  ];

  @override
  NavigationState build() => const NavigationState();

  void startAdventure(RouteModel route) {
    state = NavigationState(
      currentRoute: route,
      visitedSpotIds: const {},
      isAdventureStarted: true,
      progress: 0.0,
      adventureStartTime: DateTime.now(),
      walkedDistanceKm: 0.0,
      steps: 0,
      lastPosition: null,
      hasDeparted: false,
      isArrivedAtCurrentSpot: false,
      capturedPhotos: const [],
      torenyanLines: _linesBeforeDepart,
    );
    _initializeNextSpot();
  }

  void depart() {
    if (!state.isAdventureStarted) return;
    state = state.copyWith(
      hasDeparted: true,
      torenyanLines: _linesDeparted,
    );
  }

  void updateLocation(Position position) {
    if (!state.isAdventureStarted || state.currentRoute == null) return;

    double addedDistanceKm = 0.0;
    if (state.lastPosition != null) {
      final diffMeters = Geolocator.distanceBetween(
        state.lastPosition!.latitude,
        state.lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (diffMeters > 0.5) {
        addedDistanceKm = diffMeters / 1000.0;
      }
    }

    final newDistance = state.walkedDistanceKm + addedDistanceKm;
    final newSteps = (newDistance * 1000 / 0.7).round();

    final next = state.nextSpot;
    if (next == null) {
      state = state.copyWith(
        clearDistance: true,
        walkedDistanceKm: newDistance,
        steps: newSteps,
        lastPosition: position,
      );
      return;
    }

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      next.lat,
      next.lng,
    );

    List<String> nextLines = state.torenyanLines;
    if (state.hasDeparted && !state.isArrivedAtCurrentSpot && nextLines != _linesOffRoute) {
      if (distance <= 35.0) {
        nextLines = _linesApproaching;
      } else {
        nextLines = _linesDeparted;
      }
    }

    state = state.copyWith(
      distanceToNextSpot: distance,
      walkedDistanceKm: newDistance,
      steps: newSteps,
      lastPosition: position,
      torenyanLines: nextLines,
    );
  }

  void updateOffRouteStatus(bool isOff) {
    if (!state.isAdventureStarted || !state.hasDeparted || state.isArrivedAtCurrentSpot) return;

    if (isOff) {
      state = state.copyWith(torenyanLines: _linesOffRoute);
    } else {
      state = state.copyWith(
        torenyanLines: state.distanceToNextSpot != null && state.distanceToNextSpot! <= 35.0
            ? _linesApproaching
            : _linesDeparted,
      );
    }
  }

  void checkInNextSpot() {
    if (!state.isAdventureStarted ||
        state.currentRoute == null ||
        state.nextSpot == null) {
      return;
    }

    final route = state.currentRoute!;
    final updatedVisited = Set<String>.from(state.visitedSpotIds)
      ..add(state.nextSpot!.id);

    final totalSpots = route.spotIds.length;
    final progress = totalSpots > 0
        ? (updatedVisited.length / totalSpots).clamp(0.0, 1.0)
        : 1.0;

    final isLast = route.spotIds.isNotEmpty && route.spotIds.last == state.nextSpot!.id;

    state = state.copyWith(
      visitedSpotIds: updatedVisited,
      progress: progress,
      isArrivedAtCurrentSpot: true,
      torenyanLines: isLast ? _linesCompleted : _linesArrived,
    );
  }

  void proceedToNextSpot() {
    if (!state.isAdventureStarted || state.currentRoute == null) return;
    final route = state.currentRoute!;
    final spots = {for (final s in route.generatedSpots) s.id: s};

    SpotModel? targetSpot;
    for (final spotId in route.spotIds) {
      if (!state.visitedSpotIds.contains(spotId)) {
        targetSpot = spots[spotId];
        break;
      }
    }

    state = state.copyWith(
      nextSpot: targetSpot,
      clearNextSpot: targetSpot == null,
      distanceToNextSpot: null,
      clearDistance: targetSpot == null,
      isArrivedAtCurrentSpot: false,
      torenyanLines: targetSpot == null ? _linesCompleted : _linesDeparted,
    );
  }

  void addCapturedPhoto(String path) {
    if (!state.isAdventureStarted) return;
    final updatedPhotos = List<String>.from(state.capturedPhotos)..add(path);
    state = state.copyWith(capturedPhotos: updatedPhotos);
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
