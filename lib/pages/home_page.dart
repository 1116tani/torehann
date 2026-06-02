// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_sizes.dart';

import '../providers/location_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/home/home_widgets.dart';
import '../widgets/common/torenyan.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  String? _mapStyle;

  static const LatLng _defaultPosition = LatLng(35.681236, 139.767125);

  bool _isFirstLocationFetch = true;

  double _sheetPosition = 0.22;

  MapType _currentMapType = MapType.normal;

  CameraPosition _currentCameraPosition = const CameraPosition(
    target: _defaultPosition,
    zoom: 16,
    tilt: 45,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeMode = ref.read(settingsProvider).themeMode;
      _loadMapStyle(themeMode);
    });
  }

  Future<void> _loadMapStyle(String themeMode) async {
    if (themeMode == 'daylight') {
      if (mounted) {
        setState(() {
          _mapStyle = null;
        });
      }
      return;
    }
    try {
      final style = await rootBundle.loadString('assets/map_styles/dark_fantasy_map.json');
      if (mounted) {
        setState(() {
          _mapStyle = style;
        });
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();

    super.dispose();
  }

  // ─────────────────────────────
  // 📍 Move To Current Location
  // ─────────────────────────────

  Future<void> _moveToCurrentLocation() async {
    final locationAsync = ref.read(locationProvider);

    locationAsync.whenData((pos) {
      final target = LatLng(pos.latitude, pos.longitude);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 17, tilt: 45),
        ),
      );
    });
  }

  // ─────────────────────────────
  // 🗺 Map Style Sheet
  // ─────────────────────────────

  void _showMapStyleSheet() {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),

          decoration: BoxDecoration(
            color: colors.surface,

            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),

            border: Border.all(color: colors.border, width: 1.5),
          ),

          child: SafeArea(
            top: false,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 50,
                  height: 5,

                  decoration: BoxDecoration(
                    color: colors.textMuted.withValues(alpha: 0.4),

                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                const SizedBox(height: 20),

                // 🧭 ヘッダーを追加してリッチに見やすく
                Text(
                  '🧭 地図スタイル切り替え',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 24),

                _MapStyleTile(
                  title: '通常地図',

                  icon: Icons.map_rounded,

                  selected: _currentMapType == MapType.normal,

                  onTap: () {
                    setState(() {
                      _currentMapType = MapType.normal;
                    });

                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: AppSizes.p12),

                _MapStyleTile(
                  title: '航空写真',

                  icon: Icons.satellite_alt_rounded,

                  selected: _currentMapType == MapType.satellite,

                  onTap: () {
                    setState(() {
                      _currentMapType = MapType.satellite;
                    });

                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: AppSizes.p12),

                _MapStyleTile(
                  title: '地形表示',

                  icon: Icons.terrain_rounded,

                  selected: _currentMapType == MapType.terrain,

                  onTap: () {
                    setState(() {
                      _currentMapType = MapType.terrain;
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationProvider);
    final themeModeSetting = ref.watch(settingsProvider.select((s) => s.themeMode));
    final isDark = themeModeSetting != 'daylight';
    final colors = AppColors.of(context);
    final mapStyleSetting = ref.watch(settingsProvider.select((s) => s.mapStyle));

    ref.listen<String>(settingsProvider.select((s) => s.themeMode), (prev, next) {
      if (prev != next) {
        _loadMapStyle(next);
      }
    });

    // ─────────────────────────────
    // 📍 初回位置取得
    // ─────────────────────────────

    locationAsync.whenData((pos) {
      if (_isFirstLocationFetch && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 16),
        );

        _isFirstLocationFetch = false;
      }
    });

    // ─────────────────────────────
    // 🎭 Dynamic UI
    // ─────────────────────────────

    final screenHeight = MediaQuery.of(context).size.height;

    final dynamicBottom = screenHeight * _sheetPosition + 28;

    final elementOpacity = _sheetPosition > 0.42 ? 0.0 : 1.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,

      child: Scaffold(
        backgroundColor: colors.background,

        body: Stack(
          children: [
            // ─────────────────────
            // 🗺 Google Map
            // ─────────────────────
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _defaultPosition,

                zoom: 16,

                tilt: 45,
              ),

              mapType: _currentMapType,

              myLocationEnabled: true,

              myLocationButtonEnabled: false,

              zoomControlsEnabled: false,

              mapToolbarEnabled: false,

              compassEnabled: false,

              buildingsEnabled: true,

              style: (mapStyleSetting == 'game' && isDark) ? _mapStyle : null,

              onMapCreated: (controller) {
                _mapController = controller;
              },

              onCameraMove: (position) {
                _currentCameraPosition = position;
              },
            ),

            // ─────────────────────
            // ✨ Overlay
            // ─────────────────────
            const MapOverlay(),

            // ─────────────────────
            // 🏷 Header
            // ─────────────────────
            const Positioned(
              top: 58,
              left: AppSizes.p20,
              right: AppSizes.p20,

              child: HomeGlassHeader(),
            ),

            // ─────────────────────
            // 🗺 Controls
            // ─────────────────────
            AnimatedPositioned(
              duration: AppDurations.fast,

              curve: Curves.easeOut,

              right: AppSizes.p20,

              bottom: dynamicBottom,

              child: AnimatedOpacity(
                duration: AppDurations.normal,

                opacity: elementOpacity,

                child: HomeMapControls(
                  onLocationPressed: _moveToCurrentLocation,

                  onLayersPressed: _showMapStyleSheet,

                  onCompassPressed: () {
                    _mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _currentCameraPosition.target,
                          zoom: _currentCameraPosition.zoom,
                          tilt: 0,
                          bearing: 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ─────────────────────
            // 📜 Bottom Sheet
            // ─────────────────────
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                setState(() {
                  _sheetPosition = notification.extent;
                });

                return true;
              },

              child: const HomeDraggableMenu(),
            ),

            // 🐱 ボトムシートの上に乗るトレにゃん
            Positioned(
              top: screenHeight * (1 - _sheetPosition) - 220,
              left: 15,
              child: const Torenyan(
                size: 210,
                state: TorenyanState.idle,
                enableTap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────
// 🗺 Map Style Tile
// ─────────────────────────────────

class _MapStyleTile extends StatelessWidget {
  final String title;

  final IconData icon;

  final bool selected;

  final VoidCallback onTap;

  const _MapStyleTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,

            vertical: 18.0,
          ),

          decoration: BoxDecoration(
            color: selected
                ? colors.primary.withValues(alpha: 0.16)
                : colors.surfaceLight,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 2.0 : 1.0,
            ),
          ),

          child: Row(
            children: [
              Icon(
                icon,
                size: 28.0, // アイコンを大きく表示

                color: selected ? colors.primary : colors.textSecondary,
              ),

              const SizedBox(width: 16.0),

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16.0, // フォントサイズを大きく表示
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (selected)
                Icon(
                  Icons.check_rounded,
                  color: colors.primary,
                  size: 24.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

