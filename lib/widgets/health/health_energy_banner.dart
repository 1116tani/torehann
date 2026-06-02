// lib/widgets/health/health_energy_banner.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HealthEnergyBanner extends StatelessWidget {
  final int energy;
  final String message;

  const HealthEnergyBanner({
    super.key,
    required this.energy,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.surfaceLight,
            colors.surface,
          ],
        ),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: colors.primary,
          width: 0.7,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.warning,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '冒険エネルギー $energy%',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  message,
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}