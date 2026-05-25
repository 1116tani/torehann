// lib/widgets/result/result_footer_actions.dart

import 'package:flutter/material.dart';

class ResultFooterActions extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onBackHome;

  const ResultFooterActions({
    super.key,
    required this.onSave,
    required this.onShare,
    required this.onBackHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 保存ボタン ───────────────────
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSave,

            icon: const Icon(
              Icons.bookmark_rounded,
              size: 20,
            ),

            label: const Text(
              '思い出を保存する',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB8860B),
              foregroundColor: Colors.white,

              elevation: 0,

              padding: const EdgeInsets.symmetric(
                vertical: 18,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── シェア＆ホーム ──────────────
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShare,

                icon: const Icon(
                  Icons.share_rounded,
                  size: 18,
                ),

                label: const Text(
                  'シェア',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFFC8A97A),

                  side: const BorderSide(
                    color: Color(0xFF5C4033),
                  ),

                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBackHome,

                icon: const Icon(
                  Icons.home_rounded,
                  size: 18,
                ),

                label: const Text(
                  'ホーム',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFFC8A97A),

                  side: const BorderSide(
                    color: Color(0xFF5C4033),
                  ),

                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ── 雰囲気テキスト ───────────────
        const Text(
          'この冒険は、君の記憶の中へ静かに刻まれた。',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF7A5C3A),
            fontSize: 11,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}