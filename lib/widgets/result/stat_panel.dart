// lib/widgets/result/stat_panel.dart

import 'package:flutter/material.dart';

class StatPanel extends StatelessWidget {
  final double distanceKm; // 歩いた距離（km）
  final int durationMinutes; // 冒険時間（分）
  final int spotCount; // 訪問したスポット数
  final int steps; // 歩数（Tier A・ない時は0）

  const StatPanel({
    super.key,
    required this.distanceKm,
    required this.durationMinutes,
    required this.spotCount,
    this.steps = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── セクションラベル ──
          const Row(
            children: [
              Icon(Icons.bar_chart, size: 14, color: Color(0xFFC8A97A)),
              SizedBox(width: 6),
              Text(
                '冒険の記録',
                style: TextStyle(
                  color: Color(0xFFC8A97A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── メイン統計（2×2グリッド） ──
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.route,
                  label: '移動距離',
                  value: distanceKm.toStringAsFixed(1),
                  unit: 'km',
                  isHighlight: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  icon: Icons.timer_outlined,
                  label: '冒険時間',
                  value: _formatDuration(durationMinutes),
                  unit: '',
                  isHighlight: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.place_outlined,
                  label: 'スポット',
                  value: '$spotCount',
                  unit: '箇所',
                  isHighlight: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: steps > 0
                    // 歩数あり（Tier A実装後）
                    ? _StatItem(
                        icon: Icons.directions_walk,
                        label: '歩数',
                        value: _formatSteps(steps),
                        unit: '歩',
                        isHighlight: false,
                      )
                    // 歩数なし（ハッカソン時はグレーアウト）
                    : _StatItemLocked(label: '歩数'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '$h時間$m分' : '$h時間';
    }
    return '$minutes分';
  }

  String _formatSteps(int steps) {
    if (steps >= 10000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return '$steps';
  }
}

// ── 統計アイテム ──────────────────────────────
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final bool isHighlight;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFF2C1F0E) : const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? const Color(0xFFB8860B)
              : const Color(0xFF4A3728),
          width: isHighlight ? 1 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベル
          Row(
            children: [
              Icon(
                icon,
                size: 12,
                color: isHighlight
                    ? const Color(0xFFB8860B)
                    : const Color(0xFF7A5C3A),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isHighlight
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF7A5C3A),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 数値
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isHighlight
                      ? const Color(0xFFB8860B)
                      : const Color(0xFFF5EDD8),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: isHighlight
                          ? const Color(0xFFB8860B)
                          : const Color(0xFF7A5C3A),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── グレーアウト統計アイテム（未実装機能） ──
class _StatItemLocked extends StatelessWidget {
  final String label;

  const _StatItemLocked({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3028), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                size: 12,
                color: Color(0xFF4A3728),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF4A3728), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '---',
            style: TextStyle(
              color: Color(0xFF4A3728),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tier A以降で解放',
            style: TextStyle(color: Color(0xFF4A3728), fontSize: 9),
          ),
        ],
      ),
    );
  }
}
