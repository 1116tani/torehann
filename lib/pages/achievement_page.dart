// lib/pages/achievement/achievement_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/achievement_provider.dart';
import '../../widgets/achievement/achievement_card.dart';

class AchievementPage extends ConsumerWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 15種の実績リストを取得
    final achievements = ref.watch(achievementListProvider);

    // 銅以上のランクをいくつ達成しているかカウントするよ
    final earnedCount = achievements
        .where((a) => a.currentRank != AchievementRank.none)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610), // 重厚な背景
      appBar: AppBar(
        title: const Text(
          '✦ 魂の勲章 ✦',
          style: TextStyle(
            color: Color(0xFFF5EDD8),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C2318),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFC8A97A)),
      ),
      body: Column(
        children: [
          // ── 👑 総達成率を表すラグジュアリーなヘッダー ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF2C2318),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '現在の実績達成度',
                  style: TextStyle(
                    color: Color(0xFF7A5C3A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$earnedCount',
                      style: const TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif', // ゲームっぽい雰囲気をちょっとプラス
                      ),
                    ),
                    Text(
                      ' / ${achievements.length}',
                      style: const TextStyle(
                        color: Color(0xFFC8A97A),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '個解放',
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 全体の進捗率をゲージ化
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: achievements.isEmpty
                        ? 0
                        : earnedCount / achievements.length,
                    backgroundColor: const Color(0xFF1C1610),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFB8860B),
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── 📜 実績カードの無限リスト ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24, top: 4),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return AchievementCard(achievement: achievements[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
