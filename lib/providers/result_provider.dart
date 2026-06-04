// lib/providers/result_provider.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/result_model.dart';
import '../models/adventure_history_model.dart';
import '../models/fragment_model.dart';
import '../models/spot_model.dart';
import '../repositories/history_repository.dart';
import '../repositories/fragment_repository.dart';
import '../utils/exp_utils.dart';
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
  'item_13': '商店街 of 福引券',
  'item_14': '公園の夕暮れ石',
  'item_15': '絆の編纂珠',
  'item_16': '境界のスマートフォン',
  'item_17': 'この街の記憶地図',
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
    // 💡 初期化時にリザルトを読み込む
    Future.microtask(() => loadResult());
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
      steps: (history.distanceKm * 1400).round(), // 1kmあたり約1400歩換算
      calories: ((history.distanceKm * 1400) * 0.04).round(),
      durationMinutes: history.durationMinutes,
      fragmentCount: history.fragments.length,
      expGained: history.fragments.length * 50 + 100,
      weather: history.weather,
      themeIcon: history.themeIcon,
      routeMapImageUrl: 'https://images.unsplash.com/photo-1526772662000-3f88f10405ff',
      photos: history.imageUrls.map((url) => ResultPhoto(imageUrl: url, caption: '冒険中に撮影した景色')).toList(),
      friends: const [],
      fragments: history.fragments,
      achievements: const [], // 過去実績はブランク
    );

    state = ResultState(
      isLoading: false,
      rewardClaimed: true,
      isSaved: true,
      result: result,
    );
  }

  // ── 新規リザルト生成＆自動保存 ───────
  Future<void> loadResult() async {
    if (state.isSaved || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    // 💡 ロード演出用の少しの待ち時間
    await Future.delayed(const Duration(milliseconds: 800));

    final navState = ref.read(navigationProvider);
    final baseDummy = AdventureResult.dummy();

    // 冒険中かどうかのチェック
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

    // 1. 獲得する断片の決定
    final List<String> earnedFragmentIds = [];
    final List<String> earnedFragmentNames = [];
    final routeSpots = navState.currentRoute?.generatedSpots ?? [];
    final random = Random();

    if (hasActiveAdventure) {
      for (final spotId in navState.visitedSpotIds) {
        final spot = routeSpots.firstWhere(
          (s) => s.id == spotId,
          orElse: () => SpotModel(id: spotId, lat: 0, lng: 0, name: '未知のスポット'),
        );
        String? matchedMasterId;
        for (final entry in categoryToFragmentId.entries) {
          if (spot.category.contains(entry.key)) {
            matchedMasterId = entry.value;
            break;
          }
        }
        // 夕方17時以降なら30%の確率で黄昏の硝子玉を付与
        if (matchedMasterId == null && DateTime.now().hour >= 17 && random.nextDouble() < 0.3) {
          matchedMasterId = 'item_11';
        }
        // マッチしなければノーマル(item_01~item_06)からランダム
        if (matchedMasterId == null) {
          final idx = random.nextInt(6) + 1;
          matchedMasterId = 'item_0$idx';
        }

        earnedFragmentIds.add(matchedMasterId);
        earnedFragmentNames.add(fragmentMasterNames[matchedMasterId] ?? '日常の断片');
      }

      // 長距離（5km以上）または訪問スポット3個以上なら15%の確率でレジェンド断片付与
      if ((actualDistance >= 5.0 || navState.visitedSpotIds.length >= 3) && random.nextDouble() < 0.15) {
        final idx = random.nextInt(3) + 15; // item_15, 16, 17
        earnedFragmentIds.add('item_$idx');
        earnedFragmentNames.add(fragmentMasterNames['item_$idx'] ?? '伝説の断片');
      }
    } else {
      // 非アクティブ（デモ画面）の場合はダミー断片
      earnedFragmentNames.addAll(baseDummy.fragments);
    }

    final int earnedExp = hasActiveAdventure ? (navState.visitedSpotIds.length * 50 + 100) : baseDummy.expGained;
    final List<String> newlyUnlockedAchievementTitles = [];

    // 2. Firestore自動保存処理
    if (hasActiveAdventure) {
      try {
        // A. ユーザー経験値＆レベル更新
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
        final userSnapshot = await userDocRef.get();
        int currentExp = 0;
        if (userSnapshot.exists) {
          currentExp = (userSnapshot.data()?['exp'] as num?)?.toInt() ?? 0;
        }
        final newExp = currentExp + earnedExp;
        final newLevel = ExpUtils.getLevelFromXp(newExp);

        await userDocRef.set({
          'exp': newExp,
          'level': newLevel,
          'rank': ExpUtils.getRank(newLevel).nameJa,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // B. 履歴データ保存
        final history = AdventureHistoryModel(
          id: baseDummy.id + '_${DateTime.now().millisecondsSinceEpoch}',
          createdAt: DateTime.now(),
          title: navState.currentRoute?.themeName ?? '日常の散歩',
          themeName: navState.currentRoute?.themeName ?? 'ノーマル',
          themeDescription: navState.currentRoute?.themeDescription ?? '',
          themeIcon: baseDummy.themeIcon,
          weather: '晴れ',
          aiReport: baseDummy.aiStory,
          distanceKm: actualDistance,
          durationMinutes: durationMin > 0 ? durationMin : 1,
          isCompleted: true,
          imageUrls: actualPhotos.map((p) => p.imageUrl).toList(),
          fragments: earnedFragmentNames,
          friendIds: const [],
          tags: navState.currentRoute?.tags ?? [],
        );
        final HistoryRepository historyRepo = ref.read(historyRepositoryProvider);
        await historyRepo.saveHistory(userId: userId, history: history);

        // C. 街の断片コレクション更新
        final FragmentRepository fragRepo = ref.read(fragmentRepositoryProvider);
        final currentFragments = await fragRepo.fetchFragmentsMap(userId);

        for (final itemMasterId in earnedFragmentIds) {
          final existing = currentFragments[itemMasterId];
          final locationName = routeSpots.firstWhere(
            (s) => navState.visitedSpotIds.contains(s.id),
            orElse: () => SpotModel(id: '', lat: 0, lng: 0, name: '街のどこか'),
          ).name;

          final updatedFrag = FragmentModel(
            id: existing?.id ?? 'user_frag_${itemMasterId}_${DateTime.now().millisecondsSinceEpoch}',
            itemMasterId: itemMasterId,
            stackCount: (existing?.stackCount ?? 0) + 1,
            rarity: fragmentMasterRarities[itemMasterId] ?? FragmentRarity.normal,
            locationName: locationName,
            collectedAt: existing?.collectedAt ?? DateTime.now(),
          );
          await fragRepo.saveFragment(userId, updatedFrag);
          currentFragments[itemMasterId] = updatedFrag; // ローカル参照キャッシュも更新
        }

        // 統計値用のユニーク所持数・全解放数カウント
        final uniqueFragmentsCount = currentFragments.keys.length;
        int fullyUnlockedCount = 0;
        for (final frag in currentFragments.values) {
          final maxThreshold = frag.rarity == FragmentRarity.normal ? 5 : (frag.rarity == FragmentRarity.rare ? 3 : 1);
          if (frag.stackCount >= maxThreshold) {
            fullyUnlockedCount++;
          }
        }

        // D. 実績＆統計データの更新
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

        final double newDistance = prevDistance + actualDistance;
        final int newAdventures = prevAdventures + 1;
        final int newSpotVisits = prevSpotVisits + navState.visitedSpotIds.length;
        final int newPhotos = prevPhotos + actualPhotos.length;
        final int newLoginDays = (statsData['loginDaysCount'] ?? 0).toInt() + 1;

        final Map<String, dynamic> newStats = {
          'totalDistance': newDistance,
          'adventureCount': newAdventures,
          'loginDaysCount': newLoginDays,
          'spotVisitCount': newSpotVisits,
          'photoPinCount': newPhotos,
          'treasureKindsCount': uniqueFragmentsCount,
          'fullyUnlockedFragmentsCount': fullyUnlockedCount,
        };

        // 解除チェック
        final Map<String, dynamic> unlockedMap = Map<String, dynamic>.from(statsData['unlockedAchievements'] ?? {});

        void checkUnlock(String id, String title, double current, double threshold) {
          if (current >= threshold && !unlockedMap.containsKey(id)) {
            unlockedMap[id] = DateTime.now().toIso8601String();
            newlyUnlockedAchievementTitles.add(title);
          }
        }

        checkUnlock('shoyo_mujin', '逍遥無尽', newDistance, 1.0);
        checkUnlock('manyu_sokyu', '漫遊蒼穹', newAdventures.toDouble(), 1.0);
        checkUnlock('remmen_fuzetsu', '連綿不絶', newLoginDays.toDouble(), 3.0);
        checkUnlock('itsuro_tankyu', '逸路探求', (statsData['newWayCount'] ?? 0).toDouble() + 1.0, 1.0);
        checkUnlock('ukai_mukyu', '迂回無窮', newSpotVisits.toDouble(), 1.0);
        checkUnlock('dokuo_danko', '独往断行', (statsData['ignoreNaviCount'] ?? 0).toDouble(), 1.0);
        checkUnlock('shushu_temmo', '蒐集天網', uniqueFragmentsCount.toDouble(), 1.0);
        checkUnlock('tsuioku_hensan', '追憶編纂', fullyUnlockedCount.toDouble(), 1.0);
        checkUnlock('saikei_setsuna', '採景刹那', newPhotos.toDouble(), 1.0);

        newStats['unlockedAchievements'] = unlockedMap;
        await statsDocRef.set(newStats, SetOptions(merge: true));

      } catch (e) {
        print('Error saving adventure results: $e');
      }
    }

    final updatedResult = AdventureResult(
      id: baseDummy.id + '_${DateTime.now().millisecondsSinceEpoch}',
      title: hasActiveAdventure ? (navState.currentRoute?.themeName ?? '日常の散歩') : baseDummy.title,
      subTitle: hasActiveAdventure ? (navState.currentRoute?.themeDescription ?? '新しい街角を見つける旅') : baseDummy.subTitle,
      completedAt: DateTime.now(),
      aiStory: baseDummy.aiStory,
      closingMessage: baseDummy.closingMessage,
      distanceKm: actualDistance,
      steps: actualSteps,
      calories: (actualSteps * 0.04).round(),
      durationMinutes: durationMin > 0 ? durationMin : 1,
      fragmentCount: earnedFragmentNames.length,
      expGained: earnedExp,
      weather: baseDummy.weather,
      themeIcon: baseDummy.themeIcon,
      routeMapImageUrl: baseDummy.routeMapImageUrl,
      photos: actualPhotos,
      friends: baseDummy.friends,
      fragments: earnedFragmentNames,
      achievements: newlyUnlockedAchievementTitles.isNotEmpty ? newlyUnlockedAchievementTitles : baseDummy.achievements,
    );

    state = ResultState(
      isLoading: false,
      rewardClaimed: true,
      isSaved: true,
      result: updatedResult,
    );
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
  }
}