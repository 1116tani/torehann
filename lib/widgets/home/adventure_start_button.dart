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
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xxl),

          gradient: AppGradients.gold(isDark),

          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.3), // 💡 グローシャドウを明るく強化

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
            minimumSize: const Size(double.infinity, 72), // 💡 高さ 64 → 72 (大きく押しやすく)

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
                padding: const EdgeInsets.all(10), // 💡 内側余白 8 → 10

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: colors.textPrimary.withValues(alpha: 0.2), // 💡 サークルを少し明るく
                ),

                child: const Icon(
                  Icons.explore_rounded,

                  color: AppColors.textDark,

                  size: 26, // 💡 アイコンサイズ 22 → 26 (大きく)
                ),
              ),

              const SizedBox(width: AppSizes.p16), // 💡 間隔 12 → 16

              Text(
                '冒険へ出発する',

                style: AppTextStyles.button.copyWith(
                  fontSize: 19, // 💡 文字サイズ 17 → 19 (大きく)
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2, // 💡 文字間隔を広げて視認性向上
                  color: AppColors.textDark, // 💡 ボタン背景（金）に合わせて文字をクッキリ濃く
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
