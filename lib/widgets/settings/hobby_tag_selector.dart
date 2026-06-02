// lib/widgets/settings/hobby_tag_selector.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HobbyTagSelector extends StatelessWidget {
  final List<String> selectedTags; // 選択中のタグ一覧
  final Function(String) onToggle; // タグをタップした時の処理
  final int maxTags; // 💡 追加：AIが迷子にならないための上限数！

  const HobbyTagSelector({
    super.key,
    required this.selectedTags,
    required this.onToggle,
    this.maxTags = 5, // デフォルトは5個までにするね
  });

  // 選べるタグの一覧
  static const _allTags = [
    ('☕', 'カフェ'),
    ('⛩️', '神社'),
    ('🌳', '公園'),
    ('🏮', '路地裏'),
    ('🛒', 'コンビニ'),
    ('📚', '本屋'),
    ('🍜', '飲食店'),
    ('🎨', 'ギャラリー'),
    ('🏛️', '史跡'),
    ('🌸', '花スポット'),
    ('🌊', '川・水辺'),
    ('🏪', '商店街'),
    ('🎭', '劇場・ライブ'),
    ('🌆', '夜景スポット'),
    ('🍞', 'パン屋'),
    ('🎮', 'ゲームセンター'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // 💡 上限に達しているかどうかをチェック！
    final isMaxReached = selectedTags.length >= maxTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 選択数の表示 ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '好みの属性を刻む（最大$maxTags個）', // 💡 世界観に合わせて少しリッチな表現に
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${selectedTags.length} / $maxTags',
              style: TextStyle(
                // 上限に達したら少し色を変えてお知らせするよ
                color: isMaxReached ? colors.primary : colors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── タグのグリッド ──
        Wrap(
          spacing: 10, // 隙間を少しゆったりさせたよ
          runSpacing: 12,
          children: _allTags.map((tag) {
            final emoji = tag.$1;
            final label = tag.$2;
            final isSelected = selectedTags.contains(label);

            // 💡 上限に達していて、かつ未選択のタグは押せなくする
            final isDisabled = isMaxReached && !isSelected;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? colors.primary
                      : isDisabled
                          ? colors.textMuted
                          : colors.border,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              // 💡 GestureDetectorから、波紋が出るInkWellにグレードアップ！
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: isDisabled ? null : () => onToggle(label),
                  splashColor: colors.textPrimary.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Opacity(
                      opacity: isDisabled ? 0.4 : 1.0, // 💡 押せないタグは薄くして諦めさせるの
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? AppColors.textDark : colors.textPrimary,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          // 選択中だけチェックマークがシュッとアニメーションで出るよ♡
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: isSelected
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: AppColors.textDark,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
