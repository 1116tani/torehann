// lib/widgets/home/home_exp_bar.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

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
    final progress = currentExp / nextLevelExp;

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
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primary,
                size: AppSizes.iconM,
              ),

              const SizedBox(width: AppSizes.p8),

              Text('冒険者ランク', style: AppTextStyles.titleSmall),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p4,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),

                child: Text(
                  'Lv.$level',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryLight,
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
          Text(_getRankName(level), style: AppTextStyles.titleMedium),

          const SizedBox(height: 6),

          Text(_getRankDescription(level), style: AppTextStyles.subtitle),

          const SizedBox(height: AppSizes.p20),

          // ─────────────────────
          // EXP TEXT
          // ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text('次の階級まで', style: AppTextStyles.caption),

              Text(
                '$currentExp / $nextLevelExp EXP',
                style: AppTextStyles.caption,
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
                  widthFactor: progress.clamp(0, 1),

                  child: Container(
                    height: 14,

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
    );
  }

  // ─────────────────────────────
  // ランク名
  // ─────────────────────────────

  String _getRankName(int level) {
    if (level >= 50) {
      return '終焉なき神話の著者';
    }

    if (level >= 40) {
      return '万象の編纂賢者';
    }

    if (level >= 30) {
      return '叙事詩の紡ぎ手';
    }

    if (level >= 20) {
      return '街律の翻訳官';
    }

    if (level >= 10) {
      return '街影の追跡者';
    }

    return '白紙の記録手';
  }

  // ─────────────────────────────
  // ランク説明
  // ─────────────────────────────

  String _getRankDescription(int level) {
    if (level >= 50) {
      return '歩みそのものが世界の神話となる存在';
    }

    if (level >= 40) {
      return '世界の断片を編纂する賢者';
    }

    if (level >= 30) {
      return '歩みを物語へ変える語り部';
    }

    if (level >= 20) {
      return '街に眠る物語を読み解く者';
    }

    if (level >= 10) {
      return '失われた痕跡を追う探索者';
    }

    return 'まだ何も記されていない旅人';
  }
}
