// lib/providers/level_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/exp_utils.dart';
import '../models/rank_definition.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

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
// UserModel Stream Provider
// ─────────────────────────────────────────
final userModelProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(user.uid);
});

// ─────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────
class LevelNotifier extends Notifier<LevelState> {
  @override
  LevelState build() {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    if (user != null) {
      ref.listen(userModelProvider, (previous, next) {
        if (next.hasValue && next.value != null) {
          state = LevelCalculator.fromTotalXp(next.value!.exp);
        }
      });
      final initialVal = ref.read(userModelProvider).value;
      if (initialVal != null) {
        return LevelCalculator.fromTotalXp(initialVal.exp);
      }
    }
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
