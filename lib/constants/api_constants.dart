// lib/constants/api_constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // ─────────────────────────────
  // 🔑 API Keys (from .env)
  // ─────────────────────────────

  static String _getFirstNonEmpty(List<String> keys) {
    for (final key in keys) {
      final value = dotenv.get(key, fallback: '').trim();
      if (value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  /// Gemini API Key
  static String get geminiApiKey => _getFirstNonEmpty([
    'GEMINI_API_KEY',
    'Gemini_API_Key',
  ]);

  /// Google Places API Key
  static String get googlePlacesApiKey =>
      dotenv.get('GOOGLE_PLACES_API_KEY', fallback: '');

  /// OpenWeatherMap API Key
  static String get openWeatherMapApiKey => _getFirstNonEmpty([
    'OPEN_WEATHER_MAP_API_KEY',
    'Weather_API_Key',
  ]);

  /// Google Maps API Key
  static String get googleMapsApiKey =>
      dotenv.get('GOOGLE_MAPS_API_KEY', fallback: '');
}
