// lib/widgets/mission/mission_progress_bar.dart

import 'package:flutter/material.dart';

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
              style: const TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '${(clamped * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFF7A5C3A),
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
                color: const Color(0xFF1C1610),
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
                      const Color(0xFFB8860B),
                      const Color(0xFFFFD700).withValues(alpha: 0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFFFD700,
                      ).withValues(alpha: 0.35),
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