// lib/widgets/navigation/next_spot_header.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';

class NextSpotHeader extends StatelessWidget {
  final SpotModel? nextSpot;
  final String distanceLabel;
  final String durationLabel;

  const NextSpotHeader({
    super.key,
    required this.nextSpot,
    required this.distanceLabel,
    required this.durationLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (nextSpot == null) {
      return const SizedBox.shrink();
    }
    final navConstants = NavigationUiConstants.of(context);

    final title = nextSpot!.aiStoryName.isNotEmpty
        ? nextSpot!.aiStoryName
        : nextSpot!.name;

    return Material(
      color: navConstants.cream,
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: navConstants.creamBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('次のスポット', style: navConstants.serifCaption),
            const SizedBox(height: 4),
            Text(title, style: navConstants.serifTitle),
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.straighten_rounded,
                  label: distanceLabel,
                ),
                const SizedBox(width: 10),
                _InfoChip(
                  icon: Icons.directions_walk_rounded,
                  label: durationLabel,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: navConstants.sepia.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: navConstants.sepia),
          const SizedBox(width: 4),
          Text(label, style: navConstants.serifCaption.copyWith(
            color: navConstants.sepia,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }
}
