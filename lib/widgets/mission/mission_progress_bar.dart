// lib/widgets/mission/mission_progress_bar.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MissionProgressBar extends StatelessWidget {
  final double progress;
  final double currentValue;
  final double targetValue;
  final String unit;

  const MissionProgressBar({
    super.key,
    required this.progress,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final clamped = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 数値表示 ──────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _progressText(),
              style: TextStyle(
                color: colors.secondary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '${(clamped * 100).toInt()}%',
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // ── ゲージ背景 ───────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              // 背景
              Container(
                height: 10,
                width: double.infinity,
                color: colors.background,
              ),

              // 進捗
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 10,
                width: MediaQuery.of(context).size.width * clamped * 0.72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary,
                      colors.primary.withValues(alpha: 0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _progressText() {
    final current = unit == 'km'
        ? currentValue.toStringAsFixed(1)
        : currentValue.toStringAsFixed(0);

    final target = unit == 'km'
        ? targetValue.toStringAsFixed(1)
        : targetValue.toStringAsFixed(0);

    return '$current / $target $unit';
  }
}