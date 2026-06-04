// lib/providers/result_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/result_model.dart';
import '../models/adventure_history_model.dart';
import '../utils/fragment_lottery.dart';
import 'navigation_provider.dart';
import 'history_provider.dart';
import 'auth_provider.dart';

// ─────────────────────────────────────
// 📦 State
// ─────────────────────────────────────

class ResultState {
  final bool isLoading;

  // 報酬受け取り済みか
  final bool rewardClaimed;

  // 保存済みか
  final bool isSaved;

  // リザルト本体
  final AdventureResult? result;

  const ResultState({
    required this.isLoading,
    required this.rewardClaimed,
    required this.isSaved,
    required this.result,
  });

  factory ResultState.initial() {
    return const ResultState(
      isLoading: false,
      rewardClaimed: false,
      isSaved: false,
      result: null,
    );
  }

  ResultState copyWith({
    bool? isLoading,
    bool? rewardClaimed,
    bool? isSaved,
    AdventureResult? result,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      isSaved: isSaved ?? this.isSaved,
      result: result ?? this.result,
    );
  }
}

// ─────────────────────────────────────
// 🎮 Provider
// ─────────────────────────────────────

final resultProvider = NotifierProvider<ResultNotifier, ResultState>(
  ResultNotifier.new,
);

// ─────────────────────────────────────
// 🎮 Notifier
// ─────────────────────────────────────

class ResultNotifier extends Notifier<ResultState> {
  @override
  ResultState build() {
    return ResultState.initial();
  }

  // ── 履歴からセット ───────────────────
  void setResult(AdventureResult result) {
    state = state.copyWith(result: result, isSaved: true, rewardClaimed: true);
  }

  // ── リザルト生成 ────────────────────
  Future<void> generateResult() async {
    state = state.copyWith(isLoading: true);

    // AIの生成待ちをシミュレート
    await Future.delayed(const Duration(milliseconds: 1500));

    final navState = ref.read(navigationProvider);
    final baseDummy = AdventureResult.dummy();

    // ナビゲーションデータから実際数値を反映
    final actualDistance = navState.walkedDistanceKm > 0 ? navState.walkedDistanceKm : baseDummy.distanceKm;
    final actualSteps = navState.steps > 0 ? navState.steps : baseDummy.steps;
    final durationMin = navState.adventureStartTime != null
        ? DateTime.now().difference(navState.adventureStartTime!).inMinutes
        : baseDummy.durationMinutes;

    final actualPhotos = navState.capturedPhotos.isNotEmpty
        ? navState.capturedPhotos.map((path) => ResultPhoto(imageUrl: path, caption: '冒険中に撮影した景色')).toList()
        : baseDummy.photos;

    // 軌跡データの取得（本番はLocationProviderなどから）
    final routePoints = navState.currentRoute?.generatedSpots
            .map((s) => LatLng(s.lat, s.lng))
            .toList() ??
        baseDummy.routePoints;

    // 街の断片の抽選
    final obtainedFragments = FragmentLottery.draw(
      weather: '晴れ', // TODO: WeatherProviderから
      time: DateTime.now(),
      visitedSpotCategories: ['公園'], // TODO: Spotのタグから
      lastLocationName: navState.nextSpot?.name ?? '街のどこか',
    );

    final result = AdventureResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      title: navState.currentRoute?.themeName ?? baseDummy.title,
      subTitle: navState.currentRoute?.themeDescription ?? baseDummy.subTitle,
      completedAt: DateTime.now(),
      aiStory: baseDummy.aiStory, // TODO: AI生成
      closingMessage: baseDummy.closingMessage,
      distanceKm: actualDistance,
      steps: actualSteps,
      calories: (actualSteps * 0.04).round(),
      durationMinutes: durationMin > 0 ? durationMin : 1,
      fragmentCount: obtainedFragments.length,
      expGained: navState.visitedSpotIds.length * 50 + 100,
      weather: '☀️ 晴天',
      themeIcon: '🗺️',
      routeMapImageUrl: baseDummy.routeMapImageUrl,
      routePoints: routePoints,
      photos: actualPhotos,
      friends: baseDummy.friends,
      obtainedFragments: obtainedFragments,
      unlockedAchievements: ['初めての冒険'], // TODO: AchievementManagerから
    );

    state = state.copyWith(
      isLoading: false,
      result: result,
    );

    // 💡 獲得時に自動で履歴保存する
    await saveMemory();
  }

  // ── 思い出保存 ─────────────────────
  Future<void> saveMemory() async {
    final res = state.result;
    if (res == null || state.isSaved) return;

    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;

    final history = AdventureHistoryModel(
      id: res.id,
      createdAt: res.completedAt,
      title: res.title,
      themeName: 'ノーマル',
      themeDescription: res.subTitle,
      themeIcon: res.themeIcon,
      weather: res.weather,
      aiReport: res.aiStory,
      distanceKm: res.distanceKm,
      steps: res.steps,
      expGained: res.expGained,
      durationMinutes: res.durationMinutes,
      isCompleted: res.isCompleted,
      imageUrls: res.photos.map((p) => p.imageUrl).toList(),
      routePoints: res.routePoints,
      obtainedFragments: res.obtainedFragments,
      unlockedAchievements: res.unlockedAchievements,
    );

    final userRepo = ref.read(userRepositoryProvider);
    
    // 1. 街の断片（インベントリ）更新
    await userRepo.updateInventory(user.uid, res.obtainedFragments);
    
    // 2. 統計データ（Stats）更新
    await userRepo.updateStats(user.uid, {
      'totalDistance': FieldValue.increment(res.distanceKm),
      'adventureCount': FieldValue.increment(1),
      'spotVisitCount': FieldValue.increment(res.fragmentCount),
      // 種類数は本来重複チェックが必要だが、簡易的に加算
      'treasureKindsCount': FieldValue.increment(res.obtainedFragments.length),
      'photoPinCount': FieldValue.increment(res.photos.length),
      'lastAdventureAt': FieldValue.serverTimestamp(),
    });

    // 3. 履歴保存
    await ref.read(historyRepositoryProvider).saveHistory(
          userId: user.uid,
          history: history,
        );

    // 4. 実績解除チェック（簡易実装）
    // TODO: 本来は統計データを元に AchievementManager で判定
    if (res.isCompleted) {
      await userRepo.unlockAchievement(user.uid, 'first_adventure');
    }

    state = state.copyWith(isSaved: true);
  }

  // ── 報酬受け取り（演出用フラグ） ──────
  void markRewardClaimed() {
    state = state.copyWith(rewardClaimed: true);
  }
}