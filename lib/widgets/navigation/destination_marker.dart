// lib/widgets/navigation/destination_marker.dart

import 'package:flutter/material.dart';
import '../../models/spot_model.dart';

class DestinationMarker extends StatelessWidget {
  final SpotModel spot; // 次の目的地スポット
  final double? distanceToSpot; // 距離（m）
  final bool isNearby; // 20m以内かどうか

  const DestinationMarker({
    super.key,
    required this.spot,
    this.distanceToSpot,
    this.isNearby = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isNearby
            ? const Color(0xFF1A3A2A).withValues(alpha: 0.85) // 近くにいる時は緑っぽく
            : const Color(0xFF3D2B1F).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNearby ? const Color(0xFF57D6C9) : const Color(0xFFC8A97A),
          width: isNearby ? 1.5 : 0.5,
        ),
        boxShadow: isNearby
            ? [
                BoxShadow(
                  color: const Color(0xFF57D6C9).withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // ── アイコン ──
          _SpotIcon(isNearby: isNearby, category: spot.category),
          const SizedBox(width: 12),

          // ── スポット情報 ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 近くにいる時のバナー
                if (isNearby) ...[
                  const Text(
                    '📍 到達しました！',
                    style: TextStyle(
                      color: Color(0xFF57D6C9),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],

                // AIが付けた物語風の名前
                Text(
                  spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name,
                  style: TextStyle(
                    color: isNearby ? Colors.white : const Color(0xFFF5EDD8),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // 実際のスポット名
                if (spot.aiStoryName.isNotEmpty)
                  Text(
                    spot.name,
                    style: const TextStyle(
                      color: Color(0xFF7A5C3A),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                // フレーバーテキスト（近くにいる時だけ表示）
                if (isNearby && spot.aiFlavorText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    spot.aiFlavorText,
                    style: const TextStyle(
                      color: Color(0xFF57D6C9),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── 距離表示 ──
          if (distanceToSpot != null && !isNearby)
            _DistanceBadge(distance: distanceToSpot!),
        ],
      ),
    );
  }
}

// ── スポットアイコン ──────────────────────────
class _SpotIcon extends StatelessWidget {
  final bool isNearby;
  final String category;

  const _SpotIcon({required this.isNearby, required this.category});

  @override
  Widget build(BuildContext context) {
    final icon = _iconForCategory(category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isNearby
            ? const Color(0xFF57D6C9).withValues(alpha: 0.2)
            : const Color(0xFFB8860B).withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: isNearby ? const Color(0xFF57D6C9) : const Color(0xFFB8860B),
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        size: 22,
        color: isNearby ? const Color(0xFF57D6C9) : const Color(0xFFB8860B),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    return switch (category) {
      'カフェ' => Icons.coffee,
      '公園' => Icons.park,
      '神社' => Icons.temple_buddhist,
      '史跡' => Icons.account_balance,
      '商店街' => Icons.storefront,
      '路地裏' => Icons.turn_right,
      _ => Icons.place,
    };
  }
}

// ── 距離バッジ ──────────────────────────────
class _DistanceBadge extends StatelessWidget {
  final double distance;

  const _DistanceBadge({required this.distance});

  String get _label {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
    return '${distance.toInt()}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7A5C3A), width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.navigation, size: 12, color: Color(0xFFC8A97A)),
          const SizedBox(height: 2),
          Text(
            _label,
            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
