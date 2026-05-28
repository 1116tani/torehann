// lib/widgets/adventure_setup/mood_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../core/enums/adventure_mode.dart';
import '../../providers/adventure_provider.dart';

class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  // 気分の定義
  static const _moods = [
    (mood: AdventureMood.relaxed, emoji: '🌸', label: 'のんびり'),
    (mood: AdventureMood.excited, emoji: '✨', label: 'わくわく'),
    (mood: AdventureMood.intense, emoji: '🔥', label: 'ガッツリ'),
    (mood: AdventureMood.random, emoji: '🎲', label: 'きまぐれ'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(adventureProvider.select((s) => s.mood));
    final notifier = ref.read(adventureProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── セクションラベル ──
        Row(
          children: [
            const Text('😊', style: TextStyle(fontSize: AppSizes.iconS)),
            const SizedBox(width: AppSizes.p8),
            Text('今の気分', style: AppTextStyles.titleSmall),
          ],
        ),
        const SizedBox(height: AppSizes.p12),

        // ── 気分ボタングリッド ──
        Row(
          children: _moods.map((item) {
            final isSelected = currentMood == item.mood;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p4),
                child: _MoodButton(
                  emoji: item.emoji,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => notifier.setMood(item.mood),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── 気分ボタン1個 ──────────────────────────
class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: AppSizes.moodButtonSize,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedItem : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 絵文字
            Text(emoji, style: TextStyle(fontSize: isSelected ? 28 : 24)),
            const SizedBox(height: AppSizes.p4),

            // ラベル
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.moodLabelSelected
                  : AppTextStyles.moodLabelUnselected,
            ),
          ],
        ),
      ),
    );
  }
}
