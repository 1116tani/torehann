// lib/widgets/achievement/achievement_card.dart

import 'package:flutter/material.dart';
import '../../providers/achievement_provider.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final rank = achievement.currentRank;
    final isUnearned =
        rank == AchievementRank.none && achievement.currentCount == 0;

    // ランクに応じたメダルの色とテキストを決めるよ
    Color medalColor = Colors.grey;
    String medalText = '未';
    if (rank == AchievementRank.copper) {
      medalColor = const Color(0xFFCD7F32);
      medalText = '銅';
    }
    if (rank == AchievementRank.silver) {
      medalColor = const Color(0xFFC0C0C0);
      medalText = '銀';
    }
    if (rank == AchievementRank.gold) {
      medalColor = const Color(0xFFFFD700);
      medalText = '金';
    }

    return ColorFiltered(
      // 💡 仕様：完全未達成（カウントが0）なら、全体をセピア・グレーアウト調にする魔法のフィルターだよ！
      colorFilter: isUnearned
          ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2318), // 統一された渋ブラウン
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: rank != AchievementRank.none
                ? const Color(0xFFB8860B)
                : const Color(0xFF5C4033),
            width: rank != AchievementRank.none ? 1.0 : 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 🏅 実績のメダルバッジ部分 ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: medalColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: medalColor, width: 2),
                boxShadow: rank != AchievementRank.none
                    ? [
                        BoxShadow(
                          color: medalColor.withValues(alpha: 0.3),
                          blurRadius: 6,
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
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── 📝 テキスト ＆ 進捗バー部分 ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 実績タイトル（💡 未達成なら「？？？」にする遊び心！）
                  Text(
                    isUnearned ? '？？？？？？' : achievement.title,
                    style: TextStyle(
                      color: isUnearned
                          ? const Color(0xFF7A5C3A)
                          : const Color(0xFFF5EDD8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 実績説明文（💡 未達成なら隠しちゃう！）
                  Text(
                    isUnearned
                        ? 'まだ見ぬ冒険の記憶が、ここに刻まれる。'
                        : achievement.description,
                    style: TextStyle(
                      color: isUnearned
                          ? const Color(0xFF5C422A)
                          : const Color(0xFFC8A97A),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── 📊 進捗バー ＆ 数値 ──
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: achievement.progressRatio,
                            backgroundColor: const Color(0xFF1C1610),
                            // 金ランク達成なら輝くゴールド、それ以外はアンティークゴールド
                            valueColor: AlwaysStoppedAnimation<Color>(
                              rank == AchievementRank.gold
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFFB8860B),
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 数値表示（例：3.0 / 10.0 回）
                      Text(
                        '${achievement.currentCount.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} / '
                        '${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} '
                        '${achievement.unit}',
                        style: const TextStyle(
                          color: Color(0xFF7A5C3A),
                          fontSize: 10,
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
      ),
    );
  }
}
