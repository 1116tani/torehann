// lib/widgets/common/error_view.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shadows.dart';

class ErrorView extends StatelessWidget {
  final String title;

  final String? message;

  final VoidCallback? onRetry;

  final IconData icon;

  const ErrorView({
    super.key,
    this.title = '通信に失敗しました',
    this.message,
    this.onRetry,
    this.icon = Icons.warning_amber_rounded,
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

            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),

            boxShadow: AppShadows.glass(isDark),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ─────────────────────
              // ⚠ Error Icon
              // ─────────────────────
              Container(
                width: 76,
                height: 76,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: AppColors.error.withValues(alpha: 0.12),

                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.24),
                  ),
                ),

                child: Icon(icon, size: 38, color: AppColors.error),
              ),

              const SizedBox(height: AppSizes.p24),

              // ─────────────────────
              // 📜 Title
              // ─────────────────────
              Text(
                title,

                style: AppTextStyles.titleSmall.copyWith(
                  color: colors.textPrimary,
                ),

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
              // 🔄 Retry Button
              // ─────────────────────
              if (onRetry != null) ...[
                const SizedBox(height: AppSizes.p24),

                SizedBox(
                  width: 180,

                  child: ElevatedButton.icon(
                    onPressed: onRetry,

                    icon: const Icon(Icons.refresh_rounded),

                    label: const Text('再試行'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
