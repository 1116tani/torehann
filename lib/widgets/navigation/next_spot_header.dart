// lib/widgets/navigation/next_spot_header.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';

class NextSpotHeader extends StatelessWidget {
  final SpotModel? nextSpot;
  final String distanceLabel;
  final String durationLabel;
  final double walkedDistanceKm;
  final int steps;

  const NextSpotHeader({
    super.key,
    required this.nextSpot,
    required this.distanceLabel,
    required this.durationLabel,
    required this.walkedDistanceKm,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    if (nextSpot == null) {
      return const SizedBox.shrink();
    }
    final navConstants = NavigationUiConstants.of(context);

    final hasStoryName = nextSpot!.aiStoryName.isNotEmpty;
    final title = hasStoryName ? nextSpot!.aiStoryName : nextSpot!.name;

    return Material(
      color: navConstants.cream,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: navConstants.creamBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('次のスポット', style: navConstants.serifCaption.copyWith(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              title,
              style: navConstants.serifTitle.copyWith(fontSize: 22),
            ),
            if (hasStoryName) ...[
              const SizedBox(height: 2),
              Text(
                '（${nextSpot!.name}）',
                style: navConstants.serifCaption.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.straighten_rounded,
                  label: '残り $distanceLabel',
                ),
                _InfoChip(
                  icon: Icons.directions_walk_rounded,
                  label: '約 $durationLabel',
                ),
                _InfoChip(
                  icon: Icons.route_rounded,
                  label: '${walkedDistanceKm.toStringAsFixed(2)} km',
                ),
                _InfoChip(
                  icon: Icons.directions_run_rounded,
                  label: '$steps 歩',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final navConstants = NavigationUiConstants.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: navConstants.sepia.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: navConstants.sepia),
          const SizedBox(width: 6),
          Text(
            label,
            style: navConstants.serifCaption.copyWith(
              color: navConstants.sepia,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
