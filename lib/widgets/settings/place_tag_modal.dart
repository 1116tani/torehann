// lib/widgets/settings/place_tag_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class PlaceTagModal extends ConsumerWidget {
  const PlaceTagModal({super.key});

  static const List<String> _availableTags = [
    '神社', 'カフェ', '路地裏', '公園', '本屋', '展望台', 
    'レトロ建築', '商店街', '水辺', '美術館', 'ベーカリー', '静かな場所'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '🎒 好きな場所タグ (最大5個)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'よく行く場所や、AIに提案してほしいスポットの属性を選択してください。',
            style: TextStyle(color: Color(0xFF8B7355), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableTags.map((tag) {
              final isSelected = settings.favoriteTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) {
                  notifier.toggleFavoriteTag(tag);
                },
                selectedColor: const Color(0xFFC8A97A),
                checkmarkColor: const Color(0xFF1C1610),
                backgroundColor: const Color(0xFF1C1610),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF1C1610) : const Color(0xFFF5EDD8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF4A3728),
                    width: 1.0,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '選択中: ${settings.favoriteTags.length} / 5',
              style: TextStyle(
                color: settings.favoriteTags.length >= 5 ? const Color(0xFFC8A97A) : const Color(0xFF8B7355),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
