// lib/providers/places_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../repositories/places_repository.dart';
import '../services/places_service.dart';

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
