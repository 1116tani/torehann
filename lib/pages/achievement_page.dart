//lib/pages/achievement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../models/achievement_model.dart';
import '../../providers/achievement_provider.dart';
import '../../widgets/achievement/achievement_card.dart';
import '../widgets/common/custom_header.dart';

class AchievementPage extends ConsumerWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final achievements = ref.watch(
      achievementListProvider,
    );

    final earnedCount = achievements
        .where(
          (a) =>
              a.currentRank != AchievementRank.none,
        )
        .length;

    return Scaffold(
      backgroundColor: colors.background,

      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: '実績',
              subtitle: 'ACHIEVEMENTS',
            ),
            // ── Header ──
            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),

              decoration: BoxDecoration(
                color: colors.surface,

                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),

                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  const Text(
                    '実績数',

                    style: TextStyle(
                      color: Color(0xFFC8A97A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,

                    children: [
                      const Text(
                        '解除済み ',

                        style: TextStyle(
                          color: Color(0xFFC8A97A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '$earnedCount',

                        style: const TextStyle(
                          color: Color(0xFFE5A93C),
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        ' / ${achievements.length}',

                        style: const TextStyle(
                          color: Color(0xFFE5D5BC),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(4),

                    child: LinearProgressIndicator(
                      value: achievements.isEmpty
                          ? 0
                          : earnedCount /
                              achievements.length,

                      backgroundColor:
                          Color(0xFF1C1610),

                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        Color(0xFFB8860B),
                      ),

                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Achievement List ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),

                itemCount: achievements.length,

                itemBuilder: (
                  context,
                  index,
                ) {
                  return AchievementCard(
                    achievement:
                        achievements[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}