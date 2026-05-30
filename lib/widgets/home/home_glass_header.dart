// lib/widgets/home/home_glass_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_ranks.dart';
import '../../providers/level_provider.dart';
import '../../providers/settings_provider.dart';

import '../common/glass_card.dart';

class HomeGlassHeader extends ConsumerStatefulWidget {
  const HomeGlassHeader({super.key});

  @override
  ConsumerState<HomeGlassHeader> createState() => _HomeGlassHeaderState();
}

class _HomeGlassHeaderState extends ConsumerState<HomeGlassHeader> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final levelState = ref.watch(levelProvider);
    final name = settings.userName.isEmpty ? '無名の旅人' : settings.userName;
    final level = levelState.level;
    final currentExp = levelState.currentLevelXp;
    final nextLevelExp = levelState.nextLevelXp;
    final remainingExp =
        (nextLevelExp - currentExp).clamp(0, nextLevelExp).toInt();
    final progress = nextLevelExp > 0 ? levelState.progress : 1.0;
    final rankData = RankData.getRankData(level);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: GlassCard(
        borderRadius: AppRadius.xl,
        opacity: 0.08,
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: rankData.gradientColors),
                    border: Border.all(
                      color: rankData.color.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    rankData.icon,
                    style: const TextStyle(fontSize: 28, height: 1),
                  ),
                ),

                const SizedBox(width: AppSizes.p16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        rankData.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: rankData.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  constraints: const BoxConstraints(minWidth: 58),
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

            const SizedBox(height: AppSizes.p16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        level >= 100
                            ? '街の物語を記録中'
                            : '次のレベルまで あと$remainingExp EXP',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: rankData.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSizes.p8),

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

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Stack(
                    children: [
                      Container(height: 10, color: AppColors.surfaceLight),

                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0).toDouble(),
                        child: Container(
                          height: 10,
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

            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _RankDetails(rankData: rankData),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
              sizeCurve: Curves.easeOutCubic,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankDetails extends StatelessWidget {
  final RankData rankData;

  const _RankDetails({required this.rankData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.p16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.p12),
        decoration: BoxDecoration(
          color: rankData.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: rankData.color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rankData.englishTitle,
              style: AppTextStyles.caption.copyWith(
                color: rankData.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              rankData.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
