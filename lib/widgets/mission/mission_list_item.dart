// lib/widgets/mission/mission_list_item.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/mission_model.dart';
import 'mission_progress_bar.dart';

class MissionListItem extends StatelessWidget {
  final MissionModel mission;
  final VoidCallback? onClaim;

  const MissionListItem({
    super.key,
    required this.mission,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isCompleted = mission.status == MissionStatus.completed;
    final isClaimed = mission.status == MissionStatus.claimed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted
              ? colors.primary
              : colors.border,
          width: isCompleted ? 1.0 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 上部 ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // アイコン
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    mission.icon,
                    color: colors.secondary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // タイトル・説明
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 難易度スター
                      Row(
                        children: List.generate(
                          mission.difficultyStars,
                          (index) => const Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        mission.title,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        mission.description,
                        style: TextStyle(
                          color: colors.secondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // DAILY / WEEKLY
                _TypeBadge(type: mission.type),
              ],
            ),

            const SizedBox(height: 16),

            // ── 報酬 ──────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.border,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: AppColors.warning,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'EXP +${mission.rewardExp}',
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 進捗バー ──────────────────
            MissionProgressBar(
              progress: mission.progressRatio,
              currentValue: mission.currentProgress,
              targetValue: mission.targetProgress,
              unit: mission.unit,
            ),

            const SizedBox(height: 18),

            // ── ボタン ────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCompleted && !isClaimed
                    ? onClaim
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClaimed
                      ? colors.surfaceLight
                      : colors.primary,

                  disabledBackgroundColor: colors.surfaceLight,

                  foregroundColor: isClaimed ? colors.textPrimary : Colors.white,

                  elevation: isCompleted ? 6 : 0,

                  padding: const EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _buttonText(
                    isCompleted: isCompleted,
                    isClaimed: isClaimed,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buttonText({
    required bool isCompleted,
    required bool isClaimed,
  }) {
    if (isClaimed) {
      return '受け取り済み';
    }

    if (isCompleted) {
      return '報酬を受け取る';
    }

    return '進行中';
  }
}

/// ── DAILY / WEEKLY バッジ ─────────────────
class _TypeBadge extends StatelessWidget {
  final MissionType type;

  const _TypeBadge({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDaily = type == MissionType.daily;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDaily
            ? colors.surfaceLight.withValues(alpha: 0.5)
            : colors.surface.withValues(alpha: 0.5),

        borderRadius: BorderRadius.circular(999),

        border: Border.all(
          color: isDaily
              ? AppColors.success
              : colors.primary,
          width: 0.5,
        ),
      ),
      child: Text(
        isDaily ? 'DAILY' : 'WEEKLY',
        style: TextStyle(
          color: isDaily
              ? AppColors.success
              : colors.primary,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}