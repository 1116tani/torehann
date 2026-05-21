// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 💡 プロバイダーを使うために追加！

import 'package:tale_trace/router/app_router.dart';
import 'package:tale_trace/widgets/common/glass_card.dart';
import 'package:tale_trace/widgets/home/map_overlay.dart';
import 'package:tale_trace/widgets/home/partner_character.dart';
import 'package:tale_trace/widgets/home/adventure_start_button.dart';
import 'package:tale_trace/utils/colors.dart'; // 💡 色を統一するために追加
import 'package:tale_trace/providers/location_provider.dart'; // 💡 現在地のために追加

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

// 💡 Riverpodを使うために ConsumerStatefulWidget に変更したよ！
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? mapController;
  final LatLng _defaultPosition = const LatLng(35.681236, 139.767125); // 東京駅
  bool _isFirstLocationFetch = true; // 初回のみカメラを移動させるフラグ

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 💡 現在地を監視するよ！
    final locationAsyncValue = ref.watch(locationProvider);

    // 現在地が取得できたら、初回だけカメラをそこに飛ばす魔法
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
            style: vintageMapStyle, // 💡 ここに古地図スタイルを適用！！
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // 自前のボタンを使うから標準は消すよ
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

          // ④ 案内妖精：アイリス
          const Positioned(left: 20, bottom: 180, child: PartnerCharacter()),

          // ⑤ マップ操作ボタン
          Positioned(
            right: 20,
            bottom: 180,
            child: _buildMapControls(theme, locationAsyncValue),
          ),

          // ⑥ メニュー兼、冒険出発ボトムシート
          _buildDraggableMenu(theme),
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
                        color: AppColors.textPrimary, // 💡 羊皮紙ホワイトに変更
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

  // 💡 現在地情報を受け取ってボタンの動作を変えるよ
  Widget _buildMapControls(ThemeData theme, AsyncValue<dynamic> locationData) {
    final controller = mapController;

    return Column(
      children: [
        _miniMapBtn(
          Icons.add,
          controller == null
              ? null
              : () => controller.animateCamera(CameraUpdate.zoomIn()),
        ),
        const SizedBox(height: 12),
        _miniMapBtn(
          Icons.remove,
          controller == null
              ? null
              : () => controller.animateCamera(CameraUpdate.zoomOut()),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          onPressed: controller == null
              ? null
              : () {
                  // 💡 ボタンを押したら確実に現在地（または豊田市）に戻るよ！
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
            color: AppColors.background,
          ), // 💡 アイコン色をセピアに
        ),
      ],
    );
  }

  Widget _miniMapBtn(IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      width: 40,
      height: 40,
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: AppColors.surface, // 💡 セピアブラウンに
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
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
            color: AppColors.surface.withValues(
              alpha: 0.9,
            ), // 💡 メニュー背景もセピアブラウン
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
                  _menuItem(
                    theme,
                    Icons.emoji_events,
                    "実績",
                    AppRoutes.achievement,
                  ),
                  _menuItem(
                    theme,
                    Icons.auto_stories,
                    "街の断片",
                    AppRoutes.collection,
                  ),
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
                  _menuItem(
                    theme,
                    Icons.favorite,
                    "健康管理",
                    null,
                    isLocked: true,
                  ),
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
                color: isLocked
                    ? AppColors.textMuted
                    : theme.colorScheme.primary,
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
