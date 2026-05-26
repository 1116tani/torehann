// lib/widgets/achievement/achievement_card.dart

import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  // ── 🎁 宝箱を開けるような詳細ダイアログを表示する関数 ──
  void _showAchievementDetail(BuildContext context, bool isUnearned) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF2C2318), // 渋ブラウン
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFB8860B), width: 1.5), // 金の縁取り
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 中身のサイズに合わせるよ
              children: [
                const Text(
                  '✦ 勲章 ✦',
                  style: TextStyle(
                    color: Color(0xFFC8A97A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // 大きな未解放／解放アイコン
                Text(
                  isUnearned ? '❓' : '🏅',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                // 詳細タイトルの表示
                Text(
                  isUnearned ? '？？？？？？' : achievement.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnearned ? const Color(0xFF7A5C3A) : const Color(0xFFF5EDD8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF5C4033), thickness: 1),
                const SizedBox(height: 12),
                // 詳細な説明文（宝のフレーバーテキスト風）
                Text(
                  isUnearned
                      ? 'まだ見ぬ冒険の記憶が、ここに刻まれる。\n（条件を満たすと詳細が解放されるよ）'
                      : achievement.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnearned ? const Color(0xFF5C422A) : const Color(0xFFC8A97A),
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
                      backgroundColor: const Color(0xFF1C1610),
                      foregroundColor: const Color(0xFFC8A97A),
                      side: const BorderSide(color: Color(0xFF5C4033)),
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
    final rank = achievement.currentRank;

    final isUnearned =
        rank == AchievementRank.none && achievement.currentCount == 0;

    // ── ランク別カラー設定 ──
    Color medalColor;
    String medalText;

    switch (rank) {
      case AchievementRank.copper:
        medalColor = const Color(0xFFCD7F32);
        medalText = '銅';
        break;
      case AchievementRank.silver:
        medalColor = const Color(0xFFC0C0C0);
        medalText = '銀';
        break;
      case AchievementRank.gold:
        medalColor = const Color(0xFFFFD700);
        medalText = '金';
        break;
      case AchievementRank.none:
        medalColor = const Color(0xFF6B6B6B);
        medalText = '?';
        break;
    }

    return Opacity(
      opacity: isUnearned ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 💡 縦の隙間を少し広げたよ
        decoration: BoxDecoration(
          color: const Color(0xFF2C2318),
          borderRadius: BorderRadius.circular(16), // 💡 角丸を少しリッチに大きく（14 -> 16）
          border: Border.all(
            color: rank != AchievementRank.none
                ? const Color(0xFFB8860B)
                : const Color(0xFF5C4033),
            width: rank != AchievementRank.none ? 1.2 : 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3), // 💡 影を少し強めて立体感アップ！
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // 💡 タップエフェクトを綺麗に出すためにMaterialとInkWellで包むよ
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showAchievementDetail(context, isUnearned), // 👈 タップで詳細を呼ぶ！
            splashColor: medalColor.withValues(alpha: 0.1), // ランクに応じた色の光が広がるよ♡
            highlightColor: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(18), // 💡 パディングを大幅アップ！（14 -> 18）これでカードが大きくなるよ！
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Medal ──
                  Container(
                    width: 52, // 💡 メダルを一回り大きくしたよ！（46 -> 52）
                    height: 52,
                    decoration: BoxDecoration(
                      color: medalColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: medalColor,
                        width: 2,
                      ),
                      boxShadow: rank != AchievementRank.none
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
                          fontSize: 16, // 💡 文字も少し大きく（14 -> 16）
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // 💡 隙間もゆったり（14 -> 16）

                  // ── Main Content ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // タイトル
                        Text(
                          isUnearned ? '？？？？？？' : achievement.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnearned
                                ? const Color(0xFF7A5C3A)
                                : const Color(0xFFF5EDD8),
                            fontSize: 15, // 💡 文字を大きく（14 -> 15）
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // 説明文
                        Text(
                          isUnearned
                              ? 'まだ見ぬ冒険の記憶が、ここに刻まれる。'
                              : achievement.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnearned
                                ? const Color(0xFF5C422A)
                                : const Color(0xFFC8A97A),
                            fontSize: 12, // 💡 文字を大きく（11 -> 12）
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14), // 💡 進捗バーとの間隔を広げたよ

                        // ── Progress Area ──
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: achievement.progressRatio,
                                  minHeight: 7, // 💡 ゲージを少し太くして見やすく（6 -> 7）
                                  backgroundColor: const Color(0xFF1C1610),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    rank == AchievementRank.gold
                                        ? const Color(0xFFFFD700)
                                        : const Color(0xFFB8860B),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 数値
                            Text(
                              '${achievement.currentCount.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} / '
                              '${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} '
                              '${achievement.unit}',
                              style: const TextStyle(
                                color: Color(0xFF7A5C3A),
                                fontSize: 11, // 💡 文字を大きく（10 -> 11）
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
          ),
        ),
      ),
    );
  }
}