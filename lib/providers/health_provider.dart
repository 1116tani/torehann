// lib/providers/health_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health/health_record_model.dart';
import '../models/health/health_summary_model.dart';
import '../models/health/health_topic_model.dart';
import '../models/health_model.dart';
import '../utils/health_dummy_data.dart';
import 'package:flutter/material.dart';

/// ─────────────────────────────────────────
/// 期間切り替え
/// ─────────────────────────────────────────
enum HealthPeriod {
  day,
  week,
  month,
  year,
}

/// ─────────────────────────────────────────
/// 状態管理モデル
/// ─────────────────────────────────────────
class HealthState {
  final HealthPeriod selectedPeriod;
  final HealthModel health;
  final List<HealthRecordModel> records;
  final HealthSummaryModel summary;
  final List<HealthTopicModel> topics;

  const HealthState({
    required this.selectedPeriod,
    required this.health,
    required this.records,
    required this.summary,
    required this.topics,
  });

  List<double> get graphData => records.map((r) => r.steps.toDouble()).toList();

  HealthState copyWith({
    HealthPeriod? selectedPeriod,
    HealthModel? health,
    List<HealthRecordModel>? records,
    HealthSummaryModel? summary,
    List<HealthTopicModel>? topics,
  }) {
    return HealthState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      health: health ?? this.health,
      records: records ?? this.records,
      summary: summary ?? this.summary,
      topics: topics ?? this.topics,
    );
  }
}

/// ─────────────────────────────────────────
/// Provider本体
/// ─────────────────────────────────────────
class HealthNotifier extends Notifier<HealthState> {
  @override
  HealthState build() {
    return HealthState(
      selectedPeriod: HealthPeriod.week,
      health: HealthDummyData.todayData,

      // ダミーデータ
      records: [
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 6)),
          steps: 5230,
          distanceKm: 3.1,
          calories: 132,
        ),
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 5)),
          steps: 8420,
          distanceKm: 5.2,
          calories: 281,
        ),
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 4)),
          steps: 12450,
          distanceKm: 7.8,
          calories: 401,
        ),
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 3)),
          steps: 6100,
          distanceKm: 4.0,
          calories: 188,
        ),
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 2)),
          steps: 9300,
          distanceKm: 6.1,
          calories: 320,
        ),
        HealthRecordModel(
          date: DateTime.now().subtract(const Duration(days: 1)),
          steps: 7420,
          distanceKm: 4.7,
          calories: 240,
        ),
        HealthRecordModel(
          date: DateTime.now(),
          steps: 8910,
          distanceKm: 5.5,
          calories: 296,
        ),
      ],

      summary: const HealthSummaryModel(
        totalSteps: 57830,
        totalDistanceKm: 36.4,
        totalCalories: 1858,
      ),

      topics: const [
        HealthTopicModel(
          title: '最高歩数記録',
          description: '12,450歩 • 2026/05/10',
          icon: Icons.emoji_events,
        ),
        HealthTopicModel(
          title: '深夜の冒険者',
          description: '夜の冒険を20回達成',
          icon: Icons.nightlight_round,
        ),
        HealthTopicModel(
          title: 'ファンタジーモード踏破',
          description: '累計50km達成',
          icon: Icons.auto_awesome,
        ),
      ],
    );
  }

  /// 期間切り替え
  void changePeriod(HealthPeriod period) {
    state = state.copyWith(
      selectedPeriod: period,
    );

    // TODO:
    // API連携時に期間ごとのデータ取得
  }
}

/// ─────────────────────────────────────────
/// Riverpod Provider
/// ─────────────────────────────────────────
final healthProvider =
    NotifierProvider<HealthNotifier, HealthState>(
      HealthNotifier.new,
    );