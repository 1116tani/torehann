// lib/widgets/adventure_setup/generate_route_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

import '../../providers/adventure_provider.dart';
import '../../providers/route_provider.dart';

class GenerateRouteButton extends ConsumerWidget {
  final VoidCallback? onSuccess;

  const GenerateRouteButton({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventureState = ref.watch(adventureProvider);
    final routeState = ref.watch(routeSelectProvider);
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);

    final notifier = ref.read(routeSelectProvider.notifier);

    final canGenerate =
        adventureState.isRandomMode ||
        adventureState.destination.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─────────────────────────────
        // ⚠ エラーメッセージ
        // ─────────────────────────────
        if (routeState.errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: AppSizes.iconS,
                ),

                const SizedBox(width: AppSizes.p8),

                Expanded(
                  child: Text(
                    routeState.errorMessage!,
                    style: textStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.p16),
        ],

        // ─────────────────────────────
        // ✨ 生成ボタン
        // ─────────────────────────────
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: (!canGenerate || routeState.isLoading)
                ? null
                : () async {
                    await notifier.generateRoutes();

                    if (context.mounted &&
                        ref.read(routeSelectProvider).errorMessage == null) {
                      onSuccess?.call();
                    }
                  },

            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,

              disabledBackgroundColor: colors.surfaceLight,

              foregroundColor: AppColors.textDark,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
              ),

              elevation: routeState.isLoading ? 0 : 4,
            ),

            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),

              child: routeState.isLoading
                  ? Row(
                      key: const ValueKey('loading'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(width: AppSizes.p12),

                        Text(
                          '冒険ルートを生成中...',
                          style: textStyles.button.copyWith(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      key: const ValueKey('default'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome, size: 22),

                        const SizedBox(width: AppSizes.p12),

                        Text(
                          'ルートを生成する',
                          style: textStyles.button.copyWith(
                            color: AppColors.textDark,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.p12),

        // ─────────────────────────────
        // 💡 補助テキスト
        // ─────────────────────────────
        AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: canGenerate ? 1.0 : 0.7,
          child: Text(
            canGenerate
                ? '今の気分に合わせて、AIが街の物語を編みはじめるよ。'
                : '目的地を入力するか、おまかせモードを選んでね。',
            textAlign: TextAlign.center,
            style: textStyles.bodySmall.copyWith(
              color: colors.textMuted,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
