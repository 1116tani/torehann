// lib/widgets/home/home_rank_badge.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_ranks.dart';

class HomeRankBadge extends StatelessWidget {
  final int level;

  const HomeRankBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final rankData = RankData.getRankData(level);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rankData.color.withValues(alpha: 0.18),
            rankData.color.withValues(alpha: 0.08),
          ],
        ),

        borderRadius: BorderRadius.circular(AppRadius.xl),

        border: Border.all(color: rankData.color.withValues(alpha: 0.28)),

        boxShadow: [
          BoxShadow(
            color: rankData.color.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          // ─────────────────────
          // ICON
          // ─────────────────────
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: rankData.color.withValues(alpha: 0.16),
            ),

            child: Center(
              child: Text(
                rankData.icon,
                style: const TextStyle(fontSize: 22, height: 1),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.p12),

          // ─────────────────────
          // TEXT
          // ─────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                'Lv.$level',

                style: AppTextStyles.caption.copyWith(
                  color: rankData.color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                rankData.title,

                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
