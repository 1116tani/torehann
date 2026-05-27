// lib/widgets/navigation/destination_marker.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/spot_model.dart';

class DestinationMarker extends StatelessWidget {
  final SpotModel spot;
  final double? distanceToSpot;
  final bool isNearby;

  const DestinationMarker({
    super.key,
    required this.spot,
    this.distanceToSpot,
    this.isNearby = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isNearby ? const Color(0xCC143227) : const Color(0xAA1F1813),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isNearby
                  ? const Color(0xFF6FE7D8)
                  : const Color(0x55D6B06A),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              if (isNearby)
                BoxShadow(
                  color: const Color(0xFF6FE7D8).withValues(alpha: 0.18),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
          ),

          child: Row(
            children: [
              _SpotIcon(category: spot.category, isNearby: isNearby),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNearby) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x226FE7D8),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'DISCOVERED',
                          style: TextStyle(
                            color: Color(0xFF6FE7D8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isNearby
                            ? Colors.white
                            : const Color(0xFFF5EDD8),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),

                    if (spot.aiStoryName.isNotEmpty) ...[
                      const SizedBox(height: 4),

                      Text(
                        spot.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF9E8465),
                          fontSize: 12,
                        ),
                      ),
                    ],

                    if (spot.aiFlavorText.isNotEmpty) ...[
                      const SizedBox(height: 10),

                      Text(
                        spot.aiFlavorText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isNearby
                              ? const Color(0xFFA7FFF4)
                              : const Color(0xCCF5EDD8),
                          fontSize: 12,
                          height: 1.45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              if (distanceToSpot != null && !isNearby)
                _DistanceBadge(distance: distanceToSpot!),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────
// 📍 スポットアイコン
// ─────────────────────────────

class _SpotIcon extends StatelessWidget {
  final String category;
  final bool isNearby;

  const _SpotIcon({required this.category, required this.isNearby});

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isNearby
              ? [const Color(0x446FE7D8), const Color(0x22143227)]
              : [const Color(0x33D6B06A), const Color(0x11221813)],
        ),
        border: Border.all(
          color: isNearby ? const Color(0xFF6FE7D8) : const Color(0x88D6B06A),
          width: 1.4,
        ),
      ),
      child: Icon(
        icon,
        size: 26,
        color: isNearby ? const Color(0xFF6FE7D8) : const Color(0xFFD6B06A),
      ),
    );
  }

  IconData _getIcon() {
    return switch (category) {
      'カフェ' => Icons.coffee,
      '公園' => Icons.park,
      '神社' => Icons.temple_buddhist,
      '史跡' => Icons.account_balance,
      '商店街' => Icons.storefront,
      '路地裏' => Icons.route,
      '風景' => Icons.landscape,
      _ => Icons.place,
    };
  }
}

// ─────────────────────────────
// 🧭 距離表示
// ─────────────────────────────

class _DistanceBadge extends StatelessWidget {
  final double distance;

  const _DistanceBadge({required this.distance});

  String get label {
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }

    return '${distance.toInt()}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xAA18120E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x44D6B06A)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.navigation, size: 15, color: Color(0xFFD6B06A)),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
