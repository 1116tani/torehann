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
    bool clearSelected = false,
    bool clearError = false,
  }) {
    return RouteSelectState(
      routes: routes ?? this.routes,

      selectedRouteId: clearSelected
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
  // ✨ AIルート生成
  // ─────────────────────────────

  Future<void> generateRoutes() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      // 🌌 冒険設定取得
      final adventure = ref.read(adventureProvider);

      // 📍 現在地取得
      final position = await ref.read(currentLocationProvider.future);

      // 🛰️ Repository
      final repository = ref.read(routeRepositoryProvider);

      // ✨ Gemini生成
      final routes = await repository.generateRoutes(
        lat: position.latitude,
        lng: position.longitude,

        mood: adventure.mood.name,

        mode: adventure.mode.label,

        hobbyTags: adventure.hobbyTags,

        destination: adventure.isRandomMode ? '' : adventure.destination,
      );

      if (routes.isEmpty) {
        throw Exception('ルートが生成されませんでした');
      }

      state = state.copyWith(
        routes: routes,

        selectedRouteId: routes.first.id,

        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ─────────────────────────────
  // 🧹 リセット
  // ─────────────────────────────

  void reset() {
    state = const RouteSelectState();
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
// 📍 Spots Lookup
// ─────────────────────────────

final dummySpotsProvider = Provider<Map<String, SpotModel>>((ref) {
  final routes = ref.watch(routeSelectProvider).routes;
  final map = <String, SpotModel>{};
  for (final route in routes) {
    for (final spot in route.generatedSpots) {
      map[spot.id] = spot;
    }
  }
  return map;
});
