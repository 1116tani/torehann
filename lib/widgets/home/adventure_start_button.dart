// lib/widgets/home/adventure_start_button.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_gradients.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../../router/route_names.dart';

class AdventureStartButton extends StatelessWidget {
  const AdventureStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xxl),

          gradient: AppGradients.primaryButton,

          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),

              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: ElevatedButton(
          onPressed: () {
            context.push(AppRoutes.adventureSetting);
          },

          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 64),

            backgroundColor: Colors.transparent,

            shadowColor: Colors.transparent,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: AppColors.textPrimary.withValues(alpha: 0.12),
                ),

                child: const Icon(
                  Icons.explore_rounded,

                  color: AppColors.textDark,

                  size: 22,
                ),
              ),

              const SizedBox(width: AppSizes.p12),

              Text(
                '冒険へ出発する',

                style: AppTextStyles.button.copyWith(
                  fontSize: 17,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
