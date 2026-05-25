// lib/widgets/result/ai_story_scroll.dart

import 'package:flutter/material.dart';

class AIStoryScroll extends StatelessWidget {
  final String story;

  const AIStoryScroll({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [
            Color(0xFF3A2C1F),
            Color(0xFF241A12),
          ],
        ),

        border: Border.all(
          color: Color(0xFF6A4B2A),
          width: 0.8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ── 背景模様 ───────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.05,

                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 240,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ── 本文 ─────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              26,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // タイトル
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: const Color(
                          0xFFB8860B,
                        ).withValues(alpha: 0.16),
                      ),

                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Color(0xFFB8860B),
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'AI Adventure Report',
                          style: TextStyle(
                            color: Color(0xFF7A5C3A),
                            fontSize: 10,
                            letterSpacing: 1.6,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          '冒険譚',
                          style: TextStyle(
                            color: Color(0xFFF5EDD8),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // 区切り線
                Container(
                  height: 1,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(
                          0xFFC8A97A,
                        ).withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 本文
                Text(
                  story,
                  style: const TextStyle(
                    color: Color(0xFFE8DCC2),
                    fontSize: 14,
                    height: 2.1,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 28),

                // フッター
                Align(
                  alignment: Alignment.centerRight,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF1C1610,
                      ).withValues(alpha: 0.65),

                      borderRadius:
                          BorderRadius.circular(20),

                      border: Border.all(
                        color: const Color(
                          0xFF5C4033,
                        ),
                        width: 0.5,
                      ),
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFB8860B),
                          size: 13,
                        ),

                        SizedBox(width: 6),

                        Text(
                          'Generated by AI',
                          style: TextStyle(
                            color: Color(0xFF7A5C3A),
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}