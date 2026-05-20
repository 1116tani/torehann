// lib/widgets/route/route_theme_chip.dart

import 'package:flutter/material.dart';

class RouteThemeChip extends StatelessWidget {
  final String themeName; // AIが付けたルート名
  final String themeDescription; // AIが生成した説明文
  final bool isSelected; // 選択中かどうか

  const RouteThemeChip({
    super.key,
    required this.themeName,
    required this.themeDescription,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFB8860B) : const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFB8860B) : const Color(0xFFC8A97A),
          width: isSelected ? 1.5 : 0.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFB8860B).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ルート名 ──
          Row(
            children: [
              const Text('📖 ', style: TextStyle(fontSize: 13)),
              Expanded(
                child: Text(
                  themeName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFF5EDD8),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // ── 説明文 ──
          Text(
            themeDescription,
            style: TextStyle(
              color: isSelected ? Colors.white70 : const Color(0xFF7A5C3A),
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
