// lib/widgets/health/health_ring_chart.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HealthRingChart extends StatelessWidget {
  final double stepProgress;
  final double distanceProgress;
  final double calorieProgress;

  const HealthRingChart({
    super.key,
    required this.stepProgress,
    required this.distanceProgress,
    required this.calorieProgress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    
    // 背景色（リングの未達成部分）
    final ringBgColor = colors.surfaceLight;

    return SizedBox(
      width: 240,
      height: 240,

      child: Stack(
        alignment: Alignment.center,

        children: [
          // 外側 (歩数 - Primary/Gold)
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: stepProgress,
              strokeWidth: 14,
              backgroundColor: ringBgColor,
              valueColor: AlwaysStoppedAnimation(colors.primary),
            ),
          ),

          // 中間 (距離 - Success系/Teal)
          SizedBox(
            width: 190,
            height: 190,
            child: CircularProgressIndicator(
              value: distanceProgress,
              strokeWidth: 12,
              backgroundColor: ringBgColor,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF57D6C9),
              ),
            ),
          ),

          // 内側 (カロリー - Error系/Red)
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: calorieProgress,
              strokeWidth: 10,
              backgroundColor: ringBgColor,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.error,
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: colors.primary,
                size: 28,
              ),

              const SizedBox(height: 8),

              Text(
                '今日の状態',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '良好',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
