// lib/widgets/home/home_rank_badge.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class HomeRankBadge extends StatelessWidget {
  final int level;

  const HomeRankBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final rankData = _getRankData(level);

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

            child: Icon(rankData.icon, color: rankData.color, size: 22),
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

  // ─────────────────────────────
  // RANK DATA
  // ─────────────────────────────

  _RankData _getRankData(int level) {
    if (level >= 50) {
      return _RankData(
        title: '神話の著者',
        color: AppColors.gold,
        icon: Icons.auto_awesome_rounded,
      );
    }

    if (level >= 40) {
      return _RankData(
        title: '編纂賢者',
        color: const Color(0xFFD7DDE8),
        icon: Icons.menu_book_rounded,
      );
    }

    if (level >= 30) {
      return _RankData(
        title: '叙事詩の紡ぎ手',
        color: const Color(0xFF7FA8D1),
        icon: Icons.history_edu_rounded,
      );
    }

    if (level >= 20) {
      return _RankData(
        title: '街律の翻訳官',
        color: const Color(0xFF7BC6B8),
        icon: Icons.travel_explore_rounded,
      );
    }

    if (level >= 10) {
      return _RankData(
        title: '街影の追跡者',
        color: AppColors.secondary,
        icon: Icons.explore_rounded,
      );
    }

    return _RankData(
      title: '白紙の記録手',
      color: const Color(0xFFB58A5A),
      icon: Icons.edit_note_rounded,
    );
  }
}

// ─────────────────────────────
// MODEL
// ─────────────────────────────

class _RankData {
  final String title;

  final Color color;

  final IconData icon;

  const _RankData({
    required this.title,
    required this.color,
    required this.icon,
  });
}
