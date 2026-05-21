// lib/providers/route_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';

// ── ルート選択画面の状態 ──────────────────────
class RouteSelectState {
  final List<RouteModel> routes; // AIが提案したルート一覧
  final String? selectedRouteId; // 選択中のルートID
  final bool isLoading; // 生成中フラグ

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

  // ルートを選択する
  void selectRoute(String routeId) {
    state = state.copyWith(selectedRouteId: routeId);
  }

  // ダミーデータを生成（Gemini API連携まで）
  Future<void> generateRoutes() async {
    state = state.copyWith(isLoading: true);

    // Gemini APIの代わりに少し待ってからダミーデータを返す
    await Future.delayed(const Duration(seconds: 2));

    final dummyRoutes = [
      RouteModel(
        id: 'route_001',
        themeName: '古のパン屋を巡る調査員コース',
        themeDescription: '路地裏に隠れた名店を追う、美食探偵の一日',
        spotIds: ['spot_001', 'spot_002', 'spot_003'],
        totalDistance: 2.3,
        estimatedTime: 35,
        tags: ['#カフェ', '#レトロ', '#路地裏'],
      ),
      RouteModel(
        id: 'route_002',
        themeName: '緑の隠れ家を求めて',
        themeDescription: '都会の中に息づく自然を発見する旅人のルート',
        spotIds: ['spot_004', 'spot_005'],
        totalDistance: 1.8,
        estimatedTime: 25,
        tags: ['#公園', '#自然', '#のんびり'],
      ),
      RouteModel(
        id: 'route_003',
        themeName: '夕暮れの商店街冒険記',
        themeDescription: '昭和の香り漂う街並みで、時間旅行者になれるルート',
        spotIds: ['spot_006', 'spot_007', 'spot_008'],
        totalDistance: 3.1,
        estimatedTime: 45,
        tags: ['#商店街', '#昭和', '#写真映え'],
      ),
    ];

    state = state.copyWith(
      routes: dummyRoutes,
      selectedRouteId: dummyRoutes.first.id,
      isLoading: false,
    );
  }
}

final routeSelectProvider =
    NotifierProvider<RouteSelectNotifier, RouteSelectState>(
      RouteSelectNotifier.new,
    );

// ── スポットのダミーデータ（地図APIまで） ────
final dummySpotsProvider = Provider<Map<String, SpotModel>>((ref) {
  return {
    'spot_001': const SpotModel(
      id: 'spot_001',
      lat: 35.6812,
      lng: 139.7671,
      name: '老舗パン屋',
      category: 'カフェ',
      aiStoryName: '記憶の香りを持つ小屋',
      aiFlavorText: '創業50年の香りが路地裏に漂う',
    ),
    'spot_002': const SpotModel(
      id: 'spot_002',
      lat: 35.6820,
      lng: 139.7680,
      name: '隠れ家カフェ',
      category: 'カフェ',
      aiStoryName: '時が止まった喫茶室',
      aiFlavorText: 'ドアを開けると別の時代に迷い込む',
    ),
    'spot_003': const SpotModel(
      id: 'spot_003',
      lat: 35.6835,
      lng: 139.7665,
      name: '小さな公園',
      category: '公園',
      aiStoryName: '都会の隙間の楽園',
      aiFlavorText: 'ベンチに座ると街の声が聞こえてくる',
    ),
    'spot_004': const SpotModel(
      id: 'spot_004',
      lat: 35.6850,
      lng: 139.7690,
      name: '噴水広場',
      category: '公園',
      aiStoryName: '水と光のステージ',
      aiFlavorText: 'キラキラと輝く水しぶきが、遠い記憶を呼び覚ます。',
    ),
    'spot_005': const SpotModel(
      id: 'spot_005',
      lat: 35.6860,
      lng: 139.7700,
      name: '図書館の小道',
      category: '史跡',
      aiStoryName: '叡智が眠る静寂の径',
      aiFlavorText: '古い書物の香りが風に乗って運ばれてくる。',
    ),
    'spot_006': const SpotModel(
      id: 'spot_006',
      lat: 35.6800,
      lng: 139.7650,
      name: '下町の駄菓子屋',
      category: '商店街',
      aiStoryName: '色あせない宝箱',
      aiFlavorText: 'かつての子供たちが夢見たお菓子が、今も並んでいる。',
    ),
    'spot_007': const SpotModel(
      id: 'spot_007',
      lat: 35.6790,
      lng: 139.7640,
      name: 'レトロな時計店',
      category: '商店街',
      aiStoryName: '時を刻む工房',
      aiFlavorText: 'カチカチという規則正しい音が、街の鼓動のように響く。',
    ),
    'spot_008': const SpotModel(
      id: 'spot_008',
      lat: 35.6780,
      lng: 139.7630,
      name: '夕日の見える丘',
      category: '風景',
      aiStoryName: '黄昏の観測所',
      aiFlavorText: 'ここから見る空は、いつもよりも広く、温かく感じる。',
    ),
  };
});
