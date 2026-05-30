// lib/services/places_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class PlaceSuggestion {
  final String placeId;
  final String mainText;
  final String secondaryText;
  final String fullText;

  const PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.fullText,
  });

  factory PlaceSuggestion.fromAutocompleteJson(Map<String, dynamic> json) {
    final prediction = json['placePrediction'] ?? json['queryPrediction'] ?? {};
    final structuredFormat = prediction['structuredFormat'] ?? {};
    final mainText = structuredFormat['mainText']?['text'] ?? '';
    final secondaryText = structuredFormat['secondaryText']?['text'] ?? '';
    final fullText = prediction['text']?['text'] ?? mainText;
    final placeId =
        prediction['placeId'] ?? _placeIdFromName(prediction['place']);

    return PlaceSuggestion(
      placeId: placeId,
      mainText: mainText.isNotEmpty ? mainText : fullText,
      secondaryText: secondaryText,
      fullText: fullText,
    );
  }

  static String _placeIdFromName(dynamic placeName) {
    if (placeName is! String || placeName.isEmpty) {
      return '';
    }

    return placeName.split('/').last;
  }
}

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

class PlacesService {
  static String get _apiKey => ApiConstants.googlePlacesApiKey;

  static const String _baseUrl = 'https://places.googleapis.com/v1';

  Future<List<PlaceSuggestion>> searchPlaces(
    String input, {
    double? latitude,
    double? longitude,
  }) async {
    final normalizedInput = input.trim();
    if (normalizedInput.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse('$_baseUrl/places:autocomplete');
      final requestBody = <String, dynamic>{
        'input': normalizedInput,
        'languageCode': 'ja',
        'regionCode': 'JP',
        'includedRegionCodes': ['jp'],
        'includeQueryPredictions': false,
      };

      if (latitude != null && longitude != null) {
        requestBody['locationBias'] = {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': 50000.0,
          },
        };
        requestBody['origin'] = {'latitude': latitude, 'longitude': longitude};
      }

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': [
            'suggestions.placePrediction.placeId',
            'suggestions.placePrediction.place',
            'suggestions.placePrediction.text.text',
            'suggestions.placePrediction.structuredFormat.mainText.text',
            'suggestions.placePrediction.structuredFormat.secondaryText.text',
          ].join(','),
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Place API Error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final suggestions = data['suggestions'] as List<dynamic>?;

      if (suggestions == null) {
        return [];
      }

      return suggestions
          .map((e) => PlaceSuggestion.fromAutocompleteJson(e))
          .where((suggestion) => suggestion.mainText.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('場所候補の取得に失敗しました: $e');
    }
  }

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    final normalizedPlaceId = placeId.trim();
    if (normalizedPlaceId.isEmpty) {
      throw Exception('placeId is empty');
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl/places/$normalizedPlaceId?languageCode=ja',
      );
      final response = await http.get(
        uri,
        headers: {
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'displayName,formattedAddress,location',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Place Detail API Error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final location = data['location'];

      if (location == null) {
        throw Exception('場所の座標が見つかりません');
      }

      return PlaceDetail(
        lat: (location['latitude'] as num).toDouble(),
        lng: (location['longitude'] as num).toDouble(),
        name: data['displayName']?['text'] ?? '',
        address: data['formattedAddress'] ?? '',
      );
    } catch (e) {
      throw Exception('場所詳細の取得に失敗しました: $e');
    }
  }

  Future<List<PlaceSuggestion>> getDummySuggestions(String input) async {
    final normalizedInput = input.trim();
    if (normalizedInput.isEmpty) return [];

    return [
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInputから名古屋駅',
        secondaryText: '経路検索',
        fullText: '$normalizedInputから名古屋駅',
      ),
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInput 駐車場',
        secondaryText: '目的地候補',
        fullText: '$normalizedInput 駐車場',
      ),
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInput 居酒屋',
        secondaryText: '目的地候補',
        fullText: '$normalizedInput 居酒屋',
      ),
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInput 飲食店',
        secondaryText: '目的地候補',
        fullText: '$normalizedInput 飲食店',
      ),
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInput ランチ',
        secondaryText: '目的地候補',
        fullText: '$normalizedInput ランチ',
      ),
      PlaceSuggestion(
        placeId: '',
        mainText: '$normalizedInput ラーメン',
        secondaryText: '目的地候補',
        fullText: '$normalizedInput ラーメン',
      ),
    ];
  }
}
