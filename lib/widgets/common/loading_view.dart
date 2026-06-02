// lib/widgets/common/loading_view.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_gradients.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shadows.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({super.key, this.message = '街の記憶を読み解き中...'});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        gradient: AppGradients.background(isDark),
      ),

      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

            child: Container(
              width: 260,

              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p24,
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
                  // ✨ Loader
                  // ─────────────────────
                  SizedBox(
                    width: 42,
                    height: 42,

                    child: CircularProgressIndicator(
                      strokeWidth: 3,

                      valueColor: AlwaysStoppedAnimation(
                        colors.primary,
                      ),

                      backgroundColor: colors.surfaceLight,
                    ),
                  ),

                  const SizedBox(height: AppSizes.p24),

                  // ─────────────────────
                  // 📜 Message
                  // ─────────────────────
                  Text(
                    message,

                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textPrimary,

                      letterSpacing: 0.4,
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSizes.p12),

                  Text(
                    'しばらくお待ちください...',
                    style: AppTextStyles.caption.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
