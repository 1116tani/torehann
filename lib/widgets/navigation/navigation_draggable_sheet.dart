// lib/widgets/navigation/navigation_draggable_sheet.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
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
  
  // アクションボタン用のプロパティ
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;

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
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final navConstants = NavigationUiConstants.of(context);
    
    return Material(
      color: navConstants.cream,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      elevation: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: navConstants.creamBorder.withValues(alpha: 0.5), width: 1),
        ),
        child: Column(
          children: [
            // ── グリップ ─────────────────────
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: navConstants.sepia.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                children: [
                  // ── 通常時（閉じている状態でも見えるメイン情報） ──────────
                  _buildCollapsedHeader(context, navConstants),
                  
                  const SizedBox(height: 24),

                  // ── 冒険ステータス（カード形式） ──────────────────
                  _buildStatsCard(context, navConstants),

                  const SizedBox(height: 28),

                  // ── アクションボタン ────────────────────────────
                  ElevatedButton.icon(
                    onPressed: onAction,
                    icon: Icon(actionIcon),
                    label: Text(actionLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navConstants.sepia,
                      foregroundColor: navConstants.cream,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: navConstants.serifTitle.copyWith(
                        fontSize: 20, // 💡 さらに大きく
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── チェックポイントリスト（タイムライン風） ──────────────
                  Text(
                    '冒険の軌跡',
                    style: navConstants.serifTitle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  _buildCheckpointTimeline(context, navConstants),

                  const SizedBox(height: 40),

                  // ── 冒険終了ボタン ────────────────────────────
                  ElevatedButton.icon(
                    onPressed: onQuit,
                    icon: const Icon(Icons.flag_rounded),
                    label: const Text('冒険を終了する'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.error, width: 1.5),
                      ),
                      textStyle: navConstants.serifTitle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0,
                    ),
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader(BuildContext context, NavigationUiScheme navConstants) {
    if (nextSpot == null) return const SizedBox.shrink();

    final hasStoryName = nextSpot!.aiStoryName.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: navConstants.sepia.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome, color: navConstants.sepia, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextSpot!.name,
                    style: navConstants.serifTitle.copyWith(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasStoryName)
                    Text(
                      nextSpot!.aiStoryName,
                      style: navConstants.serifCaption.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // ミニ進捗バー
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: navConstants.sepia.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(navConstants.sepia),
            minHeight: 6, // 💡 少し太く
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, NavigationUiScheme navConstants) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navConstants.sepia.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navConstants.sepia.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          _buildStatItem(
            navConstants,
            Icons.directions_run_rounded,
            '$steps',
            '歩数',
          ),
          Container(
            height: 40,
            width: 1,
            color: navConstants.sepia.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            navConstants,
            Icons.route_rounded,
            walkedDistanceKm.toStringAsFixed(2),
            'km',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(NavigationUiScheme navConstants, IconData icon, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: navConstants.sepia, size: 28),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: navConstants.serifTitle.copyWith(
                  fontSize: 28, // 💡 さらに大きく
                  fontWeight: FontWeight.bold,
                  color: navConstants.sepia,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: navConstants.serifCaption.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpointTimeline(BuildContext context, NavigationUiScheme navConstants) {
    return Column(
      children: List.generate(allSpots.length, (index) {
        final spot = allSpots[index];
        final isVisited = visitedSpotIds.contains(spot.id);
        final isNext = nextSpot?.id == spot.id;
        final isLast = index == allSpots.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isVisited
                          ? navConstants.sepia
                          : isNext
                              ? navConstants.sepia.withValues(alpha: 0.2)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isVisited || isNext
                            ? navConstants.sepia
                            : navConstants.textMuted.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: isVisited
                        ? Icon(Icons.check, size: 16, color: navConstants.cream)
                        : isNext
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: navConstants.sepia,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isVisited
                            ? navConstants.sepia
                            : navConstants.textMuted.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: navConstants.serifBody.copyWith(
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          fontSize: 18,
                          color: isVisited || isNext
                              ? navConstants.textDark
                              : navConstants.textMuted,
                        ),
                      ),
                      if (spot.aiStoryName.isNotEmpty)
                        Text(
                          spot.aiStoryName,
                          style: navConstants.serifCaption.copyWith(
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
