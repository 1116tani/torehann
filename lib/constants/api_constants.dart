// lib/constants/api_constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // ─────────────────────────────
  // 🔑 API Keys (from .env)
  // ─────────────────────────────

  /// Gemini API Key
  static String get geminiApiKey => dotenv.get('GEMINI_API_KEY', fallback: '');

  /// Google Places API Key
  static String get googlePlacesApiKey =>
      dotenv.get('GOOGLE_PLACES_API_KEY', fallback: '');

  /// OpenWeatherMap API Key
  static String get openWeatherMapApiKey =>
      dotenv.get('OPEN_WEATHER_MAP_API_KEY', fallback: '');

  /// Google Maps API Key
  static String get googleMapsApiKey =>
      dotenv.get('GOOGLE_MAPS_API_KEY', fallback: '');
}
