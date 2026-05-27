// lib/widgets/navigation/navigation_complete_card.dart

import 'package:flutter/material.dart';

class NavigationCompleteCard extends StatelessWidget {
  final VoidCallback? onPressed;

  const NavigationCompleteCard({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F).withValues(alpha: 0.96),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: const Color(0xFFC8A97A), width: 1.5),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),

          BoxShadow(
            color: const Color(0xFFC8A97A).withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─────────────────────────────
          // ✨ アイコン
          // ─────────────────────────────
          Container(
            width: 72,
            height: 72,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: RadialGradient(
                colors: [
                  const Color(0xFFC8A97A).withValues(alpha: 0.28),
                  const Color(0xFFC8A97A).withValues(alpha: 0.05),
                ],
              ),

              border: Border.all(color: const Color(0xFFC8A97A), width: 1.4),
            ),

            child: const Icon(
              Icons.auto_awesome,
              size: 34,
              color: Color(0xFFE8D2A8),
            ),
          ),

          const SizedBox(height: 22),

          // ─────────────────────────────
          // 🏁 タイトル
          // ─────────────────────────────
          const Text(
            '探索完了',
            style: TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // ─────────────────────────────
          // 📖 説明
          // ─────────────────────────────
          const Text(
            'この街に眠っていた断片（テール）を\nすべて記録しました。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFD7C2A0),
              fontSize: 14,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            '旅の記録を整理して、拠点へ帰還しましょう。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9E8465),
              fontSize: 12,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          // ─────────────────────────────
          // 📜 ボタン
          // ─────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: onPressed,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8A97A),

                foregroundColor: const Color(0xFF2C2318),

                elevation: 4,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                shadowColor: const Color(0xFFC8A97A).withValues(alpha: 0.35),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_rounded, size: 20),

                  SizedBox(width: 10),

                  Text(
                    '冒険の記録を見る',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
