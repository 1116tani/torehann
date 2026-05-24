// lib/providers/history_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_model.dart';

// ── 並び替えの種類 ──
enum SortOrder {
  newestFirst,    // 新しい順（デフォルト）
  oldestFirst,    // 古い順
  longestDistance, // 距離が長い順
  longestDuration, // 所要時間が長い順
}

// ── 絞り込みの種類（複数選択可） ──
enum FilterTag {
  completedOnly,  // 完走のみ
  withAbandoned,  // 中断あり
  withPhotos,     // 写真あり
  morning,        // 朝の冒険（6〜11時）
  night,          // 夜の冒険（20時以降）
  rainy,          // 雨の日
}

class HistoryState {
  final List<AdventureHistory> histories;
  final SortOrder sortOrder;
  final Set<FilterTag> activeFilters;
  final bool isLoading;

  const HistoryState({
    this.histories = const [],
    this.sortOrder = SortOrder.newestFirst,
    this.activeFilters = const {},
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<AdventureHistory>? histories,
    SortOrder? sortOrder,
    Set<FilterTag>? activeFilters,
    bool? isLoading,
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      sortOrder: sortOrder ?? this.sortOrder,
      activeFilters: activeFilters ?? this.activeFilters,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // ── 並び替え＋絞り込みを適用したリストを返す ──
  List<AdventureHistory> get filteredHistories {
    var result = List<AdventureHistory>.from(histories);

    // 絞り込み
    for (final filter in activeFilters) {
      result = result.where((h) {
        return switch (filter) {
          FilterTag.completedOnly  => h.isCompleted,
          FilterTag.withAbandoned  => !h.isCompleted,
          FilterTag.withPhotos     => h.photoUrls.isNotEmpty,
          FilterTag.morning        => h.startedAt.hour >= 6 && h.startedAt.hour < 11,
          FilterTag.night          => h.startedAt.hour >= 20,
          FilterTag.rainy          => h.tags.contains('雨の日'),
        };
      }).toList();
    }

    // 並び替え
    result.sort((a, b) {
      return switch (sortOrder) {
        SortOrder.newestFirst      => b.startedAt.compareTo(a.startedAt),
        SortOrder.oldestFirst      => a.startedAt.compareTo(b.startedAt),
        SortOrder.longestDistance  => b.distanceKm.compareTo(a.distanceKm),
        SortOrder.longestDuration  => b.durationMinutes.compareTo(a.durationMinutes),
      };
    });

    return result;
  }

  // ── サマリー計算 ──
  int get totalCount => histories.length;
  double get totalDistanceKm =>
      histories.fold(0.0, (sum, h) => sum + h.distanceKm);
}

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    // ダミーデータ（Firestore連携まで）
    return HistoryState(histories: _dummyHistories());
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void toggleFilter(FilterTag filter) {
    final current = Set<FilterTag>.from(state.activeFilters);
    current.contains(filter) ? current.remove(filter) : current.add(filter);
    state = state.copyWith(activeFilters: current);
  }

  void clearFilters() {
    state = state.copyWith(activeFilters: {});
  }

  // ダミーデータ
  List<AdventureHistory> _dummyHistories() {
    return [
      AdventureHistory(
        id: 'h001',
        startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        title: '古のパン屋を巡る調査員',
        weather: '☀️',
        distanceKm: 2.3,
        durationMinutes: 35,
        isCompleted: true,
        photoUrls: [],
        tags: ['朝の冒険'],
      ),
      AdventureHistory(
        id: 'h002',
        startedAt: DateTime.now().subtract(const Duration(days: 3)),
        title: '夕暮れの商店街冒険記',
        weather: '🌧️',
        distanceKm: 3.1,
        durationMinutes: 45,
        isCompleted: true,
        photoUrls: [],
        tags: ['雨の日'],
      ),
      AdventureHistory(
        id: 'h003',
        startedAt: DateTime.now().subtract(const Duration(days: 7)),
        title: '緑の隠れ家を求めて',
        weather: '☀️',
        distanceKm: 1.8,
        durationMinutes: 25,
        isCompleted: false,
        photoUrls: [],
        tags: [],
      ),
    ];
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);