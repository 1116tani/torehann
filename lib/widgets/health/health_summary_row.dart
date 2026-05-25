// lib/widgets/health/health_summary_row.dart

import 'package:flutter/material.dart';
import 'health_stat_card.dart';

class HealthSummaryRow extends StatelessWidget {
  final int steps;
  final double distanceKm;
  final int calories;

  const HealthSummaryRow({
    super.key,
    required this.steps,
    required this.distanceKm,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HealthStatCard(
            icon: Icons.directions_walk,
            label: '合計歩数',
            value: '$steps 歩',
            iconColor: const Color(0xFFB8860B),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: HealthStatCard(
            icon: Icons.route,
            label: '合計距離',
            value: '${distanceKm.toStringAsFixed(1)} km',
            iconColor: const Color(0xFF57D6C9),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: HealthStatCard(
            icon: Icons.local_fire_department,
            label: '合計消費',
            value: '$calories kcal',
            iconColor: const Color(0xFFFF7B7B),
          ),
        ),
      ],
    );
  }
}