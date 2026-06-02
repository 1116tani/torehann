// lib/pages/result_page.dart

import 'dart:async';
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
import '../providers/level_provider.dart';
import '../providers/result_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/settings_provider.dart';
import '../router/route_names.dart';
import '../utils/map_style_loader.dart';

class ResultPage extends ConsumerStatefulWidget {
  final bool isFromHistory;

  const ResultPage({
    super.key,
    this.isFromHistory = false,
  });

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeMode = ref.read(settingsProvider).themeMode;
      _loadMapStyle(themeMode);
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

  void _showLevelUpDialog(int oldLevel, int newLevel, int expGained) {
    if (!mounted) return;
    final colors = AppColors.of(context);

    showDialog<void>(
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
              child: const Text('冒険日記へ'),
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
          final res = next.result!;
          final totalXp = ref.read(levelProvider).totalXp;
          final oldState = LevelCalculator.fromTotalXp(totalXp);
          final newState = LevelCalculator.fromTotalXp(totalXp + res.expGained);
          final didLevelUp = newState.level > oldState.level;

          if (didLevelUp) {
            _showLevelUpDialog(oldState.level, newState.level, res.expGained);
          } else {
            ref.read(levelProvider.notifier).addXp(res.expGained);
          }
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
                _buildHeader(context),

                // ── スクロール本体 ──
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      18,
                      10,
                      18,
                      widget.isFromHistory ? 40 : 120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummarySection(context, result),
                        const SizedBox(height: 30),
                        _buildMapSection(context, result),
                        const SizedBox(height: 30),
                        if (result.photos.isNotEmpty) ...[
                          _buildAlbumSection(context, result),
                          const SizedBox(height: 30),
                        ],
                        _buildAiJournalSection(context, result),
                        const SizedBox(height: 30),
                        if (result.fragments.isNotEmpty) ...[
                          _buildFragmentsSection(context, result),
                          const SizedBox(height: 30),
                        ],
                        if (result.achievements.isNotEmpty) ...[
                          _buildAchievementsSection(context, result),
                          const SizedBox(height: 30),
                        ],
                        _buildShareSection(context, result),
                      ],
                    ),
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

  Widget _buildHeader(BuildContext context) {
    final colors = AppColors.of(context);
    if (widget.isFromHistory) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colors.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '冒険の記録',
                    style: GoogleFonts.notoSerifJp(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ADVENTURE RESULT',
                    style: GoogleFonts.notoSerifJp(
                      color: colors.textMuted,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            children: [
              Text(
                'RESULT',
                style: GoogleFonts.notoSerifJp(
                  color: colors.primary,
                  fontSize: 12,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '冒険の記録',
                style: GoogleFonts.notoSerifJp(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 1.5,
                color: colors.border,
              ),
            ],
          ),
        ),
      );
    }
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
                border: Border.all(color: colors.primary, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '完走',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 11,
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colors.divider, width: 0.5),
              bottom: BorderSide(color: colors.divider, width: 0.5),
            ),
          ),
          child: Text.rich(
            TextSpan(
              style: GoogleFonts.notoSerifJp(
                fontSize: 15,
                color: colors.textSecondary,
                height: 1.8,
              ),
              children: [
                const TextSpan(text: 'この日、私たちは '),
                TextSpan(
                  text: '${result.distanceKm.toStringAsFixed(1)}km',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' の路を歩み、'),
                TextSpan(
                  text: '${result.steps}歩',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' の足跡を残した。総所要時間は '),
                TextSpan(
                  text: '${result.durationMinutes}分',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '。この旅を通じて、私たちは新たに '),
                TextSpan(
                  text: '+${result.expGained} EXP',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' の経験を獲得した。思い出は胸に刻まれ、次なる旅路への糧となるだろう。'),
              ],
            ),
          ),
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

  Widget _buildMapSection(BuildContext context, AdventureResult result) {
    final colors = AppColors.of(context);
    final navState = ref.read(navigationProvider);
    final routePoints = navState.currentRoute?.generatedSpots
            .map((s) => LatLng(s.lat, s.lng))
            .toList() ??
        [
          const LatLng(35.681236, 139.767125),
          const LatLng(35.683236, 139.769125),
          const LatLng(35.682236, 139.772125),
          const LatLng(35.680236, 139.774125),
        ];

    final startPoint = routePoints.first;
    final endPoint = routePoints.last;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('start'),
        position: startPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'スタート地点'),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: endPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'ゴール地点'),
      ),
    };

    for (int i = 1; i < routePoints.length - 1; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('checkpoint_$i'),
          position: routePoints[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(title: 'スポット $i'),
        ),
      );
    }

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('route_glow'),
        points: routePoints,
        color: colors.primary.withValues(alpha: 0.35),
        width: 10,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
      Polyline(
        polylineId: const PolylineId('route_core'),
        points: routePoints,
        color: colors.primary,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    final mapWidget = GoogleMap(
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      initialCameraPosition: CameraPosition(
        target: startPoint,
        zoom: 14.5,
      ),
      style: _mapStyle,
      markers: markers,
      polylines: polylines,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '旅の軌跡',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                mapWidget,
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: ElevatedButton.icon(
                    onPressed: () => _openFullscreenMap(context, startPoint, markers, polylines),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.surface,
                      foregroundColor: colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    icon: const Icon(Icons.fullscreen, size: 18),
                    label: Text(
                      '拡大する',
                      style: GoogleFonts.notoSerifJp(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            ),
            Positioned(
              top: 40,
              left: 16,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: colors.surface,
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
    final colors = AppColors.of(context);
    final angles = [-0.04, 0.03, -0.02];
    final alignments = [Alignment.centerLeft, Alignment.centerRight, Alignment.centerLeft];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '冒険アルバム',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(result.photos.length, (i) {
            final photo = result.photos[i];
            return Transform.rotate(
              angle: angles[i % angles.length],
              child: Align(
                alignment: alignments[i % alignments.length],
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _openFullscreenImage(context, photo.imageUrl, photo.caption),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Hero(
                              tag: photo.imageUrl,
                              child: Image.network(
                                photo.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          photo.caption,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerifJp(
                            fontSize: 12,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
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
                child: Hero(
                  tag: imageUrl,
                  child: InteractiveViewer(
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: SafeArea(
                  child: CircleAvatar(
                    backgroundColor: colors.surface,
                    child: IconButton(
                      icon: Icon(Icons.close, color: colors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
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
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AIの旅日記',
          style: GoogleFonts.notoSerifJp(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
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
          child: Stack(
            children: [
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.history_edu_rounded,
                  color: Color(0x281A1A1A),
                  size: 40,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.aiStory,
                    style: GoogleFonts.notoSerifJp(
                      fontSize: 15,
                      color: AppColors.textDark,
                      height: 1.9,
                    ),
                  ),
                  if (result.closingMessage.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        result.closingMessage,
                        style: GoogleFonts.notoSerifJp(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
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
              Text(
                '本の目次のように、街の記憶が断片として紡ぎ出された。',
                style: GoogleFonts.notoSerifJp(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              ...result.fragments.map((fragment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        color: colors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '・ $fragment',
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
          children: result.achievements.map((achievement) {
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
