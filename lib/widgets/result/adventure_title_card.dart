// lib/widgets/result/adventure_title_card.dart

import 'package:flutter/material.dart';

class AdventureTitleCard extends StatelessWidget {
  final String title; // AIが生成した冒険タイトル
  final String themeName; // ルートのテーマ名
  final DateTime? adventureDate; // 冒険した日付

  const AdventureTitleCard({
    super.key,
    required this.title,
    required this.themeName,
    this.adventureDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB8860B), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8860B).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── 上部装飾 ──
          const _GoldDivider(),
          const SizedBox(height: 16),

          // ── 日付 ──
          if (adventureDate != null)
            Text(
              _formatDate(adventureDate!),
              style: const TextStyle(
                color: Color(0xFF7A5C3A),
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          const SizedBox(height: 8),

          // ── 巻物アイコン ──
          const Text('📜', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 12),

          // ── AIが生成したタイトル（メイン） ──
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // ── テーマ名（サブ） ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2318),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
            ),
            child: Text(
              themeName,
              style: const TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const _GoldDivider(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}年${date.month}月${date.day}日（$weekday）';
  }
}

// ── 金色の装飾ライン ──────────────────────────
class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _line(),
        const SizedBox(width: 8),
        const Text(
          '✦',
          style: TextStyle(color: Color(0xFFB8860B), fontSize: 12),
        ),
        const SizedBox(width: 8),
        _line(),
      ],
    );
  }

  Widget _line() {
    return Container(width: 60, height: 0.5, color: const Color(0xFFB8860B));
  }
}
