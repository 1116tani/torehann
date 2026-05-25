// lib/widgets/health/health_stat_card.dart

import 'package:flutter/material.dart';

class HealthStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const HealthStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A5C3A),
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}