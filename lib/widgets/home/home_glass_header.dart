// lib/widgets/home/home_glass_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_ranks.dart';
import '../../providers/user_provider.dart';

import '../common/glass_card.dart';

class HomeGlassHeader extends ConsumerWidget {
  const HomeGlassHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final name = userState.name.isEmpty ? '無名の旅人' : userState.name;

    // 現在のレベル設定（実データ導入まではモックレベルとして24を使用します）
    const level = 24;
    const currentExp = 2450;
    const nextLevelExp = 3000;
    final progress = currentExp / nextLevelExp;

    final rankData = RankData.getRankData(level);

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
                    colors: [rankData.color, rankData.color.withValues(alpha: 0.6)],
                  ),

                  border: Border.all(
                    color: rankData.color.withValues(alpha: 0.4),
                  ),
                ),

                child: Icon(
                  rankData.icon,
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
                    Text(
                      name,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      rankData.title,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: rankData.color,
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
                  color: rankData.color.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(AppRadius.lg),

                  border: Border.all(
                    color: rankData.color.withValues(alpha: 0.24),
                  ),
                ),

                child: Column(
                  children: [
                    Text(
                      'Lv',
                      style: AppTextStyles.caption.copyWith(
                        color: rankData.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '$level',
                      style: AppTextStyles.statMedium.copyWith(
                        color: rankData.color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
                  Text('次の階級への断片', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),

                  Text(
                    '$currentExp / $nextLevelExp EXP',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(999),

                child: Stack(
                  children: [
                    Container(height: 10, color: AppColors.surfaceLight),

                    FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),

                      child: Container(
                        height: 10,

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [rankData.color.withValues(alpha: 0.5), rankData.color],
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
