// lib/widgets/navigation/navigation_draggable_sheet.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';

class NavigationDraggableSheet extends StatelessWidget {
  final ScrollController scrollController;
  final SpotModel? nextSpot;
  final String distanceLabel;
  final List<SpotModel> allSpots;
  final Set<String> visitedSpotIds;
  final VoidCallback onQuit;

  const NavigationDraggableSheet({
    super.key,
    required this.scrollController,
    required this.nextSpot,
    required this.distanceLabel,
    required this.allSpots,
    required this.visitedSpotIds,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final navConstants = NavigationUiConstants.of(context);
    final nextName = nextSpot == null
        ? 'ゴール到達'
        : (nextSpot!.aiStoryName.isNotEmpty
              ? nextSpot!.aiStoryName
              : nextSpot!.name);
    final distance = distanceLabel;

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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: navConstants.sepia.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('現在地から', style: navConstants.serifCaption),
          const SizedBox(height: 4),
          Text(nextName, style: navConstants.serifTitle),
          const SizedBox(height: 6),
          Text(
            '残り $distance',
            style: navConstants.serifBody.copyWith(
              color: navConstants.sepia,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
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
