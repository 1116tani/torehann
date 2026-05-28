// lib/widgets/adventure_setup/weather_chip.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/weather_provider.dart';
import '../../services/weather_service.dart';

class WeatherChip extends ConsumerWidget {
  const WeatherChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      data: (weather) => _WeatherChipContent(weather: weather),
      loading: () => const _WeatherChipContent(isLoading: true),
      error: (_, _) => const _WeatherChipContent(isError: true),
    );
  }
}

class _WeatherChipContent extends StatelessWidget {
  final WeatherInfo? weather;
  final bool isLoading;
  final bool isError;

  const _WeatherChipContent({
    this.weather,
    this.isLoading = false,
    this.isError = false,
  });

  // iconCodeから絵文字に変換
  String _iconEmoji(String iconCode) {
    return switch (iconCode.substring(0, 2)) {
      '01' => '☀️',
      '02' => '🌤️',
      '03' => '⛅',
      '04' => '☁️',
      '09' => '🌧️',
      '10' => '🌦️',
      '11' => '⛈️',
      '13' => '❄️',
      '50' => '🌫️',
      _ => '🌤️',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: isError ? AppColors.error : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 天気アイコン ──
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.secondary,
              ),
            )
          else
            Text(
              isError ? '❓' : _iconEmoji(weather!.iconCode),
              style: const TextStyle(fontSize: 14),
            ),

          const SizedBox(width: AppSizes.p8),

          // ── 天気テキスト ──
          Text(
            isLoading
                ? '取得中...'
                : isError
                ? '取得できません'
                : weather!.localizedDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: isError ? AppColors.error : AppColors.textSecondary,
            ),
          ),

          // ── 気温 ──
          if (weather != null) ...[
            const SizedBox(width: AppSizes.p4),
            Text(
              weather!.temperatureLabel,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
