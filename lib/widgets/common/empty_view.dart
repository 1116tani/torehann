// lib/widgets/common/empty_view.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shadows.dart';

class EmptyView extends StatelessWidget {
  final String title;

  final String? message;

  final IconData icon;

  final Widget? action;

  const EmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.auto_awesome_rounded,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.p32,
          ),

          decoration: BoxDecoration(
            color: colors.background.withValues(alpha: 0.9),

            borderRadius: BorderRadius.circular(AppRadius.xl),

            border: Border.all(color: colors.glassBorder),

            boxShadow: AppShadows.glass(isDark),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ─────────────────────
              // ✨ Icon
              // ─────────────────────
              Container(
                width: 72,
                height: 72,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: colors.primary.withValues(alpha: 0.12),

                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.28),
                  ),
                ),

                child: Icon(icon, size: 34, color: colors.primary),
              ),

              const SizedBox(height: AppSizes.p24),

              // ─────────────────────
              // 📜 Title
              // ─────────────────────
              Text(
                title,

                style: AppTextStyles.titleSmall.copyWith(color: colors.textPrimary),

                textAlign: TextAlign.center,
              ),

              // ─────────────────────
              // 💬 Message
              // ─────────────────────
              if (message != null) ...[
                const SizedBox(height: AppSizes.p12),

                Text(
                  message!,

                  style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),

                  textAlign: TextAlign.center,
                ),
              ],

              // ─────────────────────
              // 🔘 Action
              // ─────────────────────
              if (action != null) ...[
                const SizedBox(height: AppSizes.p24),

                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
