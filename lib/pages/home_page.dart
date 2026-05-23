// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tale_trace/router/app_router.dart';
import 'package:tale_trace/widgets/common/glass_card.dart';
import 'package:tale_trace/widgets/home/map_overlay.dart';
import 'package:tale_trace/widgets/home/partner_character.dart';
import 'package:tale_trace/widgets/home/adventure_start_button.dart';
import 'package:tale_trace/utils/colors.dart';
import 'package:tale_trace/providers/location_provider.dart';

// 📜 Google Mapsの古地図・セピア風スタイルJSON
const String vintageMapStyle = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#ebe3cd"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#523735"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#f5f1e6"}]},
  {"featureType": "administrative", "elementType": "geometry.stroke", "stylers": [{"color": "#c9b2a6"}]},
  {"featureType": "administrative.land_parcel", "elementType": "geometry.stroke", "stylers": [{"color": "#dcd2be"}]},
  {"featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [{"color": "#ae9e90"}]},
  {"featureType": "landscape.natural", "elementType": "geometry", "stylers": [{"color": "#dfd2ae"}]},
  {"featureType": "poi", "elementType": "geometry", "stylers": [{"color": "#dfd2ae"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#93817c"}]},
  {"featureType": "poi.park", "elementType": "geometry.fill", "stylers": [{"color": "#a5b076"}]},
  {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#447530"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#f5f1e6"}]},
  {"featureType": "road.arterial", "elementType": "geometry", "stylers": [{"color": "#fdfcf8"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#f8c967"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#e9bc62"}]},
  {"featureType": "road.highway.controlled_access", "elementType": "geometry", "stylers": [{"color": "#e98d58"}]},
  {"featureType": "road.highway.controlled_access", "elementType": "geometry.stroke", "stylers": [{"color": "#db8555"}]},
  {"featureType": "road.local", "elementType": "labels.text.fill", "stylers": [{"color": "#806b63"}]},
  {"featureType": "transit.line", "elementType": "geometry", "stylers": [{"color": "#dfd2ae"}]},
  {"featureType": "transit.line", "elementType": "labels.text.fill", "stylers": [{"color": "#8f7d77"}]},
  {"featureType": "transit.line", "elementType": "labels.text.stroke", "stylers": [{"color": "#ebe3cd"}]},
  {"featureType": "transit.station", "elementType": "geometry", "stylers": [{"color": "#dfd2ae"}]},
  {"featureType": "water", "elementType": "geometry.fill", "stylers": [{"color": "#b9d3c2"}]},
  {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#92998d"}]}
]
''';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? mapController;
  final LatLng _defaultPosition = const LatLng(35.681236, 139.767125); // デフォルト位置
  bool _isFirstLocationFetch = true;
  double _sheetPosition = 0.22; // 💡 ボトムシートの初期位置を記憶するよ！

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationAsyncValue = ref.watch(locationProvider);

    locationAsyncValue.whenData((position) {
      if (position != null && _isFirstLocationFetch && mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16.0,
          ),
        );
        _isFirstLocationFetch = false;
      }
    });

    // 💡 画面の高さと、動くパーツたちの位置・透明度を計算するよ
    final screenHeight = MediaQuery.of(context).size.height;
    final dynamicBottom = screenHeight * _sheetPosition + 20;
    // シートが画面の40%（0.4）以上引き上げられたらフッと透明にする！
    final double elementOpacity = _sheetPosition > 0.4 ? 0.0 : 1.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ① GoogleMap（最背面）
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultPosition,
              zoom: 16,
              tilt: 45,
            ),
            style: vintageMapStyle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),

          // ② 羅針盤・羊皮紙オーバーレイ
          const MapOverlay(),

          // ③ 上部ヘッダー（ステータス画面）
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: _buildGlassHeader(theme),
          ),

          // ④ 案内妖精：アイリス（💡 シートと一緒に動く＆消える魔法！）
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50), // スルスル動くよ
            left: 20,
            bottom: dynamicBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200), // ふわっと消えるよ
              opacity: elementOpacity,
              child: const PartnerCharacter(),
            ),
          ),

          // ⑤ マップ操作ボタン（💡 これも一緒に動く＆消える魔法！）
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            right: 20,
            bottom: dynamicBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: elementOpacity,
              child: _buildMapControls(theme, locationAsyncValue),
            ),
          ),

          // ⑥ メニュー兼、冒険出発ボトムシート（💡 シートの動きを監視するよ！）
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent; // リアルタイムに高さを更新！
              });
              return true;
            },
            child: _buildDraggableMenu(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader(ThemeData theme) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            child: Icon(Icons.person, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "見習い冒険者",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Lv. 5",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 6,
                    backgroundColor: AppColors.textMuted.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls(ThemeData theme, AsyncValue<dynamic> locationData) {
    final controller = mapController;

    return Column(
      children: [
        // 💡 新機能：マップの見た目切り替えボタン（Apple Map風！）
        FloatingActionButton(
          heroTag: "layer_btn",
          mini: true,
          onPressed: () {
            // TODO: ここに航空写真とかの切り替え処理を後で作るよ！
          },
          backgroundColor: AppColors.surface, // セピアブラウン
          child: const Icon(Icons.layers, color: AppColors.textPrimary, size: 20),
        ),
        const SizedBox(height: 12),

        // 💡 既存の現在地ボタン
        FloatingActionButton(
          heroTag: "location_btn",
          onPressed: controller == null
              ? null
              : () {
                  locationData.whenData((pos) {
                    final target = pos != null
                        ? LatLng(pos.latitude, pos.longitude)
                        : _defaultPosition;
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(target, 16.0),
                    );
                  });
                },
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(
            Icons.my_location,
            color: AppColors.background, // セピアに映える色に！
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableMenu(ThemeData theme) {
    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9), // メニュー背景
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const AdventureStartButton(),

              const SizedBox(height: 30),
              const Text(
                "冒険のログ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _menuItem(theme, Icons.emoji_events, "実績", AppRoutes.achievement),
                  _menuItem(theme, Icons.auto_stories, "街の断片", AppRoutes.collection),
                  _menuItem(theme, Icons.history, "履歴", AppRoutes.history),
                  _menuItem(theme, Icons.settings, "設定", AppRoutes.settings),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "ギルド拡張（準備中）",
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _menuItem(theme, Icons.people, "フレンド", null, isLocked: true),
                  _menuItem(theme, Icons.favorite, "健康管理", null, isLocked: true),
                  _menuItem(theme, Icons.flag, "ミッション", null, isLocked: true),
                  _menuItem(theme, Icons.group, "パーティ", null, isLocked: true),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(
    ThemeData theme,
    IconData icon,
    String label,
    String? route, {
    bool isLocked = false,
  }) {
    return InkWell(
      onTap: isLocked || route == null ? null : () => context.push(route),
      child: Opacity(
        opacity: isLocked ? 0.3 : 1.0,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.border.withValues(alpha: 0.5)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked
                      ? Colors.transparent
                      : theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isLocked ? AppColors.textMuted : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}