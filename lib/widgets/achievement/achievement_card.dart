// lib/widgets/achievement/achievement_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  // ── 🎁 詳細ダイアログを表示する関数 ──
  void _showAchievementDetail(BuildContext context, bool isUnearned) {
    final colors = AppColors.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colors.primary, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '✦ 勲章 ✦',
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // 大きな未解放／解放アイコン
                Text(
                  isUnearned ? '🔒' : '🏅',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                // 詳細タイトルの表示
                Text(
                  isUnearned ? '？？？' : achievement.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnearned ? colors.textDisabled : colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isUnearned && achievement.unlockedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(achievement.unlockedAt!)} 解除',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: 10),
                // 🎯 解放・達成条件を表示
                Text(
                  '達成目標: ${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} ${achievement.unit}',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                // 詳細な説明文
                Text(
                  isUnearned
                      ? '未だ解除されていない実績です。\n条件を満たすと詳細が解放されます。'
                      : achievement.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnearned ? colors.textMuted : colors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // 閉じるボタン
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.background,
                      foregroundColor: colors.secondary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('閉じる', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final rank = achievement.currentRank;
    final isUnearned = !achievement.isUnlocked;

    // ── ランク別カラー設定 ──
    Color medalColor;
    String medalText;

    if (isUnearned) {
      medalColor = colors.textDisabled;
      medalText = '🔒';
    } else {
      switch (rank) {
        case AchievementRank.copper:
          medalColor = AppColors.bronze;
          medalText = '銅';
          break;
        case AchievementRank.silver:
          medalColor = AppColors.silver;
          medalText = '銀';
          break;
        case AchievementRank.gold:
          medalColor = AppColors.gold;
          medalText = '金';
          break;
        case AchievementRank.none:
          medalColor = colors.textDisabled;
          medalText = '🔒';
          break;
      }
    }

    return Opacity(
      opacity: isUnearned ? 0.85 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: !isUnearned ? colors.primary : colors.border,
            width: !isUnearned ? 1.2 : 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.textPrimary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showAchievementDetail(context, isUnearned),
            splashColor: medalColor.withValues(alpha: 0.1),
            highlightColor: colors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Medal ──
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: medalColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: medalColor,
                        width: 2,
                      ),
                      boxShadow: !isUnearned
                          ? [
                              BoxShadow(
                                color: medalColor.withValues(alpha: 0.25),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        medalText,
                        style: TextStyle(
                          color: medalColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // ── Main Content ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // タイトル
                        Text(
                          isUnearned ? '？？？' : achievement.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnearned
                                ? colors.textDisabled
                                : colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // 説明文
                        Text(
                          isUnearned
                              ? '？？？'
                              : achievement.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnearned
                                ? colors.textMuted
                                : colors.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        if (!isUnearned && achievement.unlockedAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${achievement.unlockedAt!.year}/${achievement.unlockedAt!.month.toString().padLeft(2, '0')}/${achievement.unlockedAt!.day.toString().padLeft(2, '0')}解除',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // ── Progress Area ──
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isUnearned ? '未解放の試練' : '進行中',
                                  style: TextStyle(
                                    color: isUnearned
                                        ? colors.textMuted
                                        : colors.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // 条件数値
                                Text(
                                  '${achievement.currentCount.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} / '
                                  '${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} '
                                  '${achievement.unit}',
                                  style: TextStyle(
                                    color: isUnearned
                                        ? colors.textSecondary
                                        : colors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: achievement.progressRatio,
                                minHeight: 7,
                                backgroundColor: colors.divider,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  rank == AchievementRank.gold
                                      ? AppColors.gold
                                      : colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}