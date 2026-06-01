// lib/widgets/route/route_story_section.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class RouteStorySection extends StatelessWidget {
  final String story;

  const RouteStorySection({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.6), // 半透明の深みあるブラウン
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, color: colors.secondary, size: 14),
              const SizedBox(width: 8),
              Text(
                'STORY',
                style: TextStyle(
                  color: colors.secondary.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            story,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.6,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

