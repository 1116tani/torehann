// lib/providers/route_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../models/route_model.dart';
import '../models/spot_model.dart';

import '../repositories/route_repository.dart';
import '../services/gemini_service.dart';
import '../services/route_builder_service.dart';

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
      final searchArea = await _resolveSearchArea(
        position.latitude,
        position.longitude,
      );

      // ───────────────────
      // 🌌 冒険設定取得
      // ───────────────────

      final adventure = ref.read(adventureProvider);
      final resolvedDestination = await _resolveDestination(
        adventure,
        searchArea: searchArea,
      );

      // ───────────────────
      // 🛰️ Repository取得
      // ───────────────────

      final repository = ref.read(routeRepositoryProvider);

      // ───────────────────
      // ✨ AI生成
      // ───────────────────

      final rawRoutes = await repository.generateRoutes(
        lat: position.latitude,
        lng: position.longitude,

        mood: adventure.mood.label,

        mode: adventure.mode.label,

        hobbyTags: adventure.hobbyTags,

        destination: adventure.isRandomMode ? '' : adventure.destinationName,
      );

      // ───────────────────
      // ❌ 空チェック
      // ───────────────────

      if (rawRoutes.isEmpty) {
        throw Exception('ルートが生成されませんでした');
      }

      // ───────────────────
      // 🛠️ クライアントサイドでのルート再構築 (現在地 ➡ 経由地 ➡ 目的地)
      // ───────────────────
      final routeBuilder = ref.read(routeBuilderServiceProvider);
      final builtRoutes = <RouteModel>[];
      for (final rawRoute in rawRoutes) {
        final resolvedSpots = await _resolveSpotCoordinates(
          rawRoute.generatedSpots,
          fallbackArea: searchArea,
        );

        builtRoutes.add(
          routeBuilder.buildRoute(
            id: rawRoute.id,
            startLat: position.latitude,
            startLng: position.longitude,
            themeName: rawRoute.themeName,
            themeDescription: rawRoute.themeDescription,
            tags: rawRoute.tags,
            geminiSpots: resolvedSpots,
            destinationName: resolvedDestination?.name,
            destinationLat: resolvedDestination?.lat,
            destinationLng: resolvedDestination?.lng,
          ),
        );
      }

      // ───────────────────
      // ✅ 成功
      // ───────────────────

      state = state.copyWith(
        routes: builtRoutes,

        selectedRouteId: builtRoutes.first.id,

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

  Future<_ResolvedPlace?> _resolveDestination(
    AdventureState adventure, {
    String? searchArea,
  }) async {
    final name = adventure.destinationName.trim();
    if (adventure.isRandomMode || name.isEmpty) {
      return null;
    }

    if (adventure.destinationLat != null && adventure.destinationLng != null) {
      return _ResolvedPlace(
        name: name,
        lat: adventure.destinationLat,
        lng: adventure.destinationLng,
      );
    }

    final location = await _geocodePlace(name, fallbackArea: searchArea);
    return _ResolvedPlace(
      name: name,
      lat: location?.latitude,
      lng: location?.longitude,
    );
  }

  Future<List<SpotModel>> _resolveSpotCoordinates(
    List<SpotModel> spots, {
    String? fallbackArea,
  }) async {
    final resolved = <SpotModel>[];

    for (final spot in spots) {
      final location = await _geocodePlace(
        spot.name,
        fallbackArea: fallbackArea,
      );
      if (location == null) {
        resolved.add(spot);
        continue;
      }

      resolved.add(
        SpotModel(
          id: spot.id,
          lat: location.latitude,
          lng: location.longitude,
          name: spot.name,
          category: spot.category,
          aiStoryName: spot.aiStoryName,
          aiFlavorText: spot.aiFlavorText,
        ),
      );
    }

    return resolved;
  }

  Future<String?> _resolveSearchArea(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) {
        return null;
      }

      final placemark = placemarks.first;
      final parts = [
        placemark.administrativeArea,
        placemark.locality,
        placemark.subLocality,
      ].where((part) => part != null && part.trim().isNotEmpty);

      final area = parts.join(' ');
      return area.isEmpty ? null : area;
    } catch (_) {
      return null;
    }
  }

  Future<Location?> _geocodePlace(String query, {String? fallbackArea}) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return null;
    }

    final area = fallbackArea?.trim();
    final address = [
      normalizedQuery,
      if (area != null && area.isNotEmpty) area,
      '日本',
    ].join(', ');

    try {
      final locations = await locationFromAddress(address);
      return locations.isEmpty ? null : locations.first;
    } catch (_) {
      return null;
    }
  }
}

class _ResolvedPlace {
  final String name;
  final double? lat;
  final double? lng;

  const _ResolvedPlace({required this.name, this.lat, this.lng});
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
