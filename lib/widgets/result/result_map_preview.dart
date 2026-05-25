// lib/widgets/result/result_map_preview.dart

import 'package:flutter/material.dart';

class ResultMapPreview extends StatelessWidget {
  final String imageUrl;
  final double distanceKm;
  final int durationMinutes;

  const ResultMapPreview({
    super.key,
    required this.imageUrl,
    required this.distanceKm,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Stack(
        children: [
          // ── マップ画像 ─────────────────
          AspectRatio(
            aspectRatio: 1.15,

            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,

              loadingBuilder: (
                context,
                child,
                progress,
              ) {
                if (progress == null) {
                  return child;
                }

                return Container(
                  color: const Color(0xFF2C2318),

                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFB8860B),
                    ),
                  ),
                );
              },

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: const Color(0xFF2C2318),

                  child: const Center(
                    child: Icon(
                      Icons.map_outlined,
                      color: Color(0xFF7A5C3A),
                      size: 42,
                    ),
                  ),
                );
              },
            ),
          ),

          // ── 上グラデーション ───────────
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],

                    stops: const [
                      0,
                      0.45,
                      1,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── タイトル ─────────────────
          const Positioned(
            top: 20,
            left: 20,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'ADVENTURE ROUTE',
                  style: TextStyle(
                    color: Color(0xFFC8A97A),
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  '冒険の軌跡',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ── 下部ステータス ────────────
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,

                children: [
                  _InfoItem(
                    icon: Icons.route_rounded,
                    label: '移動距離',
                    value:
                        '${distanceKm.toStringAsFixed(1)} km',
                  ),

                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),

                  _InfoItem(
                    icon: Icons.schedule_rounded,
                    label: '冒険時間',
                    value: '$durationMinutes 分',
                  ),
                ],
              ),
            ),
          ),

          // ── キラキラ ─────────────────
          const Positioned(
            top: 26,
            right: 26,

            child: Icon(
              Icons.auto_awesome,
              color: Color(0xFFFFD700),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// 📊 情報表示
// ─────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: const Color(
              0xFFB8860B,
            ).withValues(alpha: 0.15),
          ),

          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFFB8860B),
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}