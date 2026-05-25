// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tale_trace/widgets/home/home_widgets.dart';
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
          const Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: HomeGlassHeader(),
          ),

          // ④ 案内妖精：アイリス
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            left: 20,
            bottom: dynamicBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: elementOpacity,
              child: const PartnerCharacter(),
            ),
          ),

          // ⑤ マップ操作ボタン
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            right: 20,
            bottom: dynamicBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: elementOpacity,
              child: HomeMapControls(
                onLocationPressed: mapController == null
                    ? null
                    : () {
                        locationAsyncValue.whenData((pos) {
                          final target = pos != null
                              ? LatLng(pos.latitude, pos.longitude)
                              : _defaultPosition;
                          mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(target, 16.0),
                          );
                        });
                      },
                onLayersPressed: () {
                  // TODO: ここに航空写真とかの切り替え処理を後で作るよ！
                },
              ),
            ),
          ),

          // ⑥ メニュー兼、冒険出発ボトムシート
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
    );
  }
}