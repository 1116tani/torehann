// lib/services/places_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

// ─────────────────────────────
// 📍 Place Suggestion Model
// ─────────────────────────────

class PlaceSuggestion {
  final String placeId;
  final String mainText;
  final String secondaryText;

  const PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    final formatting = json['structured_formatting'] ?? {};

    return PlaceSuggestion(
      placeId: json['place_id'] ?? '',
      mainText: formatting['main_text'] ?? '',
      secondaryText: formatting['secondary_text'] ?? '',
    );
  }
}

// ─────────────────────────────
// 📍 Place Detail Model
// ─────────────────────────────

class PlaceDetail {
  final double lat;
  final double lng;
  final String name;
  final String address;

  const PlaceDetail({
    required this.lat,
    required this.lng,
    required this.name,
    required this.address,
  });
}

// ─────────────────────────────
// 🗺️ Google Places Service
// ─────────────────────────────

class PlacesService {
  static const String _apiKey = ApiConstants.googlePlacesApiKey;

  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  // ─────────────────────────────
  // 🔍 場所検索（Autocomplete）
  // ─────────────────────────────

  Future<List<PlaceSuggestion>> searchPlaces(String input) async {
    if (input.trim().isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl/autocomplete/json'
        '?input=$input'
        '&language=ja'
        '&components=country:jp'
        '&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Place API Error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      final predictions = data['predictions'] as List<dynamic>?;

      if (predictions == null) {
        return [];
      }

      return predictions.map((e) => PlaceSuggestion.fromJson(e)).toList();
    } catch (e) {
      throw Exception('場所検索に失敗しました: $e');
    }
  }

  // ─────────────────────────────
  // 📍 Place詳細取得
  // ─────────────────────────────

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/details/json'
        '?place_id=$placeId'
        '&language=ja'
        '&fields=name,formatted_address,geometry'
        '&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Place Detail API Error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      final result = data['result'];

      if (result == null) {
        throw Exception('場所情報が見つかりません');
      }

      final location = result['geometry']['location'];

      return PlaceDetail(
        lat: (location['lat'] as num).toDouble(),
        lng: (location['lng'] as num).toDouble(),
        name: result['name'] ?? '',
        address: result['formatted_address'] ?? '',
      );
    } catch (e) {
      throw Exception('場所詳細取得に失敗しました: $e');
    }
  }

  // ─────────────────────────────
  // ✨ デバッグ用ダミー候補
  // API未接続時に便利
  // ─────────────────────────────

  Future<List<PlaceSuggestion>> getDummySuggestions(String input) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (input.isEmpty) return [];

    return [
      PlaceSuggestion(
        placeId: 'dummy_1',
        mainText: '$input駅',
        secondaryText: '愛知県',
      ),
      PlaceSuggestion(
        placeId: 'dummy_2',
        mainText: '$input公園',
        secondaryText: '東京都',
      ),
      PlaceSuggestion(
        placeId: 'dummy_3',
        mainText: '$input商店街',
        secondaryText: '大阪府',
      ),
    ];
  }
}
