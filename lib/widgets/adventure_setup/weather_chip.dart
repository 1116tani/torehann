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

  // ─────────────────────────────
  // 🌤 Weather Emoji
  // ─────────────────────────────

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),

      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius: BorderRadius.circular(AppSizes.radiusFull),

        border: Border.all(color: isError ? AppColors.error : AppColors.border),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ───────────────────
          // 🌤 Icon
          // ───────────────────
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.secondary,
              ),
            )
          else
            Text(
              isError ? '⚠️' : _iconEmoji(weather!.iconCode),
              style: const TextStyle(fontSize: 18),
            ),

          const SizedBox(width: AppSizes.p12),

          // ───────────────────
          // 🌡 Weather Text
          // ───────────────────
          if (isLoading)
            _label('天候を観測中...', AppColors.textMuted)
          else if (isError)
            _label('天候データ取得失敗', AppColors.error)
          else ...[
            _label(weather!.localizedDescription, AppColors.textPrimary),

            const SizedBox(width: AppSizes.p8),

            Text(
              weather!.temperatureLabel,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _label(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
