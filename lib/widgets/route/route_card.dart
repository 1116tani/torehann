// lib/widgets/route/route_card.dart

import 'package:flutter/material.dart';
import '../../models/route_model.dart';
import '../../models/spot_model.dart';
import 'route_tag.dart';
import 'route_preview_map.dart';
import 'route_story_section.dart';
import 'route_spot_list.dart';
import 'route_info_chips.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.spots,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.02 : 0.98,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.65,
        duration: const Duration(milliseconds: 240),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2318), // 深いブラウン
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF4A3728),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFFC8A97A).withValues(alpha: 0.28)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: isSelected ? 20 : 8,
                spreadRadius: isSelected ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── タイトル ──
                        Text(
                          route.themeName,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFF5EDD8) : const Color(0xFFC8A97A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── 感情タグ ──
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: route.tags.map((tag) => RouteTag(label: tag)).toList(),
                        ),
                        const SizedBox(height: 16),

                        // ── 簡易マップ ──
                        RoutePreviewMap(
                          route: route,
                          spots: spots,
                          isSelected: isSelected,
                          height: 110,
                          showDetails: false, // バッジや黒帯を出さずにシンプルに
                        ),
                        const SizedBox(height: 16),

                        // ── 物語文 ──
                        RouteStorySection(story: route.themeDescription),
                        const SizedBox(height: 16),

                        // ── スポットリスト ──
                        RouteSpotList(spots: route.generatedSpots),
                        const SizedBox(height: 16),

                        // ── 距離・時間・数 ──
                        RouteInfoChips(
                          distanceKm: route.totalDistance,
                          durationMinutes: route.estimatedTime,
                          spotCount: route.generatedSpots.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}