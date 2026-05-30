// lib/widgets/home/home_exp_bar.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_ranks.dart';

class HomeExpBar extends StatelessWidget {
  final int currentExp;
  final int nextLevelExp;
  final int level;

  const HomeExpBar({
    super.key,
    required this.currentExp,
    required this.nextLevelExp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final progress = nextLevelExp > 0 ? currentExp / nextLevelExp : 1.0;
    final rankData = RankData.getRankData(level);

    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),

      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),

        borderRadius: BorderRadius.circular(AppRadius.xl),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ─────────────────────
          // HEADER
          // ─────────────────────
          Row(
            children: [
              Text(
                rankData.icon,
                style: const TextStyle(fontSize: 24, height: 1),
              ),

              const SizedBox(width: AppSizes.p8),

              Text('調査員階級', style: AppTextStyles.titleSmall),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p4,
                ),

                decoration: BoxDecoration(
                  color: rankData.color.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: rankData.color.withValues(alpha: 0.2),
                  ),
                ),

                child: Text(
                  'Lv.$level',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: rankData.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.p16),

          // ─────────────────────
          // RANK NAME
          // ─────────────────────
          Text(
            '${rankData.title} / ${rankData.englishTitle}',
            style: AppTextStyles.titleMedium.copyWith(color: rankData.color),
          ),

          const SizedBox(height: 6),

          Text(
            rankData.description,
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSizes.p20),

          // ─────────────────────
          // EXP TEXT
          // ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                '次の階級への断片',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              Text(
                level >= 100 ? 'MAX' : '$currentExp / $nextLevelExp EXP',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ─────────────────────
          // EXP BAR
          // ─────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(999),

            child: Stack(
              children: [
                Container(
                  height: 14,

                  decoration: BoxDecoration(color: AppColors.surfaceLight),
                ),

                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0).toDouble(),

                  child: Container(
                    height: 14,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: rankData.gradientColors,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
