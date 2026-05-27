// lib/widgets/common/custom_button.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_durations.dart';
import '../../constants/app_gradients.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_shadows.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final bool isLoading;

  final IconData? icon;

  final bool expanded;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final buttonChild = AnimatedContainer(
      duration: AppDurations.button,

      width: expanded ? double.infinity : null,

      height: AppSizes.buttonHeight,

      decoration: BoxDecoration(
        gradient: isDisabled ? null : AppGradients.gold,

        color: isDisabled ? AppColors.surfaceLight : null,

        borderRadius: BorderRadius.circular(AppRadius.full),

        border: Border.all(
          color: isDisabled ? AppColors.border : AppColors.primaryDark,
          width: 1,
        ),

        boxShadow: isDisabled ? null : AppShadows.goldGlow,
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: isDisabled ? null : onPressed,

          borderRadius: BorderRadius.circular(AppRadius.full),

          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(AppColors.textDark),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: AppSizes.iconS,
                          color: isDisabled
                              ? AppColors.textMuted
                              : AppColors.textDark,
                        ),

                        const SizedBox(width: AppSizes.p8),
                      ],

                      Text(
                        text,

                        style: AppTextStyles.button.copyWith(
                          color: isDisabled
                              ? AppColors.textMuted
                              : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    if (!expanded) {
      return buttonChild;
    }

    return SizedBox(width: double.infinity, child: buttonChild);
  }
}
