// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

// ここを「tale_trace」に修正したよ！
import 'package:tale_trace/router/app_router.dart';
import 'package:tale_trace/widgets/common/glass_card.dart';
import 'package:tale_trace/widgets/home/map_overlay.dart';
import 'package:tale_trace/widgets/home/partner_character.dart';
import 'package:tale_trace/widgets/home/adventure_start_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = const LatLng(35.681236, 139.767125); // 東京駅

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ① GoogleMap（最背面）
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 16,
              tilt: 45,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),

          // ② サイバーグリッド・オーバーレイ
          const MapOverlay(),

          // ③ 上部ヘッダー（ステータス画面）
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: _buildGlassHeader(theme),
          ),

          // ④ 相棒キャラ：アイリス
          const Positioned(left: 20, bottom: 180, child: PartnerCharacter()),

          // ⑤ マップ操作ボタン
          Positioned(right: 20, bottom: 180, child: _buildMapControls(theme)),

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
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
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
                        color: Colors.white,
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
                    backgroundColor: Colors.white.withOpacity(0.1),
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

  Widget _buildMapControls(ThemeData theme) {
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
              : () => controller.animateCamera(
                    CameraUpdate.newLatLng(_initialPosition),
                  ),
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.my_location, color: Colors.black),
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
        backgroundColor: Colors.black87,
        child: Icon(icon, color: Colors.white, size: 20),
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
            color: Colors.black.withOpacity(0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                    color: Colors.white24,
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
                  color: Colors.white70,
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
                style: TextStyle(color: Colors.white24, fontSize: 12),
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
                    ? Colors.white10
                    : theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked
                      ? Colors.transparent
                      : theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isLocked ? Colors.white24 : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
