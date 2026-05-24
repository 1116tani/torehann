// lib/widgets/friend/status_badge.dart

import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isOnline;

  const StatusBadge({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isOnline
            ? const Color(0xFF2D5A3D).withValues(alpha: 0.25)
            : const Color(0xFF4A3728).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline
              ? const Color(0xFF57D6C9)
              : const Color(0xFF7A5C3A),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF57D6C9)
                  : const Color(0xFF7A5C3A),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            isOnline ? '冒険中' : '休憩中',
            style: TextStyle(
              color: isOnline
                  ? const Color(0xFF57D6C9)
                  : const Color(0xFF7A5C3A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}