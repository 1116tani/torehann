// lib/widgets/home/home_glass_header.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../common/glass_card.dart';

class HomeGlassHeader extends StatelessWidget {
  const HomeGlassHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: AppRadius.xl,
      opacity: 0.08,

      padding: const EdgeInsets.all(AppSizes.p16),

      child: Column(
        children: [
          // ─────────────────────
          // 👤 上段
          // ─────────────────────
          Row(
            children: [
              // Avatar
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),

                  border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.4),
                  ),
                ),

                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.textDark,
                  size: 28,
                ),
              ),

              const SizedBox(width: AppSizes.p16),

              // Name & Rank
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('ユーザー', style: AppTextStyles.titleSmall),

                    const SizedBox(height: 4),

                    Text(
                      '街律の翻訳官',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Level
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p8,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(AppRadius.lg),

                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.24),
                  ),
                ),

                child: Column(
                  children: [
                    Text(
                      'Lv',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),

                    Text('24', style: AppTextStyles.statMedium),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.p20),

          // ─────────────────────
          // ✨ EXP BAR
          // ─────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text('次の階級まで', style: AppTextStyles.caption),

                  Text('2,450 / 3,000 EXP', style: AppTextStyles.caption),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(999),

                child: Stack(
                  children: [
                    Container(height: 10, color: AppColors.surfaceLight),

                    FractionallySizedBox(
                      widthFactor: 0.81,

                      child: Container(
                        height: 10,

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryLight, AppColors.primary],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
