// lib/widgets/adventure_setup/mode_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../../providers/adventure_provider.dart';
import '../../core/enums/adventure_mode.dart';

class ModeSelector extends ConsumerWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(
      adventureProvider.select((state) => state.mode),
    );

    final notifier = ref.read(adventureProvider.notifier);

    return Column(
      children: AdventureMode.values.map((mode) {
        final isSelected = currentMode == mode;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.p12),

          child: _ModeCard(
            mode: mode,
            isSelected: isSelected,

            onTap: () {
              notifier.setMode(mode);
            },
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────
// 🗺️ Mode Card
// ─────────────────────────────

class _ModeCard extends StatelessWidget {
  final AdventureMode mode;

  final bool isSelected;

  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),

        onTap: onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p20,
            vertical: AppSizes.p16,
          ),

          decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedItem : AppColors.surface,

            borderRadius: BorderRadius.circular(AppSizes.radiusL),

            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,

              width: isSelected ? 1.6 : 1,
            ),
          ),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      mode.label,

                      style: AppTextStyles.titleSmall.copyWith(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.modeTextUnselected,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      mode.distanceRange,

                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? AppColors.textSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
