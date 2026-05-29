// lib/widgets/route/route_info_chips.dart

import 'package:flutter/material.dart';

class RouteInfoChips extends StatelessWidget {
  final double distanceKm;
  final int durationMinutes;
  final int spotCount;

  const RouteInfoChips({
    super.key,
    required this.distanceKm,
    required this.durationMinutes,
    required this.spotCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildMetricChip(Icons.directions_walk_rounded, '${distanceKm.toStringAsFixed(1)}km'),
        _buildMetricChip(Icons.schedule_rounded, '$durationMinutes分'),
        _buildMetricChip(Icons.place_outlined, '$spotCountスポット'),
      ],
    );
  }

  Widget _buildMetricChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1610), // より深いブラウン
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7A5C3A), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFC8A97A), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
