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
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
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
            color: isSelected ? colors.selectedItem : colors.surface,

            borderRadius: BorderRadius.circular(AppSizes.radiusL),

            border: Border.all(
              color: isSelected ? colors.primary : colors.border,

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

                      style: textStyles.titleSmall.copyWith(
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      mode.distanceRange,

                      style: textStyles.caption.copyWith(
                        color: isSelected
                            ? colors.textSecondary
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
