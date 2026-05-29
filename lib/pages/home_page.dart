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

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
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
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.p20),

          decoration: BoxDecoration(
            color: AppColors.surface,

            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),

            border: Border.all(color: AppColors.border),
          ),

          child: SafeArea(
            top: false,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 48,
                  height: 5,

                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.4),

                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                const SizedBox(height: AppSizes.p20),

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
    final mapStyleSetting = ref.watch(settingsProvider.select((s) => s.mapStyle));

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
      value: SystemUiOverlayStyle.light,

      child: Scaffold(
        backgroundColor: AppColors.background,

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

              style: mapStyleSetting == 'game' ? _mapStyle : null,

              onMapCreated: (controller) {
                _mapController = controller;
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
                        const CameraPosition(
                          target: _defaultPosition,

                          zoom: 16,

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
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,

            vertical: AppSizes.p16,
          ),

          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.14)
                : AppColors.surfaceLight,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),

          child: Row(
            children: [
              Icon(
                icon,

                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),

              const SizedBox(width: AppSizes.p12),

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    color: AppColors.textPrimary,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (selected)
                const Icon(Icons.check_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
