// lib/widgets/common/custom_header.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// true のとき戻るボタン表示
  final bool showBackButton;

  /// 戻るボタン押下時のカスタムコールバック
  final VoidCallback? onBack;

  /// 右側にwidget置きたい時用
  final Widget? trailing;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        AppSizes.p12,
        AppSizes.p20,
        AppSizes.p20,
        AppSizes.p16,
      ),

      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.92),

        border: Border(
          bottom: BorderSide(color: colors.border.withValues(alpha: 0.7)),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ───────────────────
          // ← Back Button
          // ───────────────────
          if (showBackButton)
            _HeaderIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack ?? () => context.pop(),
            )
          else
            const SizedBox(width: 44),

          const SizedBox(width: AppSizes.p12),

          // ───────────────────
          // Title Area
          // ───────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: 1.8,
                    color: colors.textPrimary,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: AppSizes.p4),

                  Text(
                    subtitle!,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                      fontSize: 13,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ───────────────────
          // Right Widget
          // ───────────────────
          if (trailing != null) ...[
            const SizedBox(width: AppSizes.p12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────
// ✨ Header Icon Button
// ─────────────────────────────
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Material(
      color: colors.surfaceLight,
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),

      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        onTap: onTap,

        child: Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),

            border: Border.all(color: colors.border),
          ),

          child: Icon(icon, size: 18, color: colors.textPrimary),
        ),
      ),
    );
  }
}

