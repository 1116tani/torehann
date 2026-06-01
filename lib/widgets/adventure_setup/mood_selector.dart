// lib/widgets/adventure_setup/mood_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../../providers/adventure_provider.dart';

class MoodSelector extends ConsumerWidget {
  const MoodSelector({super.key});

  // ─────────────────────────────
  // 😊 Mood Definitions
  // ─────────────────────────────

  static const _moods = [
    (mood: AdventureMood.relaxed, emoji: '🌸', label: 'のんびり'),

    (mood: AdventureMood.excited, emoji: '✨', label: 'わくわく'),

    (mood: AdventureMood.intense, emoji: '🔥', label: 'ガッツリ'),

    (mood: AdventureMood.random, emoji: '🎲', label: 'きまぐれ'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(
      adventureProvider.select((state) => state.mood),
    );

    final notifier = ref.read(adventureProvider.notifier);

    return Row(
      children: _moods.map((item) {
        final isSelected = currentMood == item.mood;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p4),

            child: _MoodButton(
              emoji: item.emoji,
              label: item.label,
              isSelected: isSelected,

              onTap: () {
                notifier.setMood(item.mood);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────
// 🎴 Mood Button
// ─────────────────────────────

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
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),

      scale: isSelected ? 1.03 : 1.0,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),

          onTap: onTap,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),

            curve: Curves.easeOutCubic,

            height: 112,

            decoration: BoxDecoration(
              color: isSelected ? colors.selectedItem : colors.surface,

              borderRadius: BorderRadius.circular(AppSizes.radiusL),

              border: Border.all(
                color: isSelected ? colors.primary : colors.border,

                width: isSelected ? 1.6 : 1,
              ),

              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.22),

                        blurRadius: 18,

                        spreadRadius: 1,

                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // 🌸 Emoji
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),

                  style: TextStyle(fontSize: isSelected ? 34 : 28),

                  child: Text(emoji),
                ),

                const SizedBox(height: AppSizes.p12),

                // 📝 Label
                Text(
                  label,

                  textAlign: TextAlign.center,

                  style: textStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? colors.textPrimary
                        : colors.textSecondary,

                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
