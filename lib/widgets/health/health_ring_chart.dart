// lib/widgets/health/health_ring_chart.dart

import 'package:flutter/material.dart';

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
    return SizedBox(
      width: 240,
      height: 240,

      child: Stack(
        alignment: Alignment.center,

        children: [
          // 外側
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: stepProgress,
              strokeWidth: 14,
              backgroundColor: const Color(0xFF3D2B1F),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFB8860B),
              ),
            ),
          ),

          // 中間
          SizedBox(
            width: 190,
            height: 190,
            child: CircularProgressIndicator(
              value: distanceProgress,
              strokeWidth: 12,
              backgroundColor: const Color(0xFF3D2B1F),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF57D6C9),
              ),
            ),
          ),

          // 内側
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: calorieProgress,
              strokeWidth: 10,
              backgroundColor: const Color(0xFF3D2B1F),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFFF7B7B),
              ),
            ),
          ),

          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: Color(0xFFC8A97A),
                size: 28,
              ),

              SizedBox(height: 8),

              Text(
                '今日の状態',
                style: TextStyle(
                  color: Color(0xFF7A5C3A),
                  fontSize: 11,
                ),
              ),

              SizedBox(height: 2),

              Text(
                '良好',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
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