// lib/widgets/navigation/navigation_draggable_sheet.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';
import '../../utils/polyline_utils.dart';

class NavigationDraggableSheet extends StatelessWidget {
  final ScrollController scrollController;
  final SpotModel? nextSpot;
  final double? distanceToNext;
  final List<SpotModel> allSpots;
  final Set<String> visitedSpotIds;
  final VoidCallback onQuit;

  const NavigationDraggableSheet({
    super.key,
    required this.scrollController,
    required this.nextSpot,
    required this.distanceToNext,
    required this.allSpots,
    required this.visitedSpotIds,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final nextName = nextSpot == null
        ? 'ゴール到達'
        : (nextSpot!.aiStoryName.isNotEmpty
              ? nextSpot!.aiStoryName
              : nextSpot!.name);
    final distance = distanceToNext != null
        ? formatDistance(distanceToNext!)
        : '—';

    return Material(
      color: NavigationUiConstants.cream,
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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: NavigationUiConstants.sepia.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('現在地から', style: NavigationUiConstants.serifCaption),
          const SizedBox(height: 4),
          Text(nextName, style: NavigationUiConstants.serifTitle),
          const SizedBox(height: 6),
          Text(
            '残り $distance',
            style: NavigationUiConstants.serifBody.copyWith(
              color: NavigationUiConstants.sepia,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text('チェックポイント', style: NavigationUiConstants.serifCaption),
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
                        ? NavigationUiConstants.sepia
                        : NavigationUiConstants.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: NavigationUiConstants.serifBody.copyWith(
                            fontWeight:
                                isNext ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        if (spot.aiFlavorText.isNotEmpty && isNext) ...[
                          const SizedBox(height: 4),
                          Text(
                            spot.aiFlavorText,
                            style: NavigationUiConstants.serifCaption,
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
              style: NavigationUiConstants.serifBody.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: NavigationUiConstants.textDark,
              side: BorderSide(
                color: NavigationUiConstants.sepia.withValues(alpha: 0.5),
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
