// lib/providers/level_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/exp_utils.dart';
import '../models/rank_definition.dart';

// ─────────────────────────────────────────
// レベル状態モデル
// ─────────────────────────────────────────
class LevelState {
  final int totalXp;
  final int level;
  final int currentLevelXp;
  final int nextLevelXp;
  final RankDefinition rank;

  const LevelState({
    required this.totalXp,
    required this.level,
    required this.currentLevelXp,
    required this.nextLevelXp,
    required this.rank,
  });

  double get progress =>
      nextLevelXp > 0
          ? (currentLevelXp / nextLevelXp).clamp(0.0, 1.0).toDouble()
          : 0.0;

  LevelState copyWith({
    int? totalXp,
    int? level,
    int? currentLevelXp,
    int? nextLevelXp,
    RankDefinition? rank,
  }) {
    return LevelState(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentLevelXp: currentLevelXp ?? this.currentLevelXp,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
      rank: rank ?? this.rank,
    );
  }
}

// ─────────────────────────────────────────
// レベル計算ロジック
// ─────────────────────────────────────────
class LevelCalculator {
  /// 総累積XPからLevelStateを構築する
  static LevelState fromTotalXp(int totalXp) {
    final level = ExpUtils.getLevelFromXp(totalXp);
    final thisLevelStartXp = ExpUtils.totalXpForLevel(level);
    final nextLevelStartXp = ExpUtils.totalXpForLevel(level + 1);
    final currentLevelXp = totalXp - thisLevelStartXp;
    final nextLevelXp = nextLevelStartXp - thisLevelStartXp;
    final rank = ExpUtils.getRank(level);

    return LevelState(
      totalXp: totalXp,
      level: level,
      currentLevelXp: currentLevelXp,
      nextLevelXp: nextLevelXp,
      rank: rank,
    );
  }
}

// ─────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────
class LevelNotifier extends Notifier<LevelState> {
  @override
  LevelState build() {
    // 初期値: 総XP = 0（認証後に loadFromXp で更新する想定）
    return LevelCalculator.fromTotalXp(0);
  }

  /// 総累積XPを受け取ってレベル状態を更新する
  void loadFromXp(int totalXp) {
    state = LevelCalculator.fromTotalXp(totalXp);
  }

  /// XPを加算してレベルを再計算する
  void addXp(int xp) {
    state = LevelCalculator.fromTotalXp(state.totalXp + xp);
  }
}

// ─────────────────────────────────────────
// Riverpod Provider
// ─────────────────────────────────────────
final levelProvider = NotifierProvider<LevelNotifier, LevelState>(
  LevelNotifier.new,
);
