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
        horizontal: AppSizes.p20,
        vertical: AppSizes.p16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // ───────────────────
          // 📍 Status Icon
          // ───────────────────
          statusAsync.when(
            data: (status) => _StatusIcon(status: status),
            loading: () => const _LoadingIcon(),
            error: (_, _) => const _StatusIcon(status: LocationStatus.error),
          ),

          const SizedBox(width: AppSizes.p16),

          // ───────────────────
          // 🛰️ Status Text
          // ───────────────────
          Expanded(
            child: statusAsync.when(
              data: (status) {
                switch (status) {
                  case LocationStatus.loading:
                    return _label('現在地を取得しています...', AppColors.textMuted);

                  case LocationStatus.success:
                    return labelAsync.when(
                      data: (label) =>
                          _label('現在地：$label', AppColors.textPrimary),
                      loading: () => _label('位置情報を確認中...', AppColors.textMuted),
                      error: (_, _) => _label('現在地を取得できません', AppColors.error),
                    );

                  case LocationStatus.error:
                    return _label('現在地を取得できません', AppColors.error);

                  case LocationStatus.disabled:
                    return _label('GPSがOFFになっています', AppColors.warning);
                }
              },
              loading: () => _label('現在地を取得しています...', AppColors.textMuted),
              error: (_, _) => _label('現在地を取得できません', AppColors.error),
            ),
          ),

          // ───────────────────
          // 🔄 Retry Button
          // ───────────────────
          statusAsync.whenOrNull(
                data: (status) {
                  if (status == LocationStatus.error ||
                      status == LocationStatus.disabled) {
                    return IconButton(
                      onPressed: () {
                        ref.invalidate(currentLocationProvider);
                        ref.invalidate(locationStatusProvider);
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.secondary,
                      ),
                    );
                  }

                  return null;
                },
              ) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _label(String text, Color color) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodyMedium.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─────────────────────────────
// 📍 Status Icon
// ─────────────────────────────

class _StatusIcon extends StatelessWidget {
  final LocationStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      LocationStatus.loading => (
        Icons.gps_not_fixed_rounded,
        AppColors.textMuted,
      ),

      LocationStatus.success => (
        Icons.gps_fixed_rounded,
        AppColors.accentGreen,
      ),

      LocationStatus.error => (Icons.gps_off_rounded, AppColors.error),

      LocationStatus.disabled => (
        Icons.location_disabled_rounded,
        AppColors.warning,
      ),
    };

    return Icon(icon, size: AppSizes.iconM, color: color);
  }
}

// ─────────────────────────────
// 🌙 Loading Icon
// ─────────────────────────────

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSizes.iconM,
      height: AppSizes.iconM,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        color: AppColors.secondary,
      ),
    );
  }
}
