// lib/widgets/collection/fragment_grid_item.dart

import 'package:flutter/material.dart';
import '../../models/fragment_model.dart';
import '../../providers/collection_provider.dart';

class FragmentGridItem extends StatelessWidget {
  final CollectionItemUIModel item; // 👈 修正したUI用モデルに変更

  const FragmentGridItem({super.key, required this.item});

  /// レアリティに応じた枠やフォントの色を返すよ
  Color _getRarityColor() {
    if (!item.isUnlocked) return const Color(0xFF5C4033); // 未取得はくすんだ木の色
    switch (item.rarity) {
      case FragmentRarity.normal:
        return const Color(0xFFC8A97A); // ノーマルは暖かみのある木漏れ日色
      case FragmentRarity.rare:
        return const Color(0xFF6B9EE1); // レアは街の風景に溶け込む神秘的なブルー
      case FragmentRarity.legend:
        return const Color(0xFFFFD700); // レジェンドは物語を彩る黄金色
    }
  }

  /// 宝物の詳細を表示するダイアログだよ
  void _showItemDetails(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '閉じる',
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2318), // 落ち着いたブラウン
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getRarityColor(), width: item.isUnlocked ? 2 : 1),
                boxShadow: item.isUnlocked
                    ? [
                        BoxShadow(
                          color: _getRarityColor().withOpacity(0.3),
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
                      color: item.isUnlocked ? _getRarityColor() : const Color(0xFF7A5C3A),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 📊 進捗・レアリティバッジ表示
                  _buildSubTitle(),
                  const Divider(
                    color: Color(0xFF5C4033),
                    height: 32,
                    thickness: 1,
                  ),

                  // 💡 段階解放テキスト部分
                  if (!item.isUnlocked) ...[
                    // 未取得時のメッセージ（お散歩へのモチベーションを高めるよ！）
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        item.rarity == FragmentRarity.rare
                            ? 'まだ見ぬ街の記憶。どうやら「${item.conditionHint}」の近くで気配を感じるようだ……。'
                            : 'まだ見ぬ日常の断片。街を歩き回ることで、ふと見つかるかもしれない。',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7A5C3A),
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
                              color: isUnlocked ? _getRarityColor() : const Color(0xFF5C4033),
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
                                      color: isUnlocked ? const Color(0xFFF5EDD8) : const Color(0xFF5C4033),
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
                                        style: const TextStyle(
                                          color: Color(0xFF8B7355),
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
                      backgroundColor: const Color(0xFF4A3728),
                      foregroundColor: const Color(0xFFC8A97A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
  Widget _buildSubTitle() {
    if (!item.isUnlocked) {
      return const Text(
        '【 未獲得 】',
        style: TextStyle(color: Color(0xFF7A5C3A), fontSize: 13),
      );
    }
    if (item.rarity == FragmentRarity.legend) {
      return const Text(
        '【 レジェンド・物語の完結 】',
        style: TextStyle(color: Color(0xFFFFD700), fontSize: 13, fontWeight: FontWeight.bold),
      );
    }
    return Text(
      '収集状況: ${item.progressString} （総所持数: ${item.currentCount}個）',
      style: const TextStyle(color: Color(0xFFC8A97A), fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showItemDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1610),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getRarityColor(),
            width: item.isUnlocked ? 1.5 : 0.5,
          ),
          boxShadow: item.isUnlocked
              ? [
                  BoxShadow(
                    color: _getRarityColor().withOpacity(0.15),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // 💎 中央のアイコン（未取得なら「？」、取得済みならキラリと光るダイヤアイコン）
            Center(
              child: Icon(
                item.isUnlocked ? Icons.diamond_outlined : Icons.question_mark_rounded,
                color: _getRarityColor().withOpacity(item.isUnlocked ? 1.0 : 0.2),
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
                  color: item.isUnlocked ? const Color(0xFFF5EDD8) : const Color(0xFF5C4033),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 🔢 右上のスタック数バッジ（レジェンド以外の取得済みアイテムのみ表示）
            if (item.isUnlocked && item.rarity != FragmentRarity.legend)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A3728),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _getRarityColor(), width: 0.5),
                  ),
                  child: Text(
                    'x${item.currentCount}',
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
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