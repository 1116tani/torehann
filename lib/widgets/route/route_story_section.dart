// lib/widgets/route/route_story_section.dart

import 'package:flutter/material.dart';

class RouteStorySection extends StatelessWidget {
  final String story;

  const RouteStorySection({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1610).withValues(alpha: 0.6), // 半透明の深みあるブラウン
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A3728), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories, color: Color(0xFFC8A97A), size: 14),
              const SizedBox(width: 8),
              Text(
                'STORY',
                style: TextStyle(
                  color: const Color(0xFFC8A97A).withValues(alpha: 0.7),
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
            style: const TextStyle(
              color: Color(0xFFF5EDD8),
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
