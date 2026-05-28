// lib/repositories/route_repository.dart

import '../models/route_model.dart';
import '../services/gemini_service.dart';
import '../utils/route_dummy_data.dart';

class RouteRepository {
  final GeminiService _geminiService;

  RouteRepository({required GeminiService geminiService})
    : _geminiService = geminiService;

  // ─────────────────────────────
  // 🗺️ AIルート生成
  // ─────────────────────────────

  Future<List<RouteModel>> generateRoutes({
    required double lat,
    required double lng,
    required String mood,
    required String mode,
    required List<String> hobbyTags,
    String destination = '',
  }) async {
    try {
      if (!GeminiService.hasApiKey) {
        return buildFallbackRoutes(
          lat: lat,
          lng: lng,
          mood: mood,
          mode: mode,
          hobbyTags: hobbyTags,
          destination: destination,
        );
      }

      final routes = await _geminiService.generateRoutes(
        lat: lat,
        lng: lng,
        mood: mood,
        mode: mode,
        hobbyTags: hobbyTags,
        destination: destination,
      );

      // 空レスポンス対策
      if (routes.isEmpty) {
        throw Exception('ルートが生成されませんでした');
      }

      return routes;
    } catch (e) {
      throw Exception('ルート生成に失敗しました\n$e');
    }
  }

  // ─────────────────────────────
  // 📝 冒険レポート生成
  // ─────────────────────────────

  Future<String> generateAdventureReport({
    required RouteModel route,
    required double walkedDistanceKm,
    required int durationMinutes,
  }) async {
    try {
      return await _geminiService.generateAdventureReport(
        themeName: route.themeName,
        visitedSpots: route.generatedSpots,
        distanceKm: walkedDistanceKm,
        durationMinutes: durationMinutes,
      );
    } catch (e) {
      throw Exception('冒険レポート生成に失敗しました\n$e');
    }
  }
}
