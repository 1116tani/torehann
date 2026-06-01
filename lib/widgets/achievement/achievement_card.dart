// lib/widgets/achievement/achievement_card.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  // ── 🎁 宝箱を開けるような詳細ダイアログを表示する関数 ──
  void _showAchievementDetail(BuildContext context, bool isUnearned) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colors.surface, // 💡 共通のsurfaceカラー
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colors.primary, width: 1.5), // 金の縁取り
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
                    color: isUnearned ? const Color(0xFFD2C2B2) : const Color(0xFFF5EDD8), // 💡 0xFFB5A189 → 0xFFD2C2B2 (さらに明るく)
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 const SizedBox(height: 12),
                 Divider(color: colors.divider, thickness: 1),
                 const SizedBox(height: 10),
                 // 🎯 解放・達成条件を大きく表示
                 Text(
                   '達成目標: ${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} ${achievement.unit}',
                   style: const TextStyle(
                     color: Color(0xFFE5A93C), // 輝くゴールド
                     fontSize: 15,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1.1,
                   ),
                 ),
                 const SizedBox(height: 10),
                 // 詳細な説明文（宝のフレーバーテキスト風）
                Text(
                  isUnearned
                      ? 'まだ見ぬ冒険の記憶が、ここに刻まれる。\n（条件を満たすと詳細が解放されるよ）'
                      : achievement.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnearned ? const Color(0xFFBCAFA0) : const Color(0xFFC8A97A), // 💡 0xFF9E8E7C → 0xFFBCAFA0 (さらに明るく)
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
      opacity: isUnearned ? 0.85 : 1.0, // 💡 0.6 → 0.85 (明るくして視認性を向上)
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), // 💡 左右マージンを0にして、リスト全体のパディングに委ねることで横幅を広く確保
        decoration: BoxDecoration(
          color: colors.surface, // 💡 共通のsurfaceカラー
          borderRadius: BorderRadius.circular(16), // 💡 角丸を少しリッチに大きく（14 -> 16）
          border: Border.all(
            color: rank != AchievementRank.none
                ? colors.primary
                : colors.border,
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
                                ? const Color(0xFFD2C2B2) // 💡 0xFFB5A189 → 0xFFD2C2B2 (さらに明るく)
                                : const Color(0xFFF5EDD8),
                            fontSize: 16, // 💡 文字を大きく（15 -> 16）
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
                                ? const Color(0xFFBCAFA0) // 💡 0xFF9E8E7C → 0xFFBCAFA0 (さらに明るく)
                                : const Color(0xFFC8A97A),
                            fontSize: 13, // 💡 文字を大きく（12 -> 13）
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14), // 💡 進捗バーとの間隔を広げたよ

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
                                        ? const Color(0xFFA59078) // 💡 0xFF8C765C → 0xFFA59078 (さらに明るく)
                                        : const Color(0xFFC8A97A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // 条件数値 (大きく、明るく表示)
                                Text(
                                  '${achievement.currentCount.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} / '
                                  '${achievement.nextThreshold.toStringAsFixed(achievement.unit == 'km' ? 1 : 0)} '
                                  '${achievement.unit}',
                                  style: TextStyle(
                                    color: isUnearned
                                        ? const Color(0xFFEBE0D0) // 💡 0xFFD7BE96 → 0xFFEBE0D0 (さらに明るい羊皮紙色)
                                        : const Color(0xFFE5A93C), // 解放時：輝く黄金色
                                    fontSize: 14, // 11 -> 14 (スマホで見やすい大きさ)
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
                                minHeight: 7, // 💡 ゲージを少し太くして見やすく（6 -> 7）
                                backgroundColor: const Color(0xFF1C1610),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  rank == AchievementRank.gold
                                      ? const Color(0xFFFFD700)
                                      : const Color(0xFFB8860B),
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