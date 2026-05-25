// lib/widgets/result/stat_panel.dart

import 'package:flutter/material.dart';
import '../../models/result_model.dart';

class StatPanel extends StatelessWidget {
  final AdventureResult result;

  const StatPanel({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.5,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── タイトル ─────────────────────
          const Row(
            children: [
              Icon(
                Icons.auto_graph,
                color: Color(0xFFB8860B),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                '冒険の記録',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── ステータスグリッド ───────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,

            children: [
              _StatItem(
                icon: Icons.route,
                label: '移動距離',
                value: '${result.distanceKm.toStringAsFixed(1)} km',
              ),

              _StatItem(
                icon: Icons.directions_walk,
                label: '歩数',
                value: '${result.steps} 歩',
              ),

              _StatItem(
                icon: Icons.local_fire_department,
                label: '消費カロリー',
                value: '${result.calories} kcal',
              ),

              _StatItem(
                icon: Icons.schedule,
                label: '冒険時間',
                value: '${result.durationMinutes} 分',
              ),

              _StatItem(
                icon: Icons.auto_awesome,
                label: '街の断片',
                value: '${result.fragmentCount} 個',
              ),

              _StatItem(
                icon: Icons.star,
                label: '獲得EXP',
                value: '+${result.expGained}',
                isGold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 📦 ステータスアイテム
// ─────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isGold;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: isGold
              ? const Color(0xFFB8860B)
              : const Color(0xFF5C4033),
          width: 0.5,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: isGold
                  ? const Color(0xFFB8860B).withValues(alpha: 0.15)
                  : const Color(0xFF1C1610),

              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              size: 18,
              color: isGold
                  ? const Color(0xFFFFD700)
                  : const Color(0xFFC8A97A),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF7A5C3A),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isGold
                        ? const Color(0xFFFFD700)
                        : const Color(0xFFF5EDD8),

                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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