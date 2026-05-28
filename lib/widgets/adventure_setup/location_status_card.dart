// lib/widgets/adventure_setup/location_status_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/location_provider.dart';

class LocationStatusCard extends ConsumerWidget {
  const LocationStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(locationStatusProvider);
    final labelAsync = ref.watch(currentLocationLabelProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // ── GPS状態アイコン ──
          statusAsync.when(
            data: (status) => _StatusIcon(status: status),
            loading: () => const _LoadingIcon(),
            error: (_, _) => const _StatusIcon(status: LocationStatus.error),
          ),
          const SizedBox(width: AppSizes.p12),

          // ── 表示テキスト ──
          Expanded(
            child: statusAsync.when(
              data: (status) => switch (status) {
                LocationStatus.loading => _label(
                  '現在地を取得中...',
                  AppColors.textMuted,
                ),
                LocationStatus.success => labelAsync.when(
                  data: (label) => _label(label, AppColors.textPrimary),
                  loading: () => _label('現在地を取得中...', AppColors.textMuted),
                  error: (_, _) => _label('現在地を取得できません', AppColors.error),
                ),
                LocationStatus.error => _label('現在地を取得できません', AppColors.error),
                LocationStatus.disabled => _label(
                  'GPSがOFFです',
                  AppColors.warning,
                ),
              },
              loading: () => _label('現在地を取得中...', AppColors.textMuted),
              error: (_, _) => _label('現在地を取得できません', AppColors.error),
            ),
          ),

          // ── 再取得ボタン ──
          statusAsync.whenOrNull(
                data: (status) =>
                    status == LocationStatus.error ||
                        status == LocationStatus.disabled
                    ? IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          size: AppSizes.iconS,
                          color: AppColors.secondary,
                        ),
                        onPressed: () {
                          ref.invalidate(currentLocationProvider);
                          ref.invalidate(locationStatusProvider);
                        },
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _label(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ── GPS状態アイコン ──────────────────────────
class _StatusIcon extends StatelessWidget {
  final LocationStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      LocationStatus.loading => (Icons.gps_not_fixed, AppColors.textMuted),
      LocationStatus.success => (Icons.gps_fixed, AppColors.accentGreen),
      LocationStatus.error => (Icons.gps_off, AppColors.error),
      LocationStatus.disabled => (Icons.location_disabled, AppColors.warning),
    };

    return Icon(icon, size: AppSizes.iconS, color: color);
  }
}

// ── ローディング中のアイコン ─────────────────
class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSizes.iconS,
      height: AppSizes.iconS,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.secondary,
      ),
    );
  }
}
