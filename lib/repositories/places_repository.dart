// lib/repositories/places_repository.dart

import '../services/places_service.dart';

// ─────────────────────────────
// 📍 Places Repository
// ServiceとProviderの仲介役
// ─────────────────────────────

class PlacesRepository {
  final PlacesService _placesService;

  const PlacesRepository(this._placesService);

  // ─────────────────────────────
  // 🔍 地名候補検索
  // ─────────────────────────────

  Future<List<PlaceSuggestion>> searchPlaces(
    String query, {
    double? latitude,
    double? longitude,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      // 💡 開発中はダミー使用もOK
      // return _placesService
      //     .getDummySuggestions(query);

      return _placesService.searchPlaces(
        query,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      throw Exception('場所候補の取得に失敗しました: $e');
    }
  }

  // ─────────────────────────────
  // 📍 Place詳細取得
  // ─────────────────────────────

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    try {
      return _placesService.getPlaceDetail(placeId);
    } catch (e) {
      throw Exception('場所詳細の取得に失敗しました: $e');
    }
  }

  // ─────────────────────────────
  // ✨ デバッグ用
  // ダミー候補取得
  // ─────────────────────────────

  Future<List<PlaceSuggestion>> getDummySuggestions(String query) {
    return _placesService.getDummySuggestions(query);
  }
}
