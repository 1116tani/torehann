// lib/providers/navigation_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';
import 'route_provider.dart';

// ── 冒険中のナビゲーション状態 ──────────────────────
class NavigationState {
  final RouteModel? currentRoute;
  final Set<String> visitedSpotIds;
  final bool isAdventureStarted;
  final double progress; // 0.0 to 1.0
  final double? distanceToNextSpot;
  final SpotModel? nextSpot;

  const NavigationState({
    this.currentRoute,
    this.visitedSpotIds = const {},
    this.isAdventureStarted = false,
    this.progress = 0.0,
    this.distanceToNextSpot,
    this.nextSpot,
  });

  NavigationState copyWith({
    RouteModel? currentRoute,
    Set<String>? visitedSpotIds,
    bool? isAdventureStarted,
    double? progress,
    double? distanceToNextSpot,
    SpotModel? nextSpot,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      visitedSpotIds: visitedSpotIds ?? this.visitedSpotIds,
      isAdventureStarted: isAdventureStarted ?? this.isAdventureStarted,
      progress: progress ?? this.progress,
      distanceToNextSpot: distanceToNextSpot ?? this.distanceToNextSpot,
      nextSpot: nextSpot ?? this.nextSpot,
    );
  }
}

// ── Notifier ──────────────────────────────────
class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    // 💡 修正ポイント：build() の中では何もリッスンせず、初期状態を返すだけにします！
    return const NavigationState();
  }

  // 🚀 冒険を開始する
  void startAdventure(RouteModel route) {
    state = NavigationState(
      currentRoute: route,
      visitedSpotIds: const {},
      isAdventureStarted: true,
      progress: 0.0,
    );
    // 最初の目的地を安全にセット
    _initializeNextSpot();
  }

  // 🛰️ 位置情報が更新されたら、画面側から自動で呼び出されるメソッド
  void updateLocation(Position position) {
    if (!state.isAdventureStarted || state.currentRoute == null) return;

    final route = state.currentRoute!;
    final spots = ref.read(dummySpotsProvider);
    final updatedVisitedSpots = Set<String>.from(state.visitedSpotIds);

    bool reachedNewSpot = true;
    double? distanceToNext;
    SpotModel? targetSpot;

    // みぃくんの作った「20m以内なら次々にスキップする」自動判定ループだよ！
    while (reachedNewSpot) {
      reachedNewSpot = false;
      targetSpot = null;

      // 未訪問の次のスポットを探索
      for (final spotId in route.spotIds) {
        if (!updatedVisitedSpots.contains(spotId)) {
          targetSpot = spots[spotId];
          break;
        }
      }

      if (targetSpot != null) {
        distanceToNext = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          targetSpot.lat,
          targetSpot.lng,
        );

        // 📍 20メートル以内に近づいたら到達とみなして、次のスポットへ進む
        if (distanceToNext < 20.0) {
          updatedVisitedSpots.add(targetSpot.id);
          reachedNewSpot = true;
        }
      } else {
        distanceToNext = null;
      }
    }

    final totalSpots = route.spotIds.length;
    final progress = totalSpots > 0
        ? (updatedVisitedSpots.length / totalSpots).clamp(0.0, 1.0)
        : 1.0;

    state = state.copyWith(
      visitedSpotIds: updatedVisitedSpots,
      nextSpot: targetSpot,
      distanceToNextSpot: distanceToNext,
      progress: progress,
    );
  }

  // 💡 最初のスポットを初期化するメソッド
  void _initializeNextSpot() {
    if (state.currentRoute == null) return;
    final route = state.currentRoute!;
    final spots = ref.read(dummySpotsProvider);

    for (final spotId in route.spotIds) {
      if (!state.visitedSpotIds.contains(spotId)) {
        state = state.copyWith(nextSpot: spots[spotId]);
        break;
      }
    }
  }

  // 🏁 冒険を終了する
  void finishAdventure() {
    state = const NavigationState();
  }
}

final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
      NavigationNotifier.new,
    );
