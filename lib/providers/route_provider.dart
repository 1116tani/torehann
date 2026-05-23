// lib/providers/route_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';
import 'adventure_provider.dart';

// ── State (状態) ──────────────────────────────
class RouteSelectState {
  final List<RouteModel> routes;
  final String? selectedRouteId;
  final bool isLoading;

  const RouteSelectState({
    this.routes = const [],
    this.selectedRouteId,
    this.isLoading = false,
  });

  RouteSelectState copyWith({
    List<RouteModel>? routes,
    String? selectedRouteId,
    bool? isLoading,
  }) {
    return RouteSelectState(
      routes: routes ?? this.routes,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ── Notifier ──────────────────────────────────
class RouteSelectNotifier extends Notifier<RouteSelectState> {
  @override
  RouteSelectState build() => const RouteSelectState();

  void selectRoute(String routeId) {
    state = state.copyWith(selectedRouteId: routeId);
  }

  Future<void> generateRoutes() async {
    state = state.copyWith(isLoading: true);

    // 設定を取得
    final settings = ref.read(adventureSettingProvider);
    // 全スポットの辞書を取得
    final allSpots = ref.read(dummySpotsProvider);

    await Future.delayed(const Duration(seconds: 2));

    // 💡 冒険設定に基づいて、適切なスポットを抽出してルートを作る！
    // ここでは単純なロジックだけど、みぃくんの好きなようにカスタマイズしてね
    final dummyRoutes = [
      RouteModel(
        id: 'route_001',
        themeName: '${settings.mood}・${settings.mode}コース',
        themeDescription: '今の気分「${settings.mood}」にぴったりな、${settings.mode}の旅路。',
        spotIds: ['spot_001', 'spot_002', 'spot_003'],
        // 💡 実際にスポットデータを含めるように修正！
        generatedSpots: ['spot_001', 'spot_002', 'spot_003']
            .map((id) => allSpots[id]!)
            .toList(),
        totalDistance: 2.3,
        estimatedTime: 35,
        tags: ['#${settings.mode}', '#おすすめ', '#冒険'],
      ),
      RouteModel(
        id: 'route_002',
        themeName: 'ノスタルジー・レトロ探索',
        themeDescription: '古き良き記憶を辿る、静かな路地裏の冒険。',
        spotIds: ['spot_006', 'spot_007', 'spot_008'],
        generatedSpots: ['spot_006', 'spot_007', 'spot_008']
            .map((id) => allSpots[id]!)
            .toList(),
        totalDistance: 1.5,
        estimatedTime: 20,
        tags: ['#レトロ', '#穴場', '#発見'],
      ),
    ];

    state = state.copyWith(
      routes: dummyRoutes,
      selectedRouteId: dummyRoutes.first.id,
      isLoading: false,
    );
  }
}

final routeSelectProvider = NotifierProvider<RouteSelectNotifier, RouteSelectState>(
  RouteSelectNotifier.new,
);

// ── スポットのダミーデータ ────────────────────
final dummySpotsProvider = Provider<Map<String, SpotModel>>((ref) {
  return {
    'spot_001': const SpotModel(id: 'spot_001', lat: 35.6812, lng: 139.7671, name: '老舗パン屋', category: 'カフェ', aiStoryName: '記憶の香りを持つ小屋', aiFlavorText: '創業50年の香りが路地裏に漂う'),
    'spot_002': const SpotModel(id: 'spot_002', lat: 35.6820, lng: 139.7680, name: '隠れ家カフェ', category: 'カフェ', aiStoryName: '時が止まった喫茶室', aiFlavorText: 'ドアを開けると別の時代に迷い込む'),
    'spot_003': const SpotModel(id: 'spot_003', lat: 35.6835, lng: 139.7665, name: '小さな公園', category: '公園', aiStoryName: '都会の隙間の楽園', aiFlavorText: 'ベンチに座ると街の声が聞こえてくる'),
    'spot_006': const SpotModel(id: 'spot_006', lat: 35.6800, lng: 139.7650, name: '下町の駄菓子屋', category: '商店街', aiStoryName: '色あせない宝箱', aiFlavorText: 'かつての子供たちが夢見たお菓子が並ぶ'),
    'spot_007': const SpotModel(id: 'spot_007', lat: 35.6790, lng: 139.7640, name: 'レトロな時計店', category: '商店街', aiStoryName: '時を刻む工房', aiFlavorText: 'カチカチという音が街の鼓動のように響く'),
    'spot_008': const SpotModel(id: 'spot_008', lat: 35.6780, lng: 139.7630, name: '夕日の見える丘', category: '風景', aiStoryName: '黄昏の観測所', aiFlavorText: 'ここから見る空は、いつもよりも広く温かい'),
  };
});