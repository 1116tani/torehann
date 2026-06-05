//lib/pages/result_page.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../models/result_model.dart';
import '../models/fragment_model.dart';
import '../providers/level_provider.dart';
import '../providers/result_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/settings_provider.dart';
import '../router/route_names.dart';
import '../models/adventure_history_model.dart';
import '../utils/map_style_loader.dart';
import '../widgets/common/custom_header.dart';

class ResultPage extends ConsumerStatefulWidget {
  final bool isFromHistory;
  final AdventureHistoryModel? history;

  const ResultPage({
    super.key,
    this.isFromHistory = false,
    this.history,
  });

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  String? _mapStyle;
  bool _animationsSequenceStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFromHistory && widget.history != null) {
        ref.read(resultProvider.notifier).initForHistory(widget.history!);
      }
      final themeMode = ref.read(settingsProvider).themeMode;
      _loadMapStyle(themeMode);
      
      if (!widget.isFromHistory) {
        _startAnimationsSequence();
      }
    });
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

  Future<void> _startAnimationsSequence() async {
    if (_animationsSequenceStarted) return;
    _animationsSequenceStarted = true;

    final result = ref.read(resultProvider).result;
    if (result == null) return;

    // ── 1. EXP & Level Up Animation ──
    await _showExpAnimation(result.expGained);

    // ── 2. Fragment Discovery Animation ──
    if (result.obtainedFragments.isNotEmpty && mounted) {
      await _showFragmentAnimation(result.obtainedFragments);
    }
  }

  Future<void> _showExpAnimation(int expGained) async {
    final totalXp = ref.read(levelProvider).totalXp;
    final oldState = LevelCalculator.fromTotalXp(totalXp);
    final newState = LevelCalculator.fromTotalXp(totalXp + expGained);
    final didLevelUp = newState.level > oldState.level;

    if (didLevelUp) {
      await _showLevelUpDialog(oldState.level, newState.level, expGained);
    } else {
      ref.read(levelProvider.notifier).addXp(expGained);
      // EXPゲージのアニメーションを待つ
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  Future<void> _showFragmentAnimation(List<FragmentModel> fragments) async {
    if (fragments.isEmpty || !mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _FragmentDiscoveryModal(fragments: fragments),
    );
  }

  Future<void> _showLevelUpDialog(int oldLevel, int newLevel, int expGained) async {
    if (!mounted) return;
    final colors = AppColors.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary, width: 2.0),
        ),
        title: Center(
          child: Text(
            '🌟 LEVEL UP! 🌟',
            style: GoogleFonts.notoSerifJp(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars_rounded,
              color: colors.primary,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'Lv. $oldLevel → Lv. $newLevel',
              style: GoogleFonts.notoSerifJp(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'あなたの冒険レベルが上がりました！\n新しい世界があなたを待っています。',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifJp(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(levelProvider.notifier).addXp(expGained);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('街の断片を探す'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    ref.listen<String>(settingsProvider.select((s) => s.themeMode), (prev, next) {
      if (prev != next) {
        _loadMapStyle(next);
      }
    });

    ref.listen<ResultState>(resultProvider, (previous, next) {
      if (widget.isFromHistory) return;
      if (next.result != null && (previous == null || previous.result == null)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _startAnimationsSequence();
        });
      }
    });

    final resultState = ref.watch(resultProvider);
    final result = resultState.result;

    if (resultState.isLoading || result == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ── 1. ヘッダー ──
                CustomHeader(
                  title: widget.isFromHistory ? '冒険の記録' : 'RESULT',
                  subtitle: widget.isFromHistory ? 'ADVENTURE RESULT' : '冒険終了',
                  showBackButton: widget.isFromHistory,
                  onBack: () => context.pop(),
                ),

                // ── スクロール本体 ──
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      18,
                      10,
                      18,
                      widget.isFromHistory ? 40 : 120,
                    ),
                    children: [
                      _buildSummarySection(context, result),
                      const SizedBox(height: 24),
                      _buildStatusCards(context, result),
                      const SizedBox(height: 30),
                      _buildMapSection(context, result),
                      const SizedBox(height: 30),
                      if (result.photos.isNotEmpty) ...[
                        _buildAlbumSection(context, result),
                        const SizedBox(height: 30),
                      ],
                      _buildAiJournalSection(context, result),
                      const SizedBox(height: 30),
                      if (result.obtainedFragments.isNotEmpty) ...[
                        _buildFragmentsSection(context, result),
                        const SizedBox(height: 30),
                      ],
                      if (result.unlockedAchievements.isNotEmpty) ...[
                        _buildAchievementsSection(context, result),
                        const SizedBox(height: 30),
                      ],
                      _buildShareSection(context, result),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!widget.isFromHistory)
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(context).bottom + 12,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).finishAdventure();
                    Future.microtask(() {
                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.background,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'ホーム画面へ戻る',
                    style: GoogleFonts.notoSerifJp(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    final levelState = ref.watch(levelProvider);
    final dateStr = DateFormat('yyyy/MM/dd').format(result.completedAt);
    final remainingXp = levelState.nextLevelXp - levelState.currentLevelXp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.title,
          style: GoogleFonts.notoSerifJp(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colors.primary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              dateStr,
              style: GoogleFonts.notoSerifJp(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: result.status == AdventureStatus.completed
                      ? AppColors.success
                      : colors.textMuted,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: result.status == AdventureStatus.completed
                    ? AppColors.success.withValues(alpha: 0.1)
                    : colors.surfaceLight,
              ),
              child: Text(
                result.status == AdventureStatus.completed
                    ? '完走'
                    : '中断 ${(result.progressRatio * 100).round()}%',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 11,
                  color: result.status == AdventureStatus.completed
                      ? AppColors.success
                      : colors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (!widget.isFromHistory) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '現在のレベル: Lv.${levelState.level}',
                      style: GoogleFonts.notoSerifJp(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '次のレベルまで あと $remainingXp EXP',
                      style: GoogleFonts.notoSerifJp(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      height: 10,
                      width: (MediaQuery.sizeOf(context).width - 68) * levelState.progress,
                      decoration: BoxDecoration(
                        gradient: AppGradients.of(context).gold,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusCards(BuildContext context, AdventureResult result) {
    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            icon: Icons.directions_walk_rounded,
            label: '距離',
            value: result.distanceKm.toStringAsFixed(1),
            unit: 'km',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: Icons.directions_run_rounded,
            label: '歩数',
            value: result.steps.toString(),
            unit: '歩',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: Icons.stars_rounded,
            label: '獲得EXP',
            value: '+${result.expGained}',
            unit: '',
            isHighlight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    final routePoints = result.routePoints.isNotEmpty
        ? result.routePoints
        : [
            const LatLng(35.681236, 139.767125),
            const LatLng(35.683236, 139.769125),
          ];

    final startPoint = routePoints.first;
    final endPoint = routePoints.last;

    // マーカーの生成
    final markers = <Marker>{
      // スタート地点（緑）
      Marker(
        markerId: const MarkerId('start'),
        position: startPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'スタート地点'),
      ),
      // ゴール地点（オレンジ）
      Marker(
        markerId: const MarkerId('end'),
        position: endPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'ゴール地点'),
      ),
    };

    // 街の断片（チェックポイント）も表示
    for (var i = 0; i < result.obtainedFragments.length; i++) {
      // Note: 実際にはFragmentに座標を持たせるか、Spotから取得する必要があるが、
      // ここでは簡易的にルート上の適当な点をチェックポイントとする（演出用）
      if (routePoints.length > 2 && i + 1 < routePoints.length - 1) {
        markers.add(
          Marker(
            markerId: MarkerId('checkpoint_$i'),
            position: routePoints[(routePoints.length * (i + 1) ~/ (result.obtainedFragments.length + 1))],
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          ),
        );
      }
    }

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('actual_route'),
        points: routePoints,
        color: const Color(0xFF3DE0C1), // エメラルドグリーン系
        width: 7,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.map_outlined, color: colors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              '旅の軌跡',
              style: GoogleFonts.notoSerifJp(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: startPoint,
                    zoom: 15,
                  ),
                  style: _mapStyle,
                  markers: markers,
                  polylines: polylines,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (controller) {
                    // 全ルートが収まるように調整
                    Future.delayed(const Duration(milliseconds: 500), () {
                      controller.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          _getBounds(routePoints),
                          50,
                        ),
                      );
                    });
                  },
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'map_expand',
                    onPressed: () => _openFullscreenMap(context, startPoint, markers, polylines),
                    backgroundColor: colors.surface.withValues(alpha: 0.9),
                    foregroundColor: colors.primary,
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _openFullscreenMap(BuildContext context, LatLng startPoint, Set<Marker> markers, Set<Polyline> polylines) {
    final colors = AppColors.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: colors.background,
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(
                target: startPoint,
                zoom: 15,
              ),
              style: _mapStyle,
              markers: markers,
              polylines: polylines,
              onMapCreated: (controller) {
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _getBounds(polylines.first.points),
                    60,
                  ),
                );
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: colors.surface.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: Icon(Icons.close, color: colors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumSection(BuildContext context, AdventureResult result) {
    if (result.photos.isEmpty) return const SizedBox.shrink();

    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library_outlined, color: colors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              '冒険アルバム',
              style: GoogleFonts.notoSerifJp(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: result.photos.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final photo = result.photos[index];
              // ポラロイド風の回転を交互につける
              final rotation = index.isEven ? -0.03 : 0.02;

              return Transform.rotate(
                angle: rotation,
                child: Container(
                  width: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openFullscreenImage(context, photo.imageUrl, photo.caption),
                          child: Hero(
                            tag: 'photo_$index',
                            child: _buildPhotoImage(photo.imageUrl),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        photo.caption,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }

  void _openFullscreenImage(BuildContext context, String imageUrl, String caption) {
    final colors = AppColors.of(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.9),
          body: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox.expand(),
              ),
              Center(
                child: InteractiveViewer(
                  child: _buildPhotoImage(imageUrl),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: SafeArea(
                  child: CircleAvatar(
                    backgroundColor: colors.surface.withValues(alpha: 0.8),
                    child: IconButton(
                      icon: Icon(Icons.close, color: colors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              if (caption.isNotEmpty)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 40,
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          caption,
                          style: GoogleFonts.notoSerifJp(
                            color: colors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiJournalSection(BuildContext context, AdventureResult result) {
    final isCompleted = result.status == AdventureStatus.completed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '冒険日誌',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.of(context).textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.parchmentDark, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.aiStory,
                style: GoogleFonts.notoSerifJp(
                  fontSize: 16,
                  color: AppColors.textDark,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  isCompleted
                      ? '「寄り道は、きっと無駄じゃない。」'
                      : '「旅は途中で終わった。しかし、その足跡は確かにこの街へ刻まれた。」',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifJp(
                    fontSize: 14,
                    color: AppColors.textDark.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFragmentsSection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '手に入れた街の断片',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...result.obtainedFragments.map((fragment) {
                final rarityColor = _getRarityColor(fragment.rarity);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        color: rarityColor,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '・ ${_getFragmentName(fragment.itemMasterId)}',
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(FragmentRarity rarity) {
    return switch (rarity) {
      FragmentRarity.normal => Colors.brown.shade300,
      FragmentRarity.rare => Colors.blue.shade400,
      FragmentRarity.legend => Colors.amber.shade600,
    };
  }

  String _getFragmentName(String masterId) {
    final names = {
      'item_01': '始まりの木の枝',
      'item_02': '幸運の10円硬貨',
      'item_03': '迷い鳥の羽',
      'item_04': '奇跡のレシート',
      'item_05': '破られた白地図',
      'item_06': '絆のウォーキングシューズ',
      'item_07': '社の御守札',
      'item_08': '転移切符',
      'item_09': '迷宮の魔導書',
      'item_10': 'カフェのスタンプカード',
      'item_11': '黄昏の硝子玉',
      'item_12': '雨粒の小瓶',
      'item_13': '商店街の福引券',
      'item_14': '公園の夕暮れ石',
      'item_15': '絆の編纂珠',
      'item_16': '境界のスマートフォン',
      'item_17': 'この街の記憶地図',
    };
    return names[masterId] ?? '未知の断片';
  }

  Widget _buildAchievementsSection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '解除した実績',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: result.unlockedAchievements.map((achievement) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.primary, width: 1.5),
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        color: colors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '実績解除！',
                            style: GoogleFonts.notoSerifJp(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            achievement,
                            style: GoogleFonts.notoSerifJp(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildShareSection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider(color: colors.divider, thickness: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '冒険を振り返る',
                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(child: Divider(color: colors.divider, thickness: 0.5)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => _onShare(context, result),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(color: colors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(Icons.share_rounded, color: colors.primary, size: 20),
            label: Text(
              'この冒険を共有する',
              style: GoogleFonts.notoSerifJp(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onShare(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    final shareText = '''
📜 ${result.title}
🗺️ ${result.distanceKm.toStringAsFixed(1)}km を冒険しました！
⏱️ ${result.durationMinutes}分 / 👣 ${result.steps}歩
🌟 獲得EXP: +${result.expGained} EXP

#TaleTrace #街の記憶 #冒険ログ
''';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary, width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.mark_email_unread_outlined, color: colors.primary),
            const SizedBox(width: 10),
            Text(
              'シェア用ポストカード',
              style: GoogleFonts.notoSerifJp(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.parchmentDark, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tale Trace - Adventure Log',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B6C3F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.title,
                style: GoogleFonts.notoSerifJp(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Divider(color: Color(0xFFC8A97A), thickness: 1, height: 16),
              Text(
                '🐾 距離: ${result.distanceKm.toStringAsFixed(1)} km\n👣 歩数: ${result.steps} 歩\n⏱️ 時間: ${result.durationMinutes} 分\n✨ 獲得EXP: +${result.expGained} XP',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 13,
                  color: AppColors.textDark,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('閉じる', style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: shareText));
              Navigator.pop(context);
              _showSnackBar('📋 クリップボードに共有テキストをコピーしました！');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('コピーしてシェア'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String text) {
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          text,
          style: TextStyle(
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final bool isHighlight;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlight ? colors.primary.withValues(alpha: 0.1) : colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? colors.primary.withValues(alpha: 0.3) : colors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: isHighlight ? colors.primary : colors.textSecondary),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSerifJp(
              fontSize: 10,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.notoSerifJp(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: GoogleFonts.notoSerifJp(
                    fontSize: 9,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _FragmentDiscoveryModal extends StatefulWidget {
  final List<FragmentModel> fragments;

  const _FragmentDiscoveryModal({required this.fragments});

  @override
  State<_FragmentDiscoveryModal> createState() => _FragmentDiscoveryModalState();
}

class _FragmentDiscoveryModalState extends State<_FragmentDiscoveryModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < widget.fragments.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.reset();
        _controller.forward();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final fragment = widget.fragments[_currentIndex];
    final rarityColor = _getRarityColor(fragment.rarity);
    final rarityLabel = _getRarityLabel(fragment.rarity);
    final itemName = _getFragmentName(fragment.itemMasterId);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: _next,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: rarityColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: rarityColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '✨ 街の断片を発見！',
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colors.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: rarityColor, width: 1.5),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 64,
                          color: rarityColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        itemName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: rarityColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: rarityColor, width: 1),
                        ),
                        child: Text(
                          rarityLabel,
                          style: GoogleFonts.notoSerifJp(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rarityColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        '画面をタップして次へ',
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getRarityColor(FragmentRarity rarity) {
    return switch (rarity) {
      FragmentRarity.normal => Colors.brown.shade300,
      FragmentRarity.rare => Colors.blue.shade400,
      FragmentRarity.legend => Colors.amber.shade600,
    };
  }

  String _getRarityLabel(FragmentRarity rarity) {
    return switch (rarity) {
      FragmentRarity.normal => 'NORMAL',
      FragmentRarity.rare => 'RARE',
      FragmentRarity.legend => 'LEGEND',
    };
  }

  String _getFragmentName(String masterId) {
    final names = {
      'item_01': '始まりの木の枝',
      'item_02': '幸運の10円硬貨',
      'item_03': '迷い鳥の羽',
      'item_04': '奇跡のレシート',
      'item_05': '破られた白地図',
      'item_06': '絆のウォーキングシューズ',
      'item_07': '社の御守札',
      'item_08': '転移切符',
      'item_09': '迷宮の魔導書',
      'item_10': 'カフェのスタンプカード',
      'item_11': '黄昏の硝子玉',
      'item_12': '雨粒の小瓶',
      'item_13': '商店街の福引券',
      'item_14': '公園の夕暮れ石',
      'item_15': '絆の編纂珠',
      'item_16': '境界のスマートフォン',
      'item_17': 'この街の記憶地図',
    };
    return names[masterId] ?? '未知の断片';
  }
}
