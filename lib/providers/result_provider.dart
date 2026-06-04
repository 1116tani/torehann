// lib/providers/result_provider.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/result_model.dart';
import '../models/adventure_history_model.dart';
import '../models/fragment_model.dart';
import '../repositories/fragment_repository.dart';
import '../utils/exp_utils.dart';
import '../utils/fragment_lottery.dart';
import 'auth_provider.dart';
import 'navigation_provider.dart';
import 'history_provider.dart';
import 'collection_provider.dart';

// ─────────────────────────────────────
// 📦 State
// ─────────────────────────────────────

class ResultState {
  final bool isLoading;
  final bool rewardClaimed;
  final bool isSaved;
  final AdventureResult? result;
  final List<String> newAchievementIds;

  const ResultState({
    required this.isLoading,
    required this.rewardClaimed,
    required this.isSaved,
    required this.result,
    this.newAchievementIds = const [],
  });

  factory ResultState.initial() {
    return const ResultState(
      isLoading: false,
      rewardClaimed: false,
      isSaved: false,
      result: null,
      newAchievementIds: [],
    );
  }

  ResultState copyWith({
    bool? isLoading,
    bool? rewardClaimed,
    bool? isSaved,
    AdventureResult? result,
    List<String>? newAchievementIds,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      isSaved: isSaved ?? this.isSaved,
      result: result ?? this.result,
      newAchievementIds: newAchievementIds ?? this.newAchievementIds,
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
// 🗺️ Constants & Helpers for Fragments
// ─────────────────────────────────────

const Map<String, String> categoryToFragmentId = {
  '神社': 'item_07',
  '寺': 'item_07',
  '社': 'item_07',
  '駅': 'item_08',
  '交通': 'item_08',
  '本屋': 'item_09',
  '図書館': 'item_09',
  '本': 'item_09',
  'カフェ': 'item_10',
  '喫茶': 'item_10',
  '商店': 'item_13',
  '小売': 'item_13',
  'スーパー': 'item_13',
  '公園': 'item_14',
  '緑': 'item_14',
  '広場': 'item_14',
};

const Map<String, String> fragmentMasterNames = {
  'item_01': '始まりの木の枝',
  'item_02': '幸運の10円硬貨',
  'item_03': '迷い鳥の羽',
  'item_04': '奇跡のレシート',
  'item_05': '破られた白地図',
  'item_06': '絆のウォーキングシューズ',
  'item_07': '社の御守札',
  'item_08': '転移切符',
  'item_09': '迷宮の魔導書',
  'item_10': 'カフェのスタンプカード',
  'item_11': '黄昏の硝子玉',
  'item_12': '雨粒の小瓶',
  'item_13': '商店街の福引券',
  'item_14': '公園の夕暮れ石',
  'item_15': '始まりの木の伝説',
  'item_16': '黄金の羅針盤',
  'item_17': '古の冒険者の日誌',
};

const Map<String, FragmentRarity> fragmentMasterRarities = {
  'item_01': FragmentRarity.normal,
  'item_02': FragmentRarity.normal,
  'item_03': FragmentRarity.normal,
  'item_04': FragmentRarity.normal,
  'item_05': FragmentRarity.normal,
  'item_06': FragmentRarity.normal,
  'item_07': FragmentRarity.rare,
  'item_08': FragmentRarity.rare,
  'item_09': FragmentRarity.rare,
  'item_10': FragmentRarity.rare,
  'item_11': FragmentRarity.rare,
  'item_12': FragmentRarity.rare,
  'item_13': FragmentRarity.rare,
  'item_14': FragmentRarity.rare,
  'item_15': FragmentRarity.legend,
  'item_16': FragmentRarity.legend,
  'item_17': FragmentRarity.legend,
};

// ─────────────────────────────────────
// 🎮 Notifier
// ─────────────────────────────────────

class ResultNotifier extends Notifier<ResultState> {
  @override
  ResultState build() {
    return ResultState.initial();
  }

  // ── 過去の履歴データから初期化 ───────
  void initForHistory(AdventureHistoryModel history) {
    // 履歴データから表示用リザルトモデルに変換
    final result = AdventureResult(
      id: history.id,
      title: history.title,
      subTitle: history.themeDescription.isNotEmpty ? history.themeDescription : '過去の冒険の記録',
      completedAt: history.createdAt,
      aiStory: history.aiReport,
      closingMessage: '「寄り道は、きっと無駄じゃない。」',
      distanceKm: history.distanceKm,
      steps: history.steps > 0 ? history.steps : (history.distanceKm * 1400).round(), // 1kmあたり約1400歩換算
      calories: ((history.steps > 0 ? history.steps : (history.distanceKm * 1400).round()) * 0.04).round(),
      durationMinutes: history.durationMinutes,
      fragmentCount: history.obtainedFragments.length,
      expGained: history.expGained,
      weather: history.weather,
      themeIcon: history.themeIcon,
      routeMapImageUrl: 'https://images.unsplash.com/photo-1526772662000-3f88f10405ff',
      routePoints: history.routePoints,
      photos: history.imageUrls.map((url) => ResultPhoto(imageUrl: url, caption: '冒険中に撮影した景色')).toList(),
      friends: const [],
      obtainedFragments: history.obtainedFragments,
      unlockedAchievements: history.unlockedAchievements,
    );

    state = ResultState(
      isLoading: false,
      rewardClaimed: true,
      isSaved: true,
      result: result,
    );
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

    final bool hasActiveAdventure = navState.isAdventureStarted || navState.walkedDistanceKm > 0;

    final actualDistance = hasActiveAdventure ? navState.walkedDistanceKm : baseDummy.distanceKm;
    final actualSteps = hasActiveAdventure ? navState.steps : baseDummy.steps;

    final actualPhotos = hasActiveAdventure && navState.capturedPhotos.isNotEmpty
        ? navState.capturedPhotos
            .map((path) => ResultPhoto(imageUrl: path, caption: '冒険中に撮影した景色'))
            .toList()
        : baseDummy.photos;

    final durationMin = navState.adventureStartTime != null
        ? DateTime.now().difference(navState.adventureStartTime!).inMinutes
        : baseDummy.durationMinutes;

    final user = ref.read(firebaseAuthProvider).currentUser;
    final userId = user?.uid ?? 'dummy_user_123';

    // 軌跡データの取得（本番はLocationProviderなどから）
    final routePoints = navState.currentRoute?.generatedSpots
            .map((s) => LatLng(s.lat, s.lng))
            .toList() ??
        baseDummy.routePoints;

    // 街の断片の抽選
    final List<FragmentModel> obtainedFragments;
    if (hasActiveAdventure) {
      final routeSpots = navState.currentRoute?.generatedSpots ?? [];
      final visitedSpots = routeSpots.where((s) => navState.visitedSpotIds.contains(s.id)).toList();
      final visitedSpotCategories = visitedSpots.map((s) => s.category).toList();
      final lastLocationName = visitedSpots.isNotEmpty ? visitedSpots.last.name : '街のどこか';

      obtainedFragments = FragmentLottery.draw(
        weather: '晴れ', // TODO: WeatherProviderから
        time: DateTime.now(),
        visitedSpotCategories: visitedSpotCategories,
        lastLocationName: lastLocationName,
      );
    } else {
      obtainedFragments = baseDummy.obtainedFragments;
    }

    final int earnedExp = hasActiveAdventure ? (navState.visitedSpotIds.length * 50 + 100) : baseDummy.expGained;
    final List<String> newlyUnlockedAchievementTitles = [];
    final List<String> newlyUnlockedAchievementIds = [];

    if (hasActiveAdventure) {
      try {
        final statsDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('stats')
            .doc('counters');
        final statsSnapshot = await statsDocRef.get();
        final statsData = statsSnapshot.data() ?? {};

        final double prevDistance = (statsData['totalDistance'] ?? 0.0).toDouble();
        final int prevAdventures = (statsData['adventureCount'] ?? 0).toInt();
        final int prevSpotVisits = (statsData['spotVisitCount'] ?? 0).toInt();
        final int prevPhotos = (statsData['photoPinCount'] ?? 0).toInt();
        final int prevLoginDays = (statsData['loginDaysCount'] ?? 0).toInt();

        final double newDistance = prevDistance + actualDistance;
        final int newAdventures = prevAdventures + 1;
        final int newSpotVisits = prevSpotVisits + navState.visitedSpotIds.length;
        final int newPhotos = prevPhotos + actualPhotos.length;
        final int newLoginDays = prevLoginDays + 1;

        final FragmentRepository fragRepo = ref.read(fragmentRepositoryProvider);
        final currentFragments = await fragRepo.fetchFragmentsMap(userId);

        final Map<String, FragmentModel> tempFragments = Map.from(currentFragments);
        for (final frag in obtainedFragments) {
          final existing = tempFragments[frag.itemMasterId];
          tempFragments[frag.itemMasterId] = FragmentModel(
            id: existing?.id ?? frag.id,
            itemMasterId: frag.itemMasterId,
            stackCount: (existing?.stackCount ?? 0) + 1,
            rarity: frag.rarity,
            locationName: frag.locationName,
            collectedAt: existing?.collectedAt ?? frag.collectedAt,
          );
        }

        final int uniqueFragmentsCount = tempFragments.keys.length;
        int fullyUnlockedCount = 0;
        for (final frag in tempFragments.values) {
          final maxThreshold = frag.rarity == FragmentRarity.normal ? 5 : (frag.rarity == FragmentRarity.rare ? 3 : 1);
          if (frag.stackCount >= maxThreshold) {
            fullyUnlockedCount++;
          }
        }

        // 解除状況の取得
        final achievementsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('achievements')
            .get();
        final Set<String> unlockedIds = achievementsSnapshot.docs.map((doc) => doc.id).toSet();

        void checkUnlock(String id, String title, double current, double threshold) {
          if (current >= threshold && !unlockedIds.contains(id)) {
            newlyUnlockedAchievementTitles.add(title);
            newlyUnlockedAchievementIds.add(id);
          }
        }

        checkUnlock('first_adventure', '冒険者の第一歩', newAdventures.toDouble(), 1.0);
        checkUnlock('shoyo_mujin', '逍遥無尽', newDistance, 1.0);
        checkUnlock('manyu_sokyu', '漫遊蒼穹', newAdventures.toDouble(), 1.0);
        checkUnlock('remmen_fuzetsu', '連綿不絶', newLoginDays.toDouble(), 3.0);
        checkUnlock('itsuro_tankyu', '逸路探求', (statsData['newWayCount'] ?? 0).toDouble() + 1.0, 1.0);
        checkUnlock('ukai_mukyu', '迂回無窮', newSpotVisits.toDouble(), 1.0);
        checkUnlock('dokuo_danko', '独往断行', (statsData['ignoreNaviCount'] ?? 0).toDouble(), 1.0);
        checkUnlock('shushu_temmo', '蒐集天網', uniqueFragmentsCount.toDouble(), 1.0);
        checkUnlock('tsuioku_hensan', '追憶編纂', fullyUnlockedCount.toDouble(), 1.0);
        checkUnlock('saikei_setsuna', '採景刹那', newPhotos.toDouble(), 1.0);

      } catch (e) {
        print('Error checking achievements: $e');
      }
    } else {
      newlyUnlockedAchievementTitles.addAll(baseDummy.unlockedAchievements);
    }

    final result = AdventureResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      title: hasActiveAdventure ? (navState.currentRoute?.themeName ?? '日常の散歩') : baseDummy.title,
      subTitle: hasActiveAdventure ? (navState.currentRoute?.themeDescription ?? '新しい街角を見つける旅') : baseDummy.subTitle,
      completedAt: DateTime.now(),
      aiStory: baseDummy.aiStory,
      closingMessage: baseDummy.closingMessage,
      distanceKm: actualDistance,
      steps: actualSteps,
      calories: (actualSteps * 0.04).round(),
      durationMinutes: durationMin > 0 ? durationMin : 1,
      fragmentCount: obtainedFragments.length,
      expGained: earnedExp,
      weather: hasActiveAdventure ? '☀️ 晴天' : baseDummy.weather,
      themeIcon: hasActiveAdventure ? '🗺️' : baseDummy.themeIcon,
      routeMapImageUrl: baseDummy.routeMapImageUrl,
      routePoints: routePoints,
      photos: actualPhotos,
      friends: baseDummy.friends,
      obtainedFragments: obtainedFragments,
      unlockedAchievements: newlyUnlockedAchievementTitles,
    );

    state = ResultState(
      isLoading: false,
      isSaved: false,
      rewardClaimed: false,
      result: result,
      newAchievementIds: newlyUnlockedAchievementIds,
    );

    if (hasActiveAdventure) {
      await saveMemory();
    } else {
      state = state.copyWith(isSaved: true, rewardClaimed: true);
    }
  }

  // ── 思い出保存 ─────────────────────
  Future<void> saveMemory() async {
    final res = state.result;
    if (res == null || state.isSaved) return;

    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return;
    final userId = user.uid;

    state = state.copyWith(isLoading: true);

    try {
      final userRepo = ref.read(userRepositoryProvider);

      // 1. 街の断片（インベントリ）更新
      await userRepo.updateInventory(userId, res.obtainedFragments);

      // 2. 統計データ（Stats）更新
      final statsDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('counters');
      final statsSnapshot = await statsDocRef.get();
      final statsData = statsSnapshot.data() ?? {};

      final double prevDistance = (statsData['totalDistance'] ?? 0.0).toDouble();
      final int prevAdventures = (statsData['adventureCount'] ?? 0).toInt();
      final int prevSpotVisits = (statsData['spotVisitCount'] ?? 0).toInt();
      final int prevPhotos = (statsData['photoPinCount'] ?? 0).toInt();
      final int prevLoginDays = (statsData['loginDaysCount'] ?? 0).toInt();
      final int prevNewWay = (statsData['newWayCount'] ?? 0).toInt();

      final double newDistance = prevDistance + res.distanceKm;
      final int newAdventures = prevAdventures + 1;
      final int newSpotVisits = prevSpotVisits + res.obtainedFragments.length;
      final int newPhotos = prevPhotos + res.photos.length;
      final int newLoginDays = prevLoginDays + 1;
      final int newNewWay = prevNewWay + 1;

      final FragmentRepository fragRepo = ref.read(fragmentRepositoryProvider);
      final currentFragments = await fragRepo.fetchFragmentsMap(userId);
      final int uniqueFragmentsCount = currentFragments.keys.length;
      int fullyUnlockedCount = 0;
      for (final frag in currentFragments.values) {
        final maxThreshold = frag.rarity == FragmentRarity.normal ? 5 : (frag.rarity == FragmentRarity.rare ? 3 : 1);
        if (frag.stackCount >= maxThreshold) {
          fullyUnlockedCount++;
        }
      }

      final Map<String, dynamic> newStats = {
        'totalDistance': newDistance,
        'adventureCount': newAdventures,
        'loginDaysCount': newLoginDays,
        'spotVisitCount': newSpotVisits,
        'photoPinCount': newPhotos,
        'treasureKindsCount': uniqueFragmentsCount,
        'fullyUnlockedFragmentsCount': fullyUnlockedCount,
        'newWayCount': newNewWay,
        'lastAdventureAt': FieldValue.serverTimestamp(),
      };

      await userRepo.updateStats(userId, newStats);

      // 実績解除の適用
      for (final achId in state.newAchievementIds) {
        await userRepo.unlockAchievement(userId, achId);
      }

      // 3. ユーザー経験値＆レベル更新
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userDocRef.get();
      int currentExp = 0;
      if (userSnapshot.exists) {
        currentExp = (userSnapshot.data()?['exp'] as num?)?.toInt() ?? 0;
      }
      final newExp = currentExp + res.expGained;
      final newLevel = ExpUtils.getLevelFromXp(newExp);

      await userDocRef.set({
        'exp': newExp,
        'level': newLevel,
        'rank': ExpUtils.getRank(newLevel).nameJa,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 4. 履歴保存
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

      await ref.read(historyRepositoryProvider).saveHistory(
            userId: userId,
            history: history,
          );

      state = state.copyWith(isLoading: false, isSaved: true);
    } catch (e) {
      print('Error saving memory: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  // ── 報酬受け取り ────────────────────
  Future<void> claimReward() async {
    if (state.rewardClaimed) return;
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1200));
    state = state.copyWith(
      isLoading: false,
      rewardClaimed: true,
    );
  }

  // ── 報酬受け取り（演出用フラグ） ──────
  void markRewardClaimed() {
    state = state.copyWith(rewardClaimed: true);
  }

  // ── SNSシェア ──────────────────────
  Future<void> shareResult() async {
    // TODO: SNSシェアの実装
  }
}