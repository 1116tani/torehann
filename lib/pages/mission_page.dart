// lib/pages/mission_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mission_model.dart';
import '../providers/mission_provider.dart';

import '../widgets/mission/mission_list_item.dart';
import '../widgets/mission/mission_tab_switch.dart';

class MissionPage extends ConsumerWidget {
  const MissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(missionTabProvider);

    final missions = ref.watch(missionListProvider);

    final notifier = ref.read(missionListProvider.notifier);

    final filtered = missions
        .where((m) => m.type == currentTab)
        .toList();

    final completedCount = filtered
        .where((m) => m.status == MissionStatus.claimed)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      body: SafeArea(
        child: Column(
          children: [
            // ── ヘッダー ───────────────────
            _MissionHeader(
              completedCount: completedCount,
              totalCount: filtered.length,
            ),

            const SizedBox(height: 18),

            // ── タブ切り替え ───────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MissionTabSwitch(
                currentTab: currentTab,
                onChanged: (type) {
                  ref.read(missionTabProvider.notifier).state = type;
                },
              ),
            ),

            const SizedBox(height: 18),

            // ── リスト ───────────────────
            Expanded(
              child: filtered.isEmpty
                  ? const _MissionEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final mission = filtered[index];

                        return MissionListItem(
                          mission: mission,

                          onClaim: () {
                            notifier.claimReward(mission.id);

                            _showRewardEffect(
                              context,
                              mission.rewardExp,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── 報酬受け取り演出 ─────────────────
  void _showRewardEffect(
    BuildContext context,
    int exp,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2C2318),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFFFD700),
            ),

            const SizedBox(width: 10),

            Text(
              'EXP +$exp を獲得した！',
              style: const TextStyle(
                color: Color(0xFFF5EDD8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── ヘッダー ─────────────────────────────
class _MissionHeader extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const _MissionHeader({
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0
        ? 0.0
        : completedCount / totalCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),

      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),

        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4A3728),
            width: 0.5,
          ),
        ),
      ),

      child: Column(
        children: [
          const Text(
            '✦ ギルド依頼掲示板 ✦',
            style: TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'MISSION BOARD',
            style: TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 10,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '本日の達成状況',
                style: TextStyle(
                  color: Color(0xFF7A5C3A),
                  fontSize: 12,
                ),
              ),

              Text(
                '$completedCount / $totalCount',
                style: const TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,

              backgroundColor: const Color(0xFF1C1610),

              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFB8860B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── 空状態 ───────────────────────────────
class _MissionEmpty extends StatelessWidget {
  const _MissionEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 52,
              color: Color(0xFF5C4033),
            ),

            const SizedBox(height: 18),

            const Text(
              '現在受注中の依頼はありません',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '新しい依頼が届くまで、\n酒場で少し休憩しましょう。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7A5C3A),
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}