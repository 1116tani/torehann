// lib/widgets/navigation/next_spot_header.dart

import 'package:flutter/material.dart';

import '../../constants/navigation_ui_constants.dart';
import '../../models/spot_model.dart';
import '../../models/walking_leg_result.dart';

class NextSpotHeader extends StatelessWidget {
  final SpotModel? nextSpot;
  final String distanceLabel;
  final String durationLabel;
  final List<RouteStep> steps;

  const NextSpotHeader({
    super.key,
    required this.nextSpot,
    required this.distanceLabel,
    required this.durationLabel,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    if (nextSpot == null) {
      return const SizedBox.shrink();
    }
    final navConstants = NavigationUiConstants.of(context);

    // 次の案内（最初のステップ）
    final nextStep = steps.isNotEmpty ? steps.first : null;
    final instruction = nextStep?.instruction ?? '目的地へ進む';
    final stepDistance = nextStep != null ? '${nextStep.distanceMeters}m先 ' : '';

    return Material(
      color: navConstants.cream,
      elevation: 8,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: navConstants.creamBorder, width: 1.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              navConstants.cream,
              navConstants.cream.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: navConstants.sepia,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getInstructionIcon(instruction),
                    color: navConstants.cream,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$stepDistance$instruction',
                        style: navConstants.serifTitle.copyWith(
                          fontSize: 20,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            size: 14,
                            color: navConstants.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '残り $distanceLabel',
                            style: navConstants.serifCaption.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: navConstants.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '約 $durationLabel',
                            style: navConstants.serifCaption.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getInstructionIcon(String instruction) {
    if (instruction.contains('右')) return Icons.turn_right_rounded;
    if (instruction.contains('左')) return Icons.turn_left_rounded;
    if (instruction.contains('直進')) return Icons.straight_rounded;
    if (instruction.contains('北')) return Icons.north_rounded;
    if (instruction.contains('南')) return Icons.south_rounded;
    if (instruction.contains('東')) return Icons.east_rounded;
    if (instruction.contains('西')) return Icons.west_rounded;
    return Icons.navigation_rounded;
  }
}
