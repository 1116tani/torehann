// lib/widgets/settings/hobby_tag_selector.dart

import 'package:flutter/material.dart';

class HobbyTagSelector extends StatelessWidget {
  final List<String> selectedTags; // 選択中のタグ一覧
  final Function(String) onToggle; // タグをタップした時の処理

  const HobbyTagSelector({
    super.key,
    required this.selectedTags,
    required this.onToggle,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 選択数の表示 ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '好きな場所を選んでね',
              style: TextStyle(color: Color(0xFF7A5C3A), fontSize: 11),
            ),
            Text(
              '${selectedTags.length}個選択中',
              style: TextStyle(
                color: selectedTags.isEmpty
                    ? const Color(0xFF7A5C3A)
                    : const Color(0xFFB8860B),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── タグのグリッド ──
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allTags.map((tag) {
            final emoji = tag.$1;
            final label = tag.$2;
            final isSelected = selectedTags.contains(label);

            return GestureDetector(
              onTap: () => onToggle(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF3D2B1F),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFB8860B)
                        : const Color(0xFFC8A97A),
                    width: isSelected ? 1.5 : 0.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFB8860B,
                            ).withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFC8A97A),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    // 選択中はチェックマーク
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check, size: 12, color: Colors.white),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
