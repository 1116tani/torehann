// lib/providers/history_provider.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventure_history_model.dart';
import '../models/result_model.dart';
import '../repositories/history_repository.dart';
import 'auth_provider.dart';

enum SortOrder {
  newestFirst,
  oldestFirst,
  longestDistance,
  longestDuration,
  mostExperience,
}

enum FilterTag {
  completedOnly,
  withAbandoned,
  withPhotos,
  morning,
  afternoon,
  night,
  sunny,
  cloudy,
  rainy,
}

class HistoryState {
  final List<AdventureHistoryModel> histories;
  final SortOrder sortOrder;
  final Set<FilterTag> activeFilters;
  final bool isLoading;
  final String? errorMessage;

  const HistoryState({
    this.histories = const [],
    this.sortOrder = SortOrder.newestFirst,
    this.activeFilters = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  HistoryState copyWith({
    List<AdventureHistoryModel>? histories,
    SortOrder? sortOrder,
    Set<FilterTag>? activeFilters,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HistoryState(
      histories: histories ?? this.histories,
      sortOrder: sortOrder ?? this.sortOrder,
      activeFilters: activeFilters ?? this.activeFilters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  List<AdventureHistoryModel> get filteredHistories {
    var result = List<AdventureHistoryModel>.from(histories);

    for (final filter in activeFilters) {
      result = result.where((history) {
        return switch (filter) {
          FilterTag.completedOnly => history.status == AdventureStatus.completed,
          FilterTag.withAbandoned => history.status == AdventureStatus.abandoned,
          FilterTag.withPhotos => history.imageUrls.isNotEmpty,
          FilterTag.morning =>
            history.createdAt.hour >= 6 && history.createdAt.hour < 12,
          FilterTag.afternoon =>
            history.createdAt.hour >= 12 && history.createdAt.hour < 17,
          FilterTag.night => history.createdAt.hour >= 17,
          FilterTag.sunny => history.weather == '晴れ',
          FilterTag.cloudy => history.weather == '曇り',
          FilterTag.rainy => history.weather == '雨',
        };
      }).toList();
    }

    result.sort((a, b) {
      return switch (sortOrder) {
        SortOrder.newestFirst => b.createdAt.compareTo(a.createdAt),
        SortOrder.oldestFirst => a.createdAt.compareTo(b.createdAt),
        SortOrder.longestDistance => b.distanceKm.compareTo(a.distanceKm),
        SortOrder.longestDuration =>
          b.durationMinutes.compareTo(a.durationMinutes),
        SortOrder.mostExperience =>
          (b.distanceKm * 10 + b.durationMinutes).compareTo(a.distanceKm * 10 + a.durationMinutes),
      };
    });

    return result;
  }

  int get totalCount => histories.length;

  double get totalDistanceKm {
    return histories.fold(0.0, (sum, history) => sum + history.distanceKm);
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

class HistoryNotifier extends Notifier<HistoryState> {
  StreamSubscription<List<AdventureHistoryModel>>? _subscription;

  @override
  HistoryState build() {
    ref.onDispose(() => _subscription?.cancel());
    Future.microtask(_subscribeToCurrentUserHistories);
    return const HistoryState(isLoading: true);
  }

  void _subscribeToCurrentUserHistories() {
    final user = ref.read(firebaseAuthProvider).currentUser;
    _subscription?.cancel();

    if (user == null) {
      state = const HistoryState();
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    _subscription = ref
        .read(historyRepositoryProvider)
        .watchHistories(user.uid)
        .listen(
      (histories) {
        state = state.copyWith(
          histories: histories,
          isLoading: false,
          errorMessage: null,
        );
      },
      onError: (Object error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> reload() async {
    _subscribeToCurrentUserHistories();
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void toggleFilter(FilterTag filter) {
    final current = Set<FilterTag>.from(state.activeFilters);
    if (current.contains(filter)) {
      current.remove(filter);
    } else {
      current.add(filter);
    }
    state = state.copyWith(activeFilters: current);
  }

  void clearFilters() {
    state = state.copyWith(activeFilters: {});
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);
