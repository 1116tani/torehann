// lib/pages/navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/app_sizes.dart';
import '../models/spot_model.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/route_provider.dart'; // 💡 dummySpotsProvider 用
import '../router/route_names.dart';
import '../widgets/navigation/camera_button.dart';
import '../widgets/navigation/compass_widget.dart';
import '../widgets/navigation/destination_marker.dart';
import '../widgets/navigation/fog_effect_overlay.dart';
import '../widgets/navigation/retro_mock_map.dart';
import '../widgets/navigation/route_progress_bar.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  bool _useGoogleMap = false; // 💡 デフォルトはGoogle Mapsを使わない模擬マップモード
  GoogleMapController? _mapController;
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/map_styles/dark_fantasy_map.json');
      setState(() {
        _darkMapStyle = style;
      });
    } catch (e) {
      // ファイル未作成、または読み込み失敗時はデフォルトスタイル
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);
    final locationAsync = ref.watch(locationProvider);
    final currentPosition = locationAsync.value;

    // 🛰️ GPSが動くたびに、ナビ状態の距離計算を自動で走らせる＆マップを自動スクロール！
    ref.listen(locationProvider, (previous, next) {
      final position = next.value;
      if (position != null) {
        ref.read(navigationProvider.notifier).updateLocation(position);

        // Google Maps表示時のみ、カメラを現在地に自動移動させる
        if (_useGoogleMap && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      }
    });

    // ── 冒険が始まっていない時のセーフガード ──
    if (!navState.isAdventureStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C2318),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '謎の霧に包まれている...\n（冒険が開始されていません）',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 16),
              ),
              const SizedBox(height: AppSizes.p24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8A97A),
                  foregroundColor: const Color(0xFF2C2318),
                ),
                child: const Text('拠点（ホーム）に戻る'),
              ),
            ],
          ),
        ),
      );
    }

    // スポット一覧の取得
    final spotsMap = ref.watch(dummySpotsProvider);
    final routeSpots = navState.currentRoute?.spotIds
            .map((id) => spotsMap[id])
            .whereType<SpotModel>()
            .toList() ??
        [];

    final isCompleted = navState.nextSpot == null;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318), // ダークセピア
      appBar: AppBar(
        title: Text(
          navState.currentRoute?.themeName ?? '未知の探索路',
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF3D2B1F),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFF5EDD8)),
          onPressed: () {
            navNotifier.finishAdventure();
            context.go(AppRoutes.home);
          },
        ),
        actions: [
          // 🗺️ 地図切替ボタン（Google Maps ⇆ 古地図）
          IconButton(
            icon: Icon(
              _useGoogleMap ? Icons.map_outlined : Icons.explore_outlined,
              color: const Color(0xFFC8A97A),
            ),
            tooltip: _useGoogleMap ? '手書き古地図を表示' : 'Google Mapを表示',
            onPressed: () {
              setState(() {
                _useGoogleMap = !_useGoogleMap;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1️⃣ マップレイヤー（Google Map または 模擬マップ）
          Positioned.fill(
            child: _useGoogleMap
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentPosition != null
                          ? LatLng(currentPosition.latitude, currentPosition.longitude)
                          : (routeSpots.isNotEmpty
                              ? LatLng(routeSpots.first.lat, routeSpots.first.lng)
                              : const LatLng(35.6812, 139.7671)),
                      zoom: 16,
                      tilt: 45,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    style: _darkMapStyle,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route_path'),
                        points: routeSpots.map((s) => LatLng(s.lat, s.lng)).toList(),
                        color: const Color(0xFFC8A97A),
                        width: 4,
                      ),
                    },
                    markers: routeSpots.map((s) {
                      final isVisited = navState.visitedSpotIds.contains(s.id);
                      final isNext = navState.nextSpot?.id == s.id;
                      return Marker(
                        markerId: MarkerId(s.id),
                        position: LatLng(s.lat, s.lng),
                        infoWindow: InfoWindow(
                          title: s.aiStoryName.isNotEmpty ? s.aiStoryName : s.name,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          isVisited
                              ? BitmapDescriptor.hueYellow
                              : (isNext ? BitmapDescriptor.hueRed : BitmapDescriptor.hueViolet),
                        ),
                      );
                    }).toSet(),
                  )
                : RetroMockMap(
                    currentPosition: currentPosition,
                    spots: routeSpots,
                    visitedSpotIds: navState.visitedSpotIds,
                    nextSpot: navState.nextSpot,
                  ),
          ),

          // 2️⃣ 謎の霧エフェクト（雰囲気を醸し出す）
          const FogEffectOverlay(density: 0.6),

          // 3️⃣ ナビゲーションUI要素
          Column(
            children: [
              // 進行度プログレスバー
              RouteProgressBar(
                progress: navState.progress,
                visitedCount: navState.visitedSpotIds.length,
                totalCount: routeSpots.length,
                distanceToNext: navState.distanceToNextSpot,
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p24,
                      vertical: AppSizes.p20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSizes.p12),

                        // 🧭 魔導羅針盤コンパス
                        CompassWidget(
                          currentPosition: currentPosition,
                          targetSpot: navState.nextSpot,
                        ),

                        const SizedBox(height: AppSizes.p24),

                        // 📍 ナビゲーションメインカード
                        if (navState.nextSpot != null)
                          DestinationMarker(
                            spot: navState.nextSpot!,
                            distanceToSpot: navState.distanceToNextSpot,
                            isNearby: (navState.distanceToNextSpot ?? 999.0) < 20.0,
                          )
                        else ...[
                          // すべてクリア時の表示
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSizes.p24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D2B1F).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(AppSizes.radiusL),
                              border: Border.all(
                                color: const Color(0xFFC8A97A),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 48,
                                  color: Color(0xFFC8A97A),
                                ),
                                SizedBox(height: AppSizes.p16),
                                Text(
                                  '調査任務コンプリート！',
                                  style: TextStyle(
                                    color: Color(0xFFF5EDD8),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSizes.p12),
                                Text(
                                  'この地のすべての断片（テール）を記録しました。拠点へ戻って成果を確認しましょう！',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF9E8465),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: AppSizes.p20),

                        // 📸 カメラ起動ボタン
                        if (!isCompleted)
                          CameraButton(
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
                      ],
                    ),
                  ),
                ),
              ),

              // 最下部固定：冒険完了ボタン
              Padding(
                padding: const EdgeInsets.all(AppSizes.p24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isCompleted
                        ? () {
                            context.go(AppRoutes.result);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC8A97A),
                      foregroundColor: const Color(0xFF2C2318),
                      disabledBackgroundColor: const Color(0xFF3D2B1F),
                      disabledForegroundColor: const Color(0xFF7A5C3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        side: BorderSide(
                          color: isCompleted ? Colors.transparent : const Color(0xFF4A3728),
                        ),
                      ),
                      elevation: isCompleted ? 4 : 0,
                    ),
                    child: Text(
                      isCompleted ? '冒険の記録を報告する' : 'すべてのスポットを調査してください',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 模擬マップ操作時の現在地ボタン（Google Maps非アクティブ時も動作）
          if (currentPosition != null)
            Positioned(
              right: 16,
              top: 100,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFF3D2B1F),
                foregroundColor: const Color(0xFFC8A97A),
                onPressed: () {
                  if (_useGoogleMap && _mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(currentPosition.latitude, currentPosition.longitude),
                        16.0,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🛰️ GPSシグナル正常受信中...'),
                        backgroundColor: Color(0xFF3D2B1F),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Icon(Icons.my_location, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}
