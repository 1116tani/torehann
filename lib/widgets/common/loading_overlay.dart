// lib/widgets/common/loading_overlay.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shadows.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  final Widget child;

  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        child,

        // ─────────────────────────────
        // 🌌 Loading Overlay
        // ─────────────────────────────
        if (isLoading)
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: isLoading ? 1 : 0,

              child: Container(
                color: Colors.black.withValues(alpha: 0.82),

                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                      child: Container(
                        width: 220,

                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.p24,
                          vertical: AppSizes.p24,
                        ),

                        decoration: BoxDecoration(
                          color: colors.background.withValues(alpha: 0.9),

                          borderRadius: BorderRadius.circular(AppRadius.xl),

                          border: Border.all(
                            color: colors.glassBorder,
                            width: 1,
                          ),

                          boxShadow: AppShadows.glass(isDark),
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            // ─────────────────
                            // ⏳ Loader
                            // ─────────────────
                            SizedBox(
                              width: 38,
                              height: 38,

                              child: CircularProgressIndicator(
                                strokeWidth: 2.8,

                                valueColor: AlwaysStoppedAnimation(
                                  colors.primary,
                                ),

                                backgroundColor: colors.surfaceLight,
                              ),
                            ),

                            // ─────────────────
                            // 💬 Message
                            // ─────────────────
                            if (message != null) ...[
                              const SizedBox(height: AppSizes.p20),

                              Text(
                                message!,

                                style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),

                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
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
