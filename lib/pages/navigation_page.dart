// lib/pages/navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/spot_model.dart';

import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/route_provider.dart';

import '../router/route_names.dart';

import '../widgets/navigation/camera_button.dart';
import '../widgets/navigation/compass_widget.dart';
import '../widgets/navigation/destination_marker.dart';
import '../widgets/navigation/fog_effect_overlay.dart';

import '../widgets/navigation/navigation_bottom_button.dart';
import '../widgets/navigation/navigation_complete_card.dart';
import '../widgets/navigation/navigation_map_layer.dart';
import '../widgets/navigation/navigation_top_bar.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  bool _useGoogleMap = false;

  GoogleMapController? _mapController;

  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();

    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString(
        'assets/map_styles/dark_fantasy_map.json',
      );

      setState(() {
        _darkMapStyle = style;
      });
    } catch (_) {}
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

    // ─────────────────────────────
    // 🛰️ GPS更新監視
    // ─────────────────────────────

    ref.listen(locationProvider, (previous, next) {
      final position = next.value;

      if (position != null) {
        ref.read(navigationProvider.notifier).updateLocation(position);

        if (_useGoogleMap && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      }
    });

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
      backgroundColor: const Color(0xFF2C2318),

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

            routeSpots: routeSpots,

            visitedSpotIds: navState.visitedSpotIds,

            nextSpot: navState.nextSpot,

            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          // ─────────────────────────────
          // 🌫️ 霧
          // ─────────────────────────────
          const FogEffectOverlay(),

          // ─────────────────────────────
          // 🧭 UI
          // ─────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ───── 上部バー ─────
                NavigationTopBar(
                  title: navState.currentRoute?.themeName ?? '未知の探索路',

                  useGoogleMap: _useGoogleMap,

                  onClose: () {
                    navNotifier.finishAdventure();

                    context.go(AppRoutes.home);
                  },

                  onToggleMap: () {
                    setState(() {
                      _useGoogleMap = !_useGoogleMap;
                    });
                  },
                ),

                const SizedBox(height: 12),

                // ───── コンパス ─────
                CompassWidget(
                  currentPosition: currentPosition,

                  targetSpot: navState.nextSpot,
                ),

                const Spacer(),

                // ───── 到達カード ─────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: isCompleted
                      ? const NavigationCompleteCard()
                      : DestinationMarker(
                          spot: navState.nextSpot!,

                          distanceToSpot: navState.distanceToNextSpot,

                          isNearby: (navState.distanceToNextSpot ?? 999) < 20,
                        ),
                ),

                const SizedBox(height: 20),

                // ───── 完了ボタン ─────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NavigationBottomButton(
                    isCompleted: isCompleted,

                    onPressed: () {
                      context.go(AppRoutes.result);
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // ─────────────────────────────
          // 📸 カメラボタン
          // ─────────────────────────────
          if (!isCompleted)
            Positioned(
              right: 20,
              bottom: 110,
              child: CameraButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('📷 街の断片を記録した')));
                },
              ),
            ),

          // ─────────────────────────────
          // 📍 現在地ボタン
          // ─────────────────────────────
          if (currentPosition != null)
            Positioned(
              right: 20,
              top: 110,
              child: FloatingActionButton(
                mini: true,

                backgroundColor: const Color(0xFF3D2B1F),

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
        ],
      ),
    );
  }
}
