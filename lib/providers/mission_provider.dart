// lib/providers/mission_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/mission_model.dart';

/// ── 現在のタブ ──────────────────────────
final missionTabProvider =
    StateProvider<MissionType>((ref) => MissionType.daily);

/// ── ミッション一覧 ──────────────────────
final missionListProvider =
    StateNotifierProvider<MissionNotifier, List<MissionModel>>(
  (ref) => MissionNotifier(),
);

/// ── ミッション管理Notifier ───────────────
class MissionNotifier extends StateNotifier<List<MissionModel>> {
  MissionNotifier() : super(_dummyMissions);

  /// ── 報酬受け取り ──────────────────
  void claimReward(String missionId) {
    state = state.map((mission) {
      if (mission.id != missionId) {
        return mission;
      }

      return MissionModel(
        id: mission.id,
        title: mission.title,
        description: mission.description,
        type: mission.type,
        currentProgress: mission.currentProgress,
        targetProgress: mission.targetProgress,
        rewardExp: mission.rewardExp,
        status: MissionStatus.claimed,
        difficulty: mission.difficulty,
        icon: mission.icon,
        unit: mission.unit,
      );
    }).toList();
  }

  /// ── 進捗更新（テスト用） ─────────────
  void updateProgress(
    String missionId,
    double newProgress,
  ) {
    state = state.map((mission) {
      if (mission.id != missionId) {
        return mission;
      }

      final completed = newProgress >= mission.targetProgress;

      return MissionModel(
        id: mission.id,
        title: mission.title,
        description: mission.description,
        type: mission.type,
        currentProgress: newProgress,
        targetProgress: mission.targetProgress,
        rewardExp: mission.rewardExp,
        status: completed
            ? MissionStatus.completed
            : MissionStatus.inProgress,
        difficulty: mission.difficulty,
        icon: mission.icon,
        unit: mission.unit,
      );
    }).toList();
  }
}

/// ── ダミーデータ ──────────────────────────
final List<MissionModel> _dummyMissions = [
  MissionModel(
    id: 'daily_001',
    title: '朝霧探索依頼',
    description: '朝7時〜9時の間に1km歩こう',
    type: MissionType.daily,
    currentProgress: 0.8,
    targetProgress: 1.0,
    rewardExp: 50,
    status: MissionStatus.inProgress,
    difficulty: MissionDifficulty.easy,
    icon: Icons.wb_sunny_outlined,
    unit: 'km',
  ),

  MissionModel(
    id: 'daily_002',
    title: '街の断片収集',
    description: '街の断片を1個発見しよう',
    type: MissionType.daily,
    currentProgress: 1,
    targetProgress: 1,
    rewardExp: 120,
    status: MissionStatus.completed,
    difficulty: MissionDifficulty.normal,
    icon: Icons.auto_awesome,
    unit: '個',
  ),

  MissionModel(
    id: 'daily_003',
    title: '静夜散歩',
    description: '夜の冒険を1回達成しよう',
    type: MissionType.daily,
    currentProgress: 0,
    targetProgress: 1,
    rewardExp: 200,
    status: MissionStatus.inProgress,
    difficulty: MissionDifficulty.hard,
    icon: Icons.nightlight_round,
    unit: '回',
  ),

  MissionModel(
    id: 'weekly_001',
    title: '長距離遠征',
    description: '合計15km歩こう',
    type: MissionType.weekly,
    currentProgress: 8.2,
    targetProgress: 15,
    rewardExp: 200,
    status: MissionStatus.inProgress,
    difficulty: MissionDifficulty.hard,
    icon: Icons.route,
    unit: 'km',
  ),

  MissionModel(
    id: 'weekly_002',
    title: '冒険者の記録',
    description: '5回冒険を完了しよう',
    type: MissionType.weekly,
    currentProgress: 5,
    targetProgress: 5,
    rewardExp: 180,
    status: MissionStatus.completed,
    difficulty: MissionDifficulty.normal,
    icon: Icons.menu_book_rounded,
    unit: '回',
  ),
];
