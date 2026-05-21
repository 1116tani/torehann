// lib/widgets/navigation/route_progress_bar.dart

import 'package:flutter/material.dart';

class RouteProgressBar extends StatelessWidget {
  final double progress; // 0.0 〜 1.0
  final int visitedCount; // 訪問済みスポット数
  final int totalCount; // 総スポット数
  final double? distanceToNext; // 次のスポットまでの距離（m）

  const RouteProgressBar({
    super.key,
    required this.progress,
    required this.visitedCount,
    required this.totalCount,
    this.distanceToNext,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318).withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 上段：スポット数・距離 ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 訪問済み / 総数
              Row(
                children: [
                  const Icon(Icons.place, size: 13, color: Color(0xFFC8A97A)),
                  const SizedBox(width: 4),
                  Text(
                    '$visitedCount / $totalCount スポット',
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 次のスポットまでの距離 or 完了メッセージ
              if (isComplete)
                const Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 13,
                      color: Color(0xFFB8860B),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '冒険完了！',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else if (distanceToNext != null)
                Row(
                  children: [
                    const Icon(
                      Icons.navigation,
                      size: 13,
                      color: Color(0xFFC8A97A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '次まで ${_formatDistance(distanceToNext!)}',
                      style: const TextStyle(
                        color: Color(0xFFC8A97A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 8),

          // ── 下段：プログレスバー ──
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF4A3728),
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? const Color(0xFFB8860B) : const Color(0xFF57D6C9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 距離を見やすい形式に変換
  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
    return '${meters.toInt()}m';
  }
}
