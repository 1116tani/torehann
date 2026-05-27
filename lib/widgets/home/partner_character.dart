// lib/widgets/home/partner_character.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class PartnerCharacter extends StatelessWidget {
  final String characterName;

  final String currentMessage;

  final String imagePath;

  const PartnerCharacter({
    super.key,

    this.characterName = '案内妖精・アイリス',

    this.currentMessage = '今日はどんな物語を\n紡ぎに行くの？',

    this.imagePath = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        // ─────────────────────
        // 💬 Dialogue Bubble
        // ─────────────────────
        Container(
          constraints: const BoxConstraints(maxWidth: 280),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p16,
          ),

          decoration: BoxDecoration(
            color: AppColors.parchment,

            borderRadius: BorderRadius.circular(AppRadius.xl),

            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),

                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                characterName,

                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryDark,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                currentMessage,

                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,

                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.p20),

        // ─────────────────────
        // ✨ Character
        // ─────────────────────
        Stack(
          alignment: Alignment.center,

          children: [
            // Glow
            Container(
              width: 170,
              height: 170,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),

                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Character
            imagePath.isEmpty
                ? Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: AppColors.surfaceLight,

                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),

                    child: const Icon(
                      Icons.auto_awesome_rounded,

                      size: 56,

                      color: AppColors.primary,
                    ),
                  )
                : Image.asset(
                    imagePath,

                    width: 150,
                    height: 150,

                    fit: BoxFit.contain,
                  ),
          ],
        ),
      ],
    );
  }
}
