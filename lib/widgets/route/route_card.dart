// lib/widgets/route/route_card.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/route_model.dart';
import 'route_tag.dart';
import 'route_story_section.dart';
import 'route_spot_list.dart';
import 'route_info_chips.dart';

/// ルート選択画面ボトムシート用カード（マッププレビューなし）。
class RouteCard extends StatelessWidget {
  final RouteModel route;
  final bool isSelected;

  const RouteCard({
    super.key,
    required this.route,
    this.isSelected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.divider,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route.themeName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: route.tags.map((tag) => RouteTag(label: tag)).toList(),
              ),
              const SizedBox(height: 14),
              RouteInfoChips(
                distanceKm: route.totalDistance,
                durationMinutes: route.estimatedTime,
                spotCount: route.generatedSpots.length,
              ),
              const SizedBox(height: 14),
              RouteStorySection(story: route.themeDescription),
              const SizedBox(height: 14),
              RouteSpotList(spots: route.generatedSpots),
            ],
          ),
        ),
      ),
    );
  }
}
