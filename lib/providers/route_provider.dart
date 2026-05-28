// lib/providers/route_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_model.dart';
import '../models/spot_model.dart';

import 'adventure_provider.dart';

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

  Future<void> generateRoutes() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final settings = ref.read(adventureProvider);

      final allSpots = ref.read(dummySpotsProvider);

      // 🌙 演出用待機
      await Future.delayed(const Duration(seconds: 2));

      final generatedRoutes = [
        // ───────────────────
        // 黄昏ルート
        // ───────────────────
        RouteModel(
          id: 'route_twilight_memory',

          themeName: '黄昏の記憶巡礼',

          themeDescription: '夕暮れに沈む街の断片を辿る、静かな探索路。',

          spotIds: const ['spot_001', 'spot_002', 'spot_003'],

          generatedSpots: const [
            'spot_001',
            'spot_002',
            'spot_003',
          ].map((id) => allSpots[id]!).toList(),

          totalDistance: 2.4,

          estimatedTime: 36,

          tags: ['#${settings.mode.label}', '#黄昏', '#静かな冒険'],
        ),

        // ───────────────────
        // レトロルート
        // ───────────────────
        RouteModel(
          id: 'route_nostalgia',

          themeName: '忘却街のレトロ探索',

          themeDescription: '色あせた商店街に眠る記憶を解読する旅。',

          spotIds: const ['spot_006', 'spot_007', 'spot_008'],

          generatedSpots: const [
            'spot_006',
            'spot_007',
            'spot_008',
          ].map((id) => allSpots[id]!).toList(),

          totalDistance: 1.8,

          estimatedTime: 28,

          tags: const ['#レトロ', '#路地裏', '#物語収集'],
        ),

        // ───────────────────
        // 夜霧ルート
        // ───────────────────
        RouteModel(
          id: 'route_midnight_fog',

          themeName: '夜霧の境界探索',

          themeDescription: '霧に隠された都市の裏側を歩く禁断の探索路。',

          spotIds: const ['spot_011', 'spot_012', 'spot_013'],

          generatedSpots: const [
            'spot_011',
            'spot_012',
            'spot_013',
          ].map((id) => allSpots[id]!).toList(),

          totalDistance: 3.1,

          estimatedTime: 45,

          tags: const ['#夜', '#霧', '#幻想'],
        ),
      ];

      state = state.copyWith(
        routes: generatedRoutes,

        selectedRouteId: generatedRoutes.first.id,

        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '探索路の生成に失敗しました。');
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
// 📍 ダミースポット
// ─────────────────────────────

final dummySpotsProvider = Provider<Map<String, SpotModel>>((ref) {
  return {
    // ───────────────────
    // 黄昏ルート
    // ───────────────────
    'spot_001': const SpotModel(
      id: 'spot_001',

      lat: 35.6812,
      lng: 139.7671,

      name: '老舗パン屋',

      category: 'カフェ',

      aiStoryName: '記憶の香りを宿す工房',

      aiFlavorText: '焼き立ての香りが、遠い日の帰り道を思い出させる。',
    ),

    'spot_002': const SpotModel(
      id: 'spot_002',

      lat: 35.6820,
      lng: 139.7680,

      name: '隠れ家喫茶',

      category: 'カフェ',

      aiStoryName: '時の止まった喫茶室',

      aiFlavorText: '静かなレコードの音が、黄昏に溶けていく。',
    ),

    'spot_003': const SpotModel(
      id: 'spot_003',

      lat: 35.6835,
      lng: 139.7665,

      name: '小さな公園',

      category: '公園',

      aiStoryName: '都会の隙間の庭園',

      aiFlavorText: '風に揺れる木々が、旅人へ静かに語りかける。',
    ),

    // ───────────────────
    // レトロルート
    // ───────────────────
    'spot_006': const SpotModel(
      id: 'spot_006',

      lat: 35.6800,
      lng: 139.7650,

      name: '駄菓子屋',

      category: '商店街',

      aiStoryName: '色あせない宝箱',

      aiFlavorText: '幼い日の夢が、棚いっぱいに並べられている。',
    ),

    'spot_007': const SpotModel(
      id: 'spot_007',

      lat: 35.6790,
      lng: 139.7640,

      name: '時計店',

      category: '商店街',

      aiStoryName: '時を刻む工房',

      aiFlavorText: '静かな秒針が、街の鼓動のように響いている。',
    ),

    'spot_008': const SpotModel(
      id: 'spot_008',

      lat: 35.6780,
      lng: 139.7630,

      name: '夕日の丘',

      category: '風景',

      aiStoryName: '黄昏の観測所',

      aiFlavorText: '世界の終わりみたいな夕焼けが広がっている。',
    ),

    // ───────────────────
    // 夜霧ルート
    // ───────────────────
    'spot_011': const SpotModel(
      id: 'spot_011',

      lat: 35.6765,
      lng: 139.7615,

      name: '地下通路',

      category: '路地裏',

      aiStoryName: '霧に沈む回廊',

      aiFlavorText: '誰もいないはずなのに、足音だけが響いている。',
    ),

    'spot_012': const SpotModel(
      id: 'spot_012',

      lat: 35.6755,
      lng: 139.7602,

      name: '廃映画館',

      category: '史跡',

      aiStoryName: '終幕の劇場',

      aiFlavorText: '色褪せたポスターが、過去の幻を映している。',
    ),

    'spot_013': const SpotModel(
      id: 'spot_013',

      lat: 35.6742,
      lng: 139.7590,

      name: '橋の展望台',

      category: '風景',

      aiStoryName: '夜境の観測地点',

      aiFlavorText: '霧の向こうで、街の灯りが揺れている。',
    ),
  };
});
