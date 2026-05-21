// lib/widgets/route/route_card.dart

import 'package:flutter/material.dart';
import '../../models/route_model.dart';
import 'route_tag.dart';
import 'route_theme_chip.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFB8860B) : const Color(0xFF7A5C3A),
          width: isSelected ? 2 : 0.5,
        ),
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3D2B1F), Color(0xFF2C2318)],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFFB8860B).withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: isSelected ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── テーマチップ ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: RouteThemeChip(
                  themeName: route.themeName,
                  themeDescription: route.themeDescription,
                  isSelected: isSelected,
                ),
              ),

              const Divider(color: Color(0xFF4A3728), height: 1),

              // ── 移動時間・距離 ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      label: '約${route.estimatedTime}分',
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.straighten,
                      label: '${route.totalDistance}km',
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.place_outlined,
                      label: '${route.spotIds.length}スポット',
                    ),
                  ],
                ),
              ),

              // ── タグ一覧 ──
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: route.tags
                      .map((tag) => RouteTag(label: tag))
                      .toList(),
                ),
              ),

              // ── 選択中バナー ──
              if (isSelected)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFB8860B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '✦ このルートで出発する ✦',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 時間・距離・スポット数の小さいチップ ──
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFFC8A97A)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFC8A97A), fontSize: 11),
        ),
      ],
    );
  }
}
