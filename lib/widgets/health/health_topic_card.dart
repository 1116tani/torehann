// lib/widgets/health/health_topic_card.dart

import 'package:flutter/material.dart';
import '../../models/health/health_topic_model.dart';

class HealthTopicCard extends StatelessWidget {
  final HealthTopicModel topic;

  const HealthTopicCard({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: const Color(0xFF3D2B1F),
              shape: BoxShape.circle,
            ),

            child: Icon(
              topic.icon,
              color: const Color(0xFFB8860B),
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  topic.description,
                  style: const TextStyle(
                    color: Color(0xFFC8A97A),
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