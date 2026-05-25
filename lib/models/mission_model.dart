// lib/models/mission_model.dart

import 'package:flutter/material.dart';

/// ── ミッション種類 ──────────────────────────
enum MissionType {
  daily,
  weekly,
}

/// ── ミッション状態 ──────────────────────────
enum MissionStatus {
  inProgress,
  completed,
  claimed,
}

/// ── ミッション難易度 ────────────────────────
enum MissionDifficulty {
  easy,
  normal,
  hard,
}

/// ── ミッションモデル ────────────────────────
class MissionModel {
  final String id;

  /// ミッションタイトル
  final String title;

  /// 詳細説明
  final String description;

  /// デイリー or ウィークリー
  final MissionType type;

  /// 現在進捗
  final double currentProgress;

  /// 必要進捗
  final double targetProgress;

  /// 報酬EXP
  final int rewardExp;

  /// 状態
  final MissionStatus status;

  /// 難易度
  final MissionDifficulty difficulty;

  /// アイコン
  final IconData icon;

  /// 単位
  final String unit;

  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.currentProgress,
    required this.targetProgress,
    required this.rewardExp,
    required this.status,
    required this.difficulty,
    required this.icon,
    required this.unit,
  });

  /// ── 進捗率 ──────────────────────────
  double get progressRatio {
    if (targetProgress <= 0) return 0;
    return (currentProgress / targetProgress).clamp(0.0, 1.0);
  }

  /// ── 達成済みか ──────────────────────
  bool get isCompleted {
    return currentProgress >= targetProgress;
  }

  /// ── 報酬受取可能か ──────────────────
  bool get canClaim {
    return status == MissionStatus.completed;
  }

  /// ── 難易度スター数 ──────────────────
  int get difficultyStars {
    switch (difficulty) {
      case MissionDifficulty.easy:
        return 1;

      case MissionDifficulty.normal:
        return 2;

      case MissionDifficulty.hard:
        return 3;
    }
  }
}