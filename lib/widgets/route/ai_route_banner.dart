// lib/widgets/route/ai_route_banner.dart

import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class AiRouteBanner extends StatelessWidget {
  const AiRouteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F), // 落ち着いたダークブラウン
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC8A97A), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8A97A).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFFC8A97A), size: 22),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Text(
              'AIが今日の冒険候補（物語）を用意しました',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
