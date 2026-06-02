// lib/widgets/collection/fragment_grid_item.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/fragment_model.dart';
import '../../providers/collection_provider.dart';

class FragmentGridItem extends StatelessWidget {
  final CollectionItemUIModel item;

  const FragmentGridItem({super.key, required this.item});

  /// レアリティに応じた枠やフォントの色を返すよ
  Color _getRarityColor(BuildContext context) {
    final colors = AppColors.of(context);
    if (!item.isUnlocked) return colors.border; // 未取得はボーダー色
    switch (item.rarity) {
      case FragmentRarity.normal:
        return const Color(0xFFC8A97A); // ノーマル
      case FragmentRarity.rare:
        return const Color(0xFF6B9EE1); // レア
      case FragmentRarity.legend:
        return AppColors.gold; // レジェンド
    }
  }

  /// 宝物の詳細を表示するダイアログだよ
  void _showItemDetails(BuildContext context) {
    final colors = AppColors.of(context);
    final rarityColor = _getRarityColor(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '閉じる',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rarityColor, width: item.isUnlocked ? 2 : 1),
                boxShadow: item.isUnlocked
                    ? [
                        BoxShadow(
                          color: rarityColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🏷️ アイテム名（未取得なら ？？？ 表示）
                  Text(
                    item.isUnlocked ? item.name : '？？？',
                    style: TextStyle(
                      color: item.isUnlocked ? rarityColor : colors.textMuted,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 📊 進捗・レアリティバッジ表示
                  _buildSubTitle(context),
                  Divider(
                    color: colors.divider,
                    height: 32,
                    thickness: 1,
                  ),

                  // 💡 段階解放テキスト部分
                  if (!item.isUnlocked) ...[
                    // 未取得時のメッセージ
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        item.rarity == FragmentRarity.rare
                            ? 'まだ見ぬ街の記憶。どうやら「${item.conditionHint}」の近くで気配を感じるようだ……。'
                            : 'まだ見ぬ日常の断片。街を歩き回ることで、ふと見つかるかもしれない。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 14,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ] else ...[
                    // 解放済みの時の段階テキスト表示
                    ...List.generate(item.descriptions.length, (index) {
                      final isUnlocked = item.isStageUnlocked(index);
                      final threshold = item.thresholds[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔓 / 🔒 アイコンの表示
                            Icon(
                              isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                              color: isUnlocked ? rarityColor : colors.textDisabled,
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUnlocked ? item.descriptions[index] : '？？？？？？',
                                    style: TextStyle(
                                      color: isUnlocked ? colors.textPrimary : colors.textDisabled,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  // あと何個で次のテキストが開くかの優しい案内
                                  if (!isUnlocked && index > 0 && item.isStageUnlocked(index - 1))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'あと ${threshold - item.currentCount} 個スタックで解放',
                                        style: TextStyle(
                                          color: colors.secondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 16),
                  
                  // 🚪 閉じるボタン
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.surfaceLight,
                      foregroundColor: colors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: colors.border),
                      ),
                    ),
                    child: const Text('図鑑を閉じる'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ダイアログのサブタイトル部分を生成するよ
  Widget _buildSubTitle(BuildContext context) {
    final colors = AppColors.of(context);
    if (!item.isUnlocked) {
      return Text(
        '【 未獲得 】',
        style: TextStyle(color: colors.textMuted, fontSize: 13),
      );
    }
    if (item.rarity == FragmentRarity.legend) {
      return const Text(
        '【 レジェンド・物語の完結 】',
        style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.bold),
      );
    }
    return Text(
      '収集状況: ${item.progressString} （総所持数: ${item.currentCount}個）',
      style: TextStyle(color: colors.secondary, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final rarityColor = _getRarityColor(context);

    return GestureDetector(
      onTap: () => _showItemDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rarityColor,
            width: item.isUnlocked ? 1.5 : 0.5,
          ),
          boxShadow: item.isUnlocked
              ? [
                  BoxShadow(
                    color: rarityColor.withValues(alpha: 0.15),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // 💎 中央のアイコン
            Center(
              child: Icon(
                item.isUnlocked ? Icons.diamond_outlined : Icons.question_mark_rounded,
                color: rarityColor.withValues(alpha: item.isUnlocked ? 1.0 : 0.2),
                size: 36,
              ),
            ),

            // 📝 下部に表示するアイテム名
            Positioned(
              bottom: 8,
              left: 4,
              right: 4,
              child: Text(
                item.isUnlocked ? item.name : '？？？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: item.isUnlocked ? colors.textPrimary : colors.textDisabled,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔢 右上のスタック数バッジ
            if (item.isUnlocked && item.rarity != FragmentRarity.legend)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: rarityColor, width: 0.5),
                  ),
                  child: Text(
                    'x${item.currentCount}',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
