// lib/providers/result_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/result_model.dart';
import 'navigation_provider.dart';

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

final resultProvider =
    NotifierProvider<ResultNotifier, ResultState>(
      ResultNotifier.new,
    );

// ─────────────────────────────────────
// 🎮 Notifier
// ─────────────────────────────────────

class ResultNotifier extends Notifier<ResultState> {
  @override
  ResultState build() {
    // 💡 初期化時にリザルトを読み込む
    Future.microtask(() => loadResult());
    return ResultState.initial();
  }

  // ── リザルト読み込み ─────────────────
  Future<void> loadResult() async {
    state = state.copyWith(isLoading: true);

    // 💡 本番ではFirebaseから取得
    await Future.delayed(const Duration(milliseconds: 800));

    final navState = ref.read(navigationProvider);
    final baseDummy = AdventureResult.dummy();

    final actualDistance = navState.isAdventureStarted || navState.walkedDistanceKm > 0
        ? navState.walkedDistanceKm
        : baseDummy.distanceKm;
    final actualSteps = navState.isAdventureStarted || navState.steps > 0
        ? navState.steps
        : baseDummy.steps;

    final actualPhotos = navState.isAdventureStarted && navState.capturedPhotos.isNotEmpty
        ? navState.capturedPhotos
            .map((path) => ResultPhoto(imageUrl: path, caption: '冒険中に撮影した景色'))
            .toList()
        : baseDummy.photos;

    final durationMin = navState.adventureStartTime != null
        ? DateTime.now().difference(navState.adventureStartTime!).inMinutes
        : baseDummy.durationMinutes;

    final updatedResult = AdventureResult(
      id: baseDummy.id,
      title: baseDummy.title,
      subTitle: baseDummy.subTitle,
      completedAt: DateTime.now(),
      aiStory: baseDummy.aiStory,
      closingMessage: baseDummy.closingMessage,
      distanceKm: actualDistance,
      steps: actualSteps,
      calories: (actualSteps * 0.04).round(),
      durationMinutes: durationMin > 0 ? durationMin : 1,
      fragmentCount: navState.visitedSpotIds.length,
      expGained: navState.visitedSpotIds.length * 50 + 100,
      weather: baseDummy.weather,
      themeIcon: baseDummy.themeIcon,
      routeMapImageUrl: baseDummy.routeMapImageUrl,
      photos: actualPhotos,
      friends: baseDummy.friends,
      fragments: baseDummy.fragments,
      achievements: baseDummy.achievements,
    );

    state = state.copyWith(
      isLoading: false,
      result: updatedResult,
    );
  }

  // ── 報酬受け取り ────────────────────
  Future<void> claimReward() async {
    if (state.rewardClaimed) return;

    state = state.copyWith(isLoading: true);

    // 💡 演出待ち
    await Future.delayed(const Duration(milliseconds: 1200));

    state = state.copyWith(
      isLoading: false,
      rewardClaimed: true,
    );
  }

  // ── 思い出保存 ─────────────────────
  Future<void> saveMemory() async {
    if (state.isSaved) return;

    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 700));

    state = state.copyWith(
      isLoading: false,
      isSaved: true,
    );
  }

  // ── SNSシェア ──────────────────────
  Future<void> shareResult() async {
    // TODO:
    // share_plus で共有予定
  }
}