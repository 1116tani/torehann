// lib/widgets/home/partner_dialog_bubble.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class PartnerDialogBubble extends StatelessWidget {
  final String title;

  final String message;

  const PartnerDialogBubble({
    super.key,

    required this.title,

    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Stack(
      clipBehavior: Clip.none,

      children: [
        // ─────────────────────
        // 💬 Bubble
        // ─────────────────────
        Container(
          constraints: const BoxConstraints(maxWidth: 290),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p16,
          ),

          decoration: BoxDecoration(
            color: AppColors.parchment,

            borderRadius: BorderRadius.circular(AppRadius.xl),

            border: Border.all(color: colors.primary.withValues(alpha: 0.2)),

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
                title,

                style: AppTextStyles.caption.copyWith(
                  color: colors.primaryDark,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,

                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textDark,

                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        // ─────────────────────
        // ▼ Bubble Tail
        // ─────────────────────
        Positioned(
          bottom: -10,
          left: 28,

          child: Transform.rotate(
            angle: 0.8,

            child: Container(
              width: 22,
              height: 22,

              decoration: BoxDecoration(
                color: AppColors.parchment,

                border: Border(
                  right: BorderSide(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),

                  bottom: BorderSide(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
