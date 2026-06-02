// lib/providers/places_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repositories/places_repository.dart';
import '../services/places_service.dart';

// ─────────────────────────────
// 📍 PlaceItem
// ウィジェット向けの簡易モデル
// ─────────────────────────────

class PlaceItem {
  final String placeId;
  final String name;
  final String address;
  final String fullText;
  final int? distanceMeters;

  const PlaceItem({
    required this.placeId,
    required this.name,
    required this.address,
    required this.fullText,
    this.distanceMeters,
  });

  factory PlaceItem.fromSuggestion(PlaceSuggestion s) {
    return PlaceItem(
      placeId: s.placeId,
      name: s.mainText,
      address: s.secondaryText,
      fullText: s.fullText,
      distanceMeters: s.distanceMeters,
    );
  }
}

// ─────────────────────────────
// 📦 PlacesState
// ─────────────────────────────

class PlacesState {
  final bool isLoading;
  final List<PlaceItem> places;
  final String? errorMessage;

  const PlacesState({
    this.isLoading = false,
    this.places = const [],
    this.errorMessage,
  });

  PlacesState copyWith({
    bool? isLoading,
    List<PlaceItem>? places,
    String? errorMessage,
  }) {
    return PlacesState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      errorMessage: errorMessage,
    );
  }
}

// ─────────────────────────────
// 🔔 PlacesNotifier
// ─────────────────────────────

class PlacesNotifier extends StateNotifier<PlacesState> {
  final PlacesRepository _repository;

  PlacesNotifier(this._repository) : super(const PlacesState());

  Future<void> searchPlaces(
    String query, {
    double? latitude,
    double? longitude,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clear();
      return;
    }

    state = state.copyWith(isLoading: true, places: []);

    try {
      final suggestions = await _repository.searchPlaces(
        normalizedQuery,
        latitude: latitude,
        longitude: longitude,
      );

      final sortedSuggestions = List<PlaceSuggestion>.from(suggestions);
      sortedSuggestions.sort((a, b) {
        final distA = a.distanceMeters;
        final distB = b.distanceMeters;
        if (distA != null && distB != null) {
          return distA.compareTo(distB);
        } else if (distA != null) {
          return -1;
        } else if (distB != null) {
          return 1;
        } else {
          return 0;
        }
      });

      state = state.copyWith(
        isLoading: false,
        places: sortedSuggestions.map(PlaceItem.fromSuggestion).take(6).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        places: [],
        errorMessage: e.toString(),
      );
    }
  }

  void clear() {
    state = const PlacesState();
  }
}

// ─────────────────────────────
// 🔍 placesProvider
// StateNotifierProvider（メイン）
// ─────────────────────────────

final placesProvider = StateNotifierProvider<PlacesNotifier, PlacesState>((
  ref,
) {
  final repository = ref.read(placesRepositoryProvider);
  return PlacesNotifier(repository);
});

// ─────────────────────────────
// 📍 PlacesService Provider
// ─────────────────────────────

final placesServiceProvider = Provider<PlacesService>((ref) {
  return PlacesService();
});

// ─────────────────────────────
// 📦 PlacesRepository Provider
// ─────────────────────────────

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  final service = ref.read(placesServiceProvider);

  return PlacesRepository(service);
});

// ─────────────────────────────
// 🔍 検索ワード State
// ─────────────────────────────

final placeSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

// ─────────────────────────────
// 📍 Places候補検索
// Google Places API
// ─────────────────────────────

final placesSuggestionsProvider =
    FutureProvider.autoDispose<List<PlaceSuggestion>>((ref) async {
      final query = ref.watch(placeSearchQueryProvider);

      // 空文字なら検索しない
      if (query.trim().isEmpty) {
        return [];
      }

      final repository = ref.read(placesRepositoryProvider);

      return repository.searchPlaces(query);
    });

// ─────────────────────────────
// 📌 Place詳細取得
// placeIdから座標取得
// ─────────────────────────────

final placeDetailProvider = FutureProvider.family<PlaceDetail, String>((
  ref,
  placeId,
) async {
  final repository = ref.read(placesRepositoryProvider);

  return repository.getPlaceDetail(placeId);
});
