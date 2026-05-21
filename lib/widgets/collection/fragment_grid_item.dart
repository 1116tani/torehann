// lib/widgets/collection/fragment_grid_item.dart

import 'package:flutter/material.dart';
import '../../providers/collection_provider.dart';

class FragmentGridItem extends StatelessWidget {
  final CollectionItemModel item;

  const FragmentGridItem({super.key, required this.item});

  // レアリティに応じた枠の色を返すよ
  Color _getRarityColor() {
    if (!item.isUnlocked) return const Color(0xFF5C4033); // 未取得は暗い茶色
    switch (item.rarity) {
      case ItemRarity.normal:
        return const Color(0xFFC8A97A);
      case ItemRarity.rare:
        return const Color(0xFF9370DB); // レアは神秘的な紫
      case ItemRarity.legend:
        return const Color(0xFFFFD700); // レジェンドは黄金
    }
  }

  // ダイアログを表示する魔法のメソッド
  void _showItemDetails(BuildContext context) {
    if (!item.isUnlocked) return; // 未取得なら開かせないよ！(ちょっといじわる♡)

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '閉じる',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2318),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getRarityColor(), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _getRarityColor().withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // アイテム名とレアリティ
                  Text(
                    item.name,
                    style: TextStyle(
                      color: _getRarityColor(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.rarity == ItemRarity.legend
                        ? '【 レジェンド 】'
                        : '所持数：${item.currentCount}個',
                    style: const TextStyle(
                      color: Color(0xFFC8A97A),
                      fontSize: 14,
                    ),
                  ),
                  const Divider(
                    color: Color(0xFF5C4033),
                    height: 32,
                    thickness: 1,
                  ),

                  // 💡 ここがみぃくんこだわりの段階解放テキスト！
                  if (item.rarity == ItemRarity.legend) ...[
                    // レジェンドは一発で全文表示
                    Text(
                      item.legendDescription!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 15,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ] else ...[
                    // ノーマルとレアの段階表示
                    ...List.generate(item.descriptions.length, (index) {
                      final isUnlocked = item.isStageUnlocked(index);
                      final threshold = item.unlockThresholds[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔓 か 🔒 のアイコン
                            Icon(
                              isUnlocked ? Icons.lock_open : Icons.lock,
                              color: isUnlocked
                                  ? _getRarityColor()
                                  : Colors.grey.shade700,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUnlocked
                                        ? item.descriptions[index]
                                        : '？？？？？？（スタック $threshold で解放）',
                                    style: TextStyle(
                                      color: isUnlocked
                                          ? const Color(0xFFF5EDD8)
                                          : Colors.grey.shade600,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  // まだ解放されていない場合、あと何個必要か出す優しい配慮
                                  if (!isUnlocked &&
                                      index > 0 &&
                                      item.isStageUnlocked(index - 1))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'あと ${threshold - item.currentCount} 個で解放',
                                        style: const TextStyle(
                                          color: Color(0xFFB8860B),
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
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3728),
                      foregroundColor: const Color(0xFFC8A97A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('本を閉じる'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                    color: _getRarityColor().withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // 中央のアイコン表示（今回はIconで代用するけど、本番は画像を使ってもいいね！）
            Center(
              child: Icon(
                item.isUnlocked ? Icons.diamond_outlined : Icons.question_mark,
                color: _getRarityColor().withValues(
                  alpha: item.isUnlocked ? 1.0 : 0.3,
                ),
                size: 40,
              ),
            ),

            // アイテム名（未取得なら？？？）
            Positioned(
              bottom: 8,
              left: 4,
              right: 4,
              child: Text(
                item.isUnlocked ? item.name : '？？？',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: item.isUnlocked
                      ? const Color(0xFFF5EDD8)
                      : const Color(0xFF5C4033),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 右上のバッジ（スタック数）
            if (item.isUnlocked && item.rarity != ItemRarity.legend)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A3728),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _getRarityColor(), width: 1),
                  ),
                  child: Text(
                    'x${item.currentCount}',
                    style: const TextStyle(
                      color: Colors.white,
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
