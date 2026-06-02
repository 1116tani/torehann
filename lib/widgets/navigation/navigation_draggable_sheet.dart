// lib/widgets/navigation/navigation_draggable_sheet.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';

class NavigationDraggableSheet extends StatelessWidget {
  final ScrollController scrollController;
  final SpotModel? nextSpot;
  final String distanceLabel;
  final String durationLabel;
  final List<SpotModel> allSpots;
  final Set<String> visitedSpotIds;
  final double walkedDistanceKm;
  final int steps;
  final double progress;
  final VoidCallback onQuit;

  const NavigationDraggableSheet({
    super.key,
    required this.scrollController,
    required this.nextSpot,
    required this.distanceLabel,
    required this.durationLabel,
    required this.allSpots,
    required this.visitedSpotIds,
    required this.walkedDistanceKm,
    required this.steps,
    required this.progress,
    required this.onQuit,
  });

  String _getOriginName() {
    if (visitedSpotIds.isEmpty) return 'スタート地点';
    SpotModel? lastVisited;
    for (final spot in allSpots) {
      if (visitedSpotIds.contains(spot.id)) {
        lastVisited = spot;
      }
    }
    if (lastVisited == null) return 'スタート地点';
    return lastVisited.aiStoryName.isNotEmpty ? lastVisited.aiStoryName : lastVisited.name;
  }

  @override
  Widget build(BuildContext context) {
    final navConstants = NavigationUiConstants.of(context);
    final nextName = nextSpot == null
        ? 'ゴール到達'
        : (nextSpot!.aiStoryName.isNotEmpty
              ? nextSpot!.aiStoryName
              : nextSpot!.name);

    final progressPercent = (progress * 100).round();

    return Material(
      color: navConstants.cream,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      elevation: 12,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: navConstants.sepia.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // ── 現在地 ➜ 目的地 ─────────────────────
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: navConstants.sepia),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${_getOriginName()} ➜ $nextName',
                  style: navConstants.serifTitle.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── 統計情報グリッド ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '残り $distanceLabel (約 $durationLabel)',
                style: navConstants.serifBody.copyWith(
                  color: navConstants.sepia,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '👣 $steps 歩  /  🐾 ${walkedDistanceKm.toStringAsFixed(2)} km',
                style: navConstants.serifCaption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── プログレスバー ──────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: navConstants.sepia.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: navConstants.sepia,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '進行率 $progressPercent%',
                style: navConstants.serifCaption.copyWith(
                  color: navConstants.sepia,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── チェックポイントリスト ─────────────────
          Text('チェックポイント', style: navConstants.serifCaption),
          const SizedBox(height: 10),
          ...allSpots.map((spot) {
            final visited = visitedSpotIds.contains(spot.id);
            final isNext = nextSpot?.id == spot.id;
            final label =
                spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(
                    visited
                        ? Icons.check_circle
                        : isNext
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: visited
                        ? navConstants.sepia
                        : navConstants.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: navConstants.serifBody.copyWith(
                            fontWeight:
                                isNext ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        if (spot.aiStoryName.isNotEmpty && isNext) ...[
                          const SizedBox(height: 2),
                          Text(
                            '（${spot.name}）',
                            style: navConstants.serifCaption.copyWith(fontSize: 12),
                          ),
                        ],
                        if (spot.aiFlavorText.isNotEmpty && isNext) ...[
                          const SizedBox(height: 4),
                          Text(
                            spot.aiFlavorText,
                            style: navConstants.serifCaption,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onQuit,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              '冒険をやめる',
              style: navConstants.serifBody.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: navConstants.textDark,
              side: BorderSide(
                color: navConstants.sepia.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
