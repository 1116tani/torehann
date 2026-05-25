// lib/providers/result_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/result_model.dart';

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
    StateNotifierProvider<ResultNotifier, ResultState>(
      (ref) => ResultNotifier(),
    );

// ─────────────────────────────────────
// 🎮 Notifier
// ─────────────────────────────────────

class ResultNotifier extends StateNotifier<ResultState> {
  ResultNotifier() : super(ResultState.initial()) {
    loadResult();
  }

  // ── リザルト読み込み ─────────────────
  Future<void> loadResult() async {
    state = state.copyWith(isLoading: true);

    // 💡 本番ではFirebaseから取得
    await Future.delayed(const Duration(milliseconds: 800));

    final dummy = AdventureResult.dummy();

    state = state.copyWith(
      isLoading: false,
      result: dummy,
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