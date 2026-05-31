// lib/pages/navigation_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vibration/vibration.dart';

import '../constants/navigation_ui_constants.dart';
import '../models/spot_model.dart';
import '../models/walking_leg_result.dart';
import '../providers/location_provider.dart';
import '../providers/navigation_provider.dart';
import '../router/route_names.dart';
import '../services/directions_service.dart';
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
    _loadMapStyle();
    _sheetController.addListener(_onSheetChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLocationStream();
      _startCompassStream();
      _startArrivalTimer();
    });
  }

  void _onSheetChanged() {
    setState(() {});
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString(
        'assets/map_styles/dark_fantasy_map.json',
      );
      if (mounted) {
        setState(() => _mapStyle = style);
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
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
      builder: (context) => ArrivalDialog(
        spot: spot,
        isLastSpot: isLast,
        onContinue: () {
          if (isLast) {
            ref.read(navigationProvider.notifier).checkInNextSpot();
            context.go(AppRoutes.result);
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );

    if (!mounted) return;

    // Only proceed with navigation state resets for intermediate spots since final spot navigates immediately.
    if (!isLast) {
      _arrivalDialogOpen = false;
      ref.read(navigationProvider.notifier).checkInNextSpot();
      _pendingArrivalSpotId = null;
      _lastRouteFetchDestId = null;

      if (_lastPosition != null) {
        _maybeFetchRoute(_lastPosition!);
      }
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

  Future<void> _confirmQuit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NavigationUiConstants.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: NavigationUiConstants.creamBorder,
            width: 1.5,
          ),
        ),
        title: Text('冒険をやめる', style: NavigationUiConstants.serifTitle),
        content: Text(
          'ナビゲーションを中断して戻ります。よろしいですか？',
          style: NavigationUiConstants.serifBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'キャンセル',
              style: TextStyle(color: NavigationUiConstants.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'やめる',
              style: TextStyle(
                color: NavigationUiConstants.sepia,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _locationSub?.cancel();
    _locationSub = null;
    if (!mounted) return;
    ref.read(navigationProvider.notifier).finishAdventure();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  Set<Marker> _buildMarkers(NavigationState nav) {
    final markers = <Marker>{};

    if (_lastPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
          ),
          rotation: _compassHeading,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          zIndexInt: 10,
        ),
      );
    }

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

    return {
      Polyline(
        polylineId: const PolylineId('walking_route'),
        points: _routePolyline,
        color: NavigationUiConstants.sepia,
        width: NavigationUiConstants.routeLineWidth.toInt(),
        geodesic: false,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  TorenyanNavMode _torenyanMode(NavigationState nav) {
    if (nav.nextSpot == null) return TorenyanNavMode.arrived;
    if (_isOffRoute) return TorenyanNavMode.offRoute;
    return TorenyanNavMode.moving;
  }

  List<String> _torenyanLines(NavigationState nav) {
    final mode = _torenyanMode(nav);
    return switch (mode) {
      TorenyanNavMode.moving => [
          'この道を進めば、物語の続きが見えるよ',
          '冒険の道中も、何か見つかるかもしれないね',
          '一歩ずつ進んでいこう！',
          '目的地まであと少しかな？',
        ],
      TorenyanNavMode.offRoute => [
          '道から外れちゃった…戻ろうか',
          'あれれ、どこに行くの？元の道に戻ろう',
          'ちょっと寄り道？迷子にならないでね',
        ],
      TorenyanNavMode.arrived => [
          '着いたね！ここで何か見つかるかも',
          '目的地に到着！次のスポットを探そう',
          'ここがチェックポイントだよ、お疲れ様！',
        ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.watch(navigationProvider);

    if (!nav.isAdventureStarted) {
      return Scaffold(
        backgroundColor: NavigationUiConstants.cream,
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

    final sheetSize = _sheetController.isAttached ? _sheetController.size : 0.12;
    final bottomOffset = MediaQuery.sizeOf(context).height * sheetSize;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: false,
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
                ),
              ),
            ),

          if (!isCompleted && nav.nextSpot != null)
            Positioned(
              top: 150,
              right: 16,
              child: SafeArea(
                child: FloatingActionButton.extended(
                  onPressed: () => _showArrivalDialog(nav.nextSpot!),
                  backgroundColor: const Color(0xFFC8A97A),
                  foregroundColor: const Color(0xFF2C2318),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    '到着判定',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          Positioned(
            right: 16,
            bottom: bottomOffset + 16,
            child: NavigationMapControls(
              onCompass: _resetCompass,
              onRecenter: _recenter,
            ),
          ),

          if (!isCompleted)
            Positioned(
              top: MediaQuery.sizeOf(context).height * (1 - sheetSize) - 220,
              left: 15,
              child: Torenyan(
                size: 210,
                enableTap: true,
                showSpeechBubble: true,
                customLines: _torenyanLines(nav),
              ),
            ),

          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return NavigationDraggableSheet(
                scrollController: scrollController,
                nextSpot: nav.nextSpot,
                distanceLabel: distanceLabel,
                allSpots: nav.routeSpots,
                visitedSpotIds: nav.visitedSpotIds,
                onQuit: _confirmQuit,
              );
            },
          ),

          if (isCompleted)
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(context).bottom + 16,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutes.result),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NavigationUiConstants.sepia,
                  foregroundColor: NavigationUiConstants.cream,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  '冒険の記録を報告する',
                  style: NavigationUiConstants.serifBody.copyWith(
                    color: NavigationUiConstants.cream,
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
