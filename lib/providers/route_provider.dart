// lib/providers/route_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_model.dart';
import '../models/spot_model.dart';

import '../repositories/route_repository.dart';
import '../services/gemini_service.dart';

import 'adventure_provider.dart';
import 'location_provider.dart';

// ─────────────────────────────
// 🗺️ Route State
// ─────────────────────────────

class RouteSelectState {
  final List<RouteModel> routes;

  final String? selectedRouteId;

  final bool isLoading;

  final String? errorMessage;

  const RouteSelectState({
    this.routes = const [],
    this.selectedRouteId,
    this.isLoading = false,
    this.errorMessage,
  });

  // ─────────────────────────────
  // 📍 選択中ルート
  // ─────────────────────────────

  RouteModel? get selectedRoute {
    if (selectedRouteId == null) return null;

    try {
      return routes.firstWhere((route) => route.id == selectedRouteId);
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────
  // ✨ copyWith
  // ─────────────────────────────

  RouteSelectState copyWith({
    List<RouteModel>? routes,
    String? selectedRouteId,
    bool? isLoading,
    String? errorMessage,

    bool clearSelectedRoute = false,
    bool clearError = false,
  }) {
    return RouteSelectState(
      routes: routes ?? this.routes,

      selectedRouteId: clearSelectedRoute
          ? null
          : (selectedRouteId ?? this.selectedRouteId),

      isLoading: isLoading ?? this.isLoading,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─────────────────────────────
// 🛰️ Repository Provider
// ─────────────────────────────

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return RouteRepository(geminiService: GeminiService());
});

// ─────────────────────────────
// 🗺️ Route Notifier
// ─────────────────────────────

class RouteSelectNotifier extends Notifier<RouteSelectState> {
  @override
  RouteSelectState build() {
    return const RouteSelectState();
  }

  // ─────────────────────────────
  // 📍 ルート選択
  // ─────────────────────────────

  void selectRoute(String routeId) {
    state = state.copyWith(selectedRouteId: routeId);
  }

  // ─────────────────────────────
  // ✨ ルート生成
  // ─────────────────────────────

  Future<bool> generateRoutes() async {
    try {
      // 🔄 Loading開始
      state = state.copyWith(isLoading: true, clearError: true);

      // ───────────────────
      // 📍 現在地取得
      // ───────────────────

      final position = await ref.read(currentLocationProvider.future);

      // ───────────────────
      // 🌌 冒険設定取得
      // ───────────────────

      final adventure = ref.read(adventureProvider);

      // ───────────────────
      // 🛰️ Repository取得
      // ───────────────────

      final repository = ref.read(routeRepositoryProvider);

      // ───────────────────
      // ✨ AI生成
      // ───────────────────

      final routes = await repository.generateRoutes(
        lat: position.latitude,
        lng: position.longitude,

        mood: adventure.mood.label,

        mode: adventure.mode.label,

        hobbyTags: adventure.hobbyTags,

        destination: adventure.isRandomMode ? '' : adventure.destination,
      );

      // ───────────────────
      // ❌ 空チェック
      // ───────────────────

      if (routes.isEmpty) {
        throw Exception('ルートが生成されませんでした');
      }

      // ───────────────────
      // ✅ 成功
      // ───────────────────

      state = state.copyWith(
        routes: routes,

        selectedRouteId: routes.first.id,

        isLoading: false,
      );

      return true;
    } catch (e) {
      // ───────────────────
      // ❌ エラー
      // ───────────────────

      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      return false;
    }
  }

  // ─────────────────────────────
  // 🧹 リセット
  // ─────────────────────────────

  void reset() {
    state = const RouteSelectState();
  }

  // ─────────────────────────────
  // ❌ エラークリア
  // ─────────────────────────────

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ─────────────────────────────
// 🗺️ Provider
// ─────────────────────────────

final routeSelectProvider =
    NotifierProvider<RouteSelectNotifier, RouteSelectState>(
      RouteSelectNotifier.new,
    );

// ─────────────────────────────
// 📍 Spot Lookup
// ─────────────────────────────

final generatedSpotsProvider = Provider<Map<String, SpotModel>>((ref) {
  final routes = ref.watch(routeSelectProvider).routes;

  final map = <String, SpotModel>{};

  for (final route in routes) {
    for (final spot in route.generatedSpots) {
      map[spot.id] = spot;
    }
  }

  return map;
});
