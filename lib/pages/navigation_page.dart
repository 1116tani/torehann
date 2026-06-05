// lib/pages/navigation_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

import '../constants/app_colors.dart';
import '../constants/navigation_ui_constants.dart';
import '../models/result_model.dart';
import '../models/spot_model.dart';
import '../models/walking_leg_result.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/result_provider.dart';
import '../providers/settings_provider.dart';
import '../router/route_names.dart';
import '../services/directions_service.dart';
import '../utils/map_style_loader.dart';
import '../utils/polyline_utils.dart';
import '../widgets/common/torenyan.dart';
import '../widgets/navigation/arrival_dialog.dart';
import '../widgets/navigation/navigation_draggable_sheet.dart';
import '../widgets/navigation/navigation_map_controls.dart';
import '../widgets/navigation/next_spot_header.dart';

enum TorenyanNavMode { moving, offRoute, arrived }

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _locationSub;
  StreamSubscription<CompassEvent>? _compassSub;
  Timer? _arrivalTimer;
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  Position? _lastPosition;
  double _compassHeading = 0;
  bool _isFollowingUser = true;
  bool _isCameraAnimating = false;
  bool _arrivalDialogOpen = false;
  String? _pendingArrivalSpotId;
  String? _mapStyle;

  List<LatLng> _routePolyline = const [];
  WalkingLegResult? _currentLeg;
  bool _isOffRoute = false;
  LatLng? _lastRouteFetchOrigin;
  String? _lastRouteFetchDestId;

  static const _defaultPosition = LatLng(35.681236, 139.767125);

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeMode = ref.read(settingsProvider).themeMode;
      _loadMapStyle(themeMode);
      _startLocationStream();
      _startCompassStream();
      _startArrivalTimer();
    });
  }

  void _onSheetChanged() {
    setState(() {});
  }

  Future<void> _loadMapStyle(String themeMode) async {
    try {
      final style = await loadGoogleMapStyle(themeMode);
      if (mounted) {
        setState(() => _mapStyle = style);
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
      if (mounted) {
        setState(() => _mapStyle = null);
      }
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    _locationSub?.cancel();
    _compassSub?.cancel();
    _arrivalTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startLocationStream() {
    final service = ref.read(locationServiceProvider);
    _locationSub = service.getLocationStream().listen((position) {
      if (!mounted) return;
      setState(() => _lastPosition = position);
      ref.read(navigationProvider.notifier).updateLocation(position);
      _maybeFetchRoute(position);
      if (_isFollowingUser) {
        _animateToUser(position, bearing: _compassHeading);
      }
    });
  }

  void _startCompassStream() {
    _compassSub = FlutterCompass.events?.listen((event) {
      if (!mounted || event.heading == null) return;
      final heading = event.heading!;
      setState(() => _compassHeading = heading);
      if (_isFollowingUser && _lastPosition != null) {
        _animateToUser(_lastPosition!, bearing: heading);
      }
    });
  }

  void _startArrivalTimer() {
    _arrivalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkArrival();
      _checkOffRoute();
    });
  }

  Future<void> _maybeFetchRoute(Position position) async {
    final nav = ref.read(navigationProvider);
    final next = nav.nextSpot;
    if (next == null) return;

    final origin = LatLng(position.latitude, position.longitude);
    if (_lastRouteFetchDestId == next.id &&
        _lastRouteFetchOrigin != null &&
        Geolocator.distanceBetween(
              _lastRouteFetchOrigin!.latitude,
              _lastRouteFetchOrigin!.longitude,
              origin.latitude,
              origin.longitude,
            ) <
            30) {
      return;
    }

    _lastRouteFetchOrigin = origin;
    _lastRouteFetchDestId = next.id;

    final leg = await ref.read(directionsServiceProvider).getWalkingLeg(
          origin: origin,
          destination: LatLng(next.lat, next.lng),
        );

    if (!mounted) return;
    setState(() {
      _currentLeg = leg;
      _routePolyline = leg?.points ?? const [];
    });
  }

  void _checkArrival() {
    if (_arrivalDialogOpen || _lastPosition == null) return;

    final nav = ref.read(navigationProvider);
    final next = nav.nextSpot;
    if (next == null || _pendingArrivalSpotId == next.id) return;

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      next.lat,
      next.lng,
    );

    if (distance <= NavigationUiConstants.arrivalRadiusMeters) {
      _pendingArrivalSpotId = next.id;
      _showArrivalDialog(next);
    }
  }

  void _checkOffRoute() {
    if (_lastPosition == null || _routePolyline.length < 2) {
      if (_isOffRoute) setState(() => _isOffRoute = false);
      return;
    }

    final dist = distanceToPolylineMeters(
      LatLng(_lastPosition!.latitude, _lastPosition!.longitude),
      _routePolyline,
    );
    final off = dist >= NavigationUiConstants.offRouteThresholdMeters;
    if (off != _isOffRoute) {
      setState(() => _isOffRoute = off);
    }
  }

  Future<void> _showArrivalDialog(SpotModel spot) async {
    _arrivalDialogOpen = true;

    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 200);
    }

    final nav = ref.read(navigationProvider);
    final isLast = nav.routeSpots.isNotEmpty && nav.routeSpots.last.id == spot.id;

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ArrivalDialog(
        spot: spot,
        isLastSpot: isLast,
        onContinue: () {
          Navigator.of(dialogContext).pop();
          if (isLast) {
            ref.read(navigationProvider.notifier).checkInNextSpot();
            ref.read(resultProvider.notifier).generateResult();
            Future.microtask(() {
              if (mounted) {
                context.go(AppRoutes.result);
              }
            });
          }
        },
      ),
    );

    if (!mounted) return;

    // Only proceed with navigation state resets for intermediate spots since final spot navigates immediately.
    if (!isLast) {
      _arrivalDialogOpen = false;
      ref.read(navigationProvider.notifier).checkInNextSpot();
    }
  }

  Future<void> _animateToUser(Position position, {double? bearing}) async {
    final controller = _mapController;
    if (controller == null) return;

    _isCameraAnimating = true;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17,
            bearing: bearing ?? 0,
            tilt: 45,
          ),
        ),
      );
    } finally {
      _isCameraAnimating = false;
    }
  }

  Future<void> _resetCompass() async {
    final controller = _mapController;
    if (controller == null || _lastPosition == null) return;

    _isCameraAnimating = true;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
            ),
            zoom: 17,
            bearing: 0,
            tilt: 0,
          ),
        ),
      );
    } finally {
      _isCameraAnimating = false;
    }
  }

  Future<void> _recenter() async {
    if (_lastPosition == null) return;
    setState(() => _isFollowingUser = true);
    await _animateToUser(_lastPosition!, bearing: _compassHeading);
  }

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 900,
        imageQuality: 85,
      );
      if (image != null) {
        ref.read(navigationProvider.notifier).addCapturedPhoto(image.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('写真を冒険の記録に保存しました！'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Camera capture error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('カメラの起動に失敗しました: $e')),
        );
      }
    }
  }

  Future<void> _confirmQuit() async {
    final navConstants = NavigationUiConstants.of(context);
    final navState = ref.read(navigationProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: navConstants.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: navConstants.creamBorder, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '冒険を中断しますか？',
                style: navConstants.serifTitle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'ここまでの歩みを記録として保存できます',
                style: navConstants.serifBody.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: navConstants.creamBorder.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      context,
                      '歩行距離',
                      '${navState.walkedDistanceKm.toStringAsFixed(2)} km',
                      Icons.directions_walk,
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      context,
                      '歩数',
                      '${navState.steps} 歩',
                      Icons.show_chart,
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      context,
                      'チェックポイント',
                      '${navState.visitedSpotIds.length} / ${navState.currentRoute?.generatedSpots.length ?? 0}',
                      Icons.place,
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      context,
                      '撮影写真',
                      '${navState.capturedPhotos.length} 枚',
                      Icons.photo_camera,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'キャンセル',
                        style: TextStyle(
                          color: navConstants.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        '保存して中断',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    // 位置情報取得を停止
    await _locationSub?.cancel();
    _locationSub = null;

    if (!mounted) return;

    // 中断リザルトを生成
    await ref.read(resultProvider.notifier).generateResult(
          status: AdventureStatus.abandoned,
          manualProgressRatio: navState.progress,
        );

    if (!mounted) return;

    // 進行中の状態をクリアして結果画面へ
    ref.read(navigationProvider.notifier).finishAdventure();
    context.pushReplacement(AppRoutes.result);
  }

  Widget _buildStatRow(
      BuildContext context, String label, String value, IconData icon) {
    final navConstants = NavigationUiConstants.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: navConstants.sepia),
        const SizedBox(width: 8),
        Text(
          label,
          style: navConstants.serifBody.copyWith(fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: navConstants.serifTitle.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(NavigationState nav) {
    final markers = <Marker>{};

    final next = nav.nextSpot;
    if (next != null) {
      markers.add(
        Marker(
          markerId: MarkerId('dest_${next.id}'),
          position: LatLng(next.lat, next.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(
            title: next.aiStoryName.isNotEmpty ? next.aiStoryName : next.name,
          ),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_routePolyline.length < 2) return const {};
    final colors = AppColors.of(context);

    return {
      Polyline(
        polylineId: const PolylineId('walking_route'),
        points: _routePolyline,
        color: colors.routeLine,
        width: NavigationUiConstants.routeLineWidth.toInt(),
        geodesic: false,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.watch(navigationProvider);
    final navConstants = NavigationUiConstants.of(context);

    ref.listen<String>(settingsProvider.select((s) => s.themeMode), (prev, next) {
      if (prev != next) {
        _loadMapStyle(next);
      }
    });

    if (!nav.isAdventureStarted) {
      return Scaffold(
        backgroundColor: navConstants.cream,
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('ホームへ戻る'),
          ),
        ),
      );
    }

    final isCompleted = nav.nextSpot == null;
    final leg = _currentLeg;
    final distanceLabel = leg?.distanceLabel ??
        (nav.distanceToNextSpot != null
            ? formatDistance(nav.distanceToNextSpot!)
            : '—');
    final durationLabel = leg?.durationLabel ??
        (nav.distanceToNextSpot != null
            ? formatWalkingDuration((nav.distanceToNextSpot! / 1.25).round())
            : '—');

    final initialTarget = _lastPosition != null
        ? LatLng(_lastPosition!.latitude, _lastPosition!.longitude)
        : (nav.nextSpot != null
              ? LatLng(nav.nextSpot!.lat, nav.nextSpot!.lng)
              : _defaultPosition);

    final sheetSize = _sheetController.isAttached ? _sheetController.size : 0.18;
    final bottomOffset = MediaQuery.sizeOf(context).height * sheetSize;

    // アクションボタンの状態
    final actionLabel = !nav.hasDeparted
        ? '出発する'
        : !nav.isArrivedAtCurrentSpot
            ? '到着判定'
            : '次のスポットへ';
    
    final actionIcon = !nav.hasDeparted
        ? Icons.play_arrow_rounded
        : !nav.isArrivedAtCurrentSpot
            ? Icons.check_circle_outline
            : Icons.navigate_next_rounded;

    void onAction() {
      if (!nav.hasDeparted) {
        ref.read(navigationProvider.notifier).depart();
      } else if (!nav.isArrivedAtCurrentSpot) {
        _showArrivalDialog(nav.nextSpot!);
      } else {
        ref.read(navigationProvider.notifier).proceedToNextSpot();
        _pendingArrivalSpotId = null;
        _lastRouteFetchDestId = null;
        if (_lastPosition != null) {
          _maybeFetchRoute(_lastPosition!);
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            buildingsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 16,
              tilt: 45,
            ),
            style: _mapStyle,
            onMapCreated: (controller) => _mapController = controller,
            onCameraMoveStarted: () {
              if (!_isCameraAnimating) {
                setState(() => _isFollowingUser = false);
              }
            },
            markers: _buildMarkers(nav),
            polylines: _buildPolylines(),
          ),

          if (!isCompleted)
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: SafeArea(
                bottom: false,
                child: NextSpotHeader(
                  nextSpot: nav.nextSpot,
                  distanceLabel: distanceLabel,
                  durationLabel: durationLabel,
                  steps: leg?.steps ?? const [],
                ),
              ),
            ),

          Positioned(
            right: 16,
            bottom: bottomOffset + 16,
            child: NavigationMapControls(
              onCompass: _resetCompass,
              onRecenter: _recenter,
              onCamera: _takePhoto,
            ),
          ),

          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.18,
            minChildSize: 0.18,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return NavigationDraggableSheet(
                scrollController: scrollController,
                nextSpot: nav.nextSpot,
                distanceLabel: distanceLabel,
                durationLabel: durationLabel,
                allSpots: nav.routeSpots,
                visitedSpotIds: nav.visitedSpotIds,
                walkedDistanceKm: nav.walkedDistanceKm,
                steps: nav.steps,
                progress: nav.progress,
                onQuit: _confirmQuit,
                actionLabel: actionLabel,
                actionIcon: actionIcon,
                onAction: onAction,
              );
            },
          ),

          if (!isCompleted)
            Positioned(
              top: MediaQuery.sizeOf(context).height * (1 - sheetSize) - 220,
              left: 0,
              child: Torenyan(
                size: 200,
                enableTap: true,
                showSpeechBubble: true,
                customLines: nav.torenyanLines,
              ),
            ),

          if (isCompleted)
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(context).bottom + 16,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(resultProvider.notifier).generateResult();
                  context.go(AppRoutes.result);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navConstants.sepia,
                  foregroundColor: navConstants.cream,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  '冒険の記録を報告する',
                  style: navConstants.serifBody.copyWith(
                    color: navConstants.cream,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
