// lib/pages/navigation_page.dart

import 'package:flutter/foundation.dart'; // 💡 kDebugMode用
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/app_sizes.dart';
import '../models/spot_model.dart';

import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/route_provider.dart';

import '../router/route_names.dart';

import '../widgets/navigation/camera_button.dart';
import '../widgets/navigation/destination_marker.dart';
import '../widgets/navigation/fog_effect_overlay.dart';

import '../widgets/navigation/navigation_map_layer.dart';
import '../widgets/navigation/route_progress_bar.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  final bool _useGoogleMap = true; // 💡 最初からマップ（Google Maps）を開いた状態に変更
  GoogleMapController? _mapController;
  ProviderSubscription<AsyncValue<Position>>? _locationSubscription;

  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();

    _loadMapStyle();
    _locationSubscription = ref.listenManual(locationProvider, (
      previous,
      next,
    ) {
      final position = next.value;

      if (position == null) return;

      ref.read(navigationProvider.notifier).updateLocation(position);

      if (_useGoogleMap && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    });
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString(
        'assets/map_styles/dark_fantasy_map.json',
      );

      if (!mounted) return;

      setState(() {
        _darkMapStyle = style;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _locationSubscription?.close();
    _mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);

    final navNotifier = ref.read(navigationProvider.notifier);

    final locationAsync = ref.watch(locationProvider);

    final currentPosition = locationAsync.value;

    // ─────────────────────────────
    // 🚫 冒険未開始
    // ─────────────────────────────

    if (!navState.isAdventureStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C2318),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.go(AppRoutes.home);
            },
            child: const Text('ホームへ戻る'),
          ),
        ),
      );
    }

    // ─────────────────────────────
    // 📍 スポット一覧
    // ─────────────────────────────

    final spotsMap = ref.watch(dummySpotsProvider);

    final routeSpots =
        navState.currentRoute?.spotIds
            .map((id) => spotsMap[id])
            .whereType<SpotModel>()
            .toList() ??
        [];

    final isCompleted = navState.nextSpot == null;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318), // ダークセピア
      body: Stack(
        children: [
          // ─────────────────────────────
          // 🗺️ マップ
          // ─────────────────────────────
          NavigationMapLayer(
            useGoogleMap: _useGoogleMap,

            mapController: _mapController,

            darkMapStyle: _darkMapStyle,

            currentPosition: currentPosition,

            spots: routeSpots,

            visitedSpotIds: navState.visitedSpotIds,

            nextSpot: navState.nextSpot,

            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          // 2️⃣ 謎の霧エフェクト（雰囲気を醸し出す）
          const FogEffectOverlay(density: 0.5),

          // 3️⃣ 上部ヘッダー（半透明グラデーションを効かせたAppBar ＋ 進行度プログレスバー）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2C2318).withValues(alpha: 0.95),
                    const Color(0xFF2C2318).withValues(alpha: 0.80),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // カスタム AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFFF5EDD8)),
                            onPressed: () {
                              navNotifier.finishAdventure();
                              context.go(AppRoutes.home);
                            },
                          ),
                          Expanded(
                            child: Text(
                              navState.currentRoute?.themeName ?? '未知の探索路',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFF5EDD8),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          // タイトルを中央に配置するためのダミー枠
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    // 進行度プログレスバー
                    RouteProgressBar(
                      progress: navState.progress,
                      visitedCount: navState.visitedSpotIds.length,
                      totalCount: routeSpots.length,
                      distanceToNext: navState.distanceToNextSpot,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4️⃣ 中間〜下部フローティング操作ボタン群
          // 📸 カメラ起動ボタン (未クリア時のみ、右下に浮かせる)
          if (!isCompleted)
            Positioned(
              right: 16,
              bottom: 146, // 目的地カードの上側
              child: CameraButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📷 パシャリ！街の断片を写真に収めた！'),
                      backgroundColor: Color(0xFF3D2B1F),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),

          // 現在地追従ボタン (右側、カメラボタンの上側)
          if (currentPosition != null)
            Positioned(
              right: 28, // カメラボタンの中心軸と合わせるための微調整
              bottom: isCompleted ? 100 : 252,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF3D2B1F).withValues(alpha: 0.85),
                foregroundColor: const Color(0xFFC8A97A),

                onPressed: () {
                  if (_useGoogleMap && _mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(
                          currentPosition.latitude,
                          currentPosition.longitude,
                        ),
                        16,
                      ),
                    );
                  }
                },

                child: const Icon(Icons.my_location),
              ),
            ),

          // 🧪 ハッカソン用：デバッグ到着判定ボタン (左下、カードの上側)
          if (kDebugMode && !isCompleted)
            Positioned(
              left: 16,
              bottom: 146,
              child: ActionChip(
                backgroundColor: const Color(0xFFCC3333).withValues(alpha: 0.85),
                side: const BorderSide(color: Color(0xFFC8A97A), width: 1),
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '到着判定',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  ref.read(navigationProvider.notifier).forceCheckInNextSpot();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚡ デバッグ：次のスポットへ強制移動しました！'),
                      backgroundColor: Color(0xFFCC3333),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),

          // 5️⃣ 最下部：次の目的地カード または 冒険報告ボタン
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: isCompleted
                ? SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A97A),
                        foregroundColor: const Color(0xFF2C2318),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        '冒険の記録を報告する',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : (navState.nextSpot != null
                    ? DestinationMarker(
                        spot: navState.nextSpot!,
                        distanceToSpot: navState.distanceToNextSpot,
                        isNearby: (navState.distanceToNextSpot ?? 999.0) < 20.0,
                      )
                    : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
