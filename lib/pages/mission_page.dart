// lib/pages/mission_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../models/mission_model.dart';
import '../providers/mission_provider.dart';

import '../widgets/mission/mission_list_item.dart';
import '../widgets/mission/mission_tab_switch.dart';
import '../widgets/common/custom_header.dart';

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

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,

      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: '依頼掲示板',
              subtitle: 'MISSION BOARD',
            ),

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
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppColors.warning,
            ),

            const SizedBox(width: 10),

            Text(
              'EXP +$exp を獲得した！',
              style: TextStyle(
                color: colors.textPrimary,
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

    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),

      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '本日の達成状況',
                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),

              Text(
                '$completedCount / $totalCount',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,

              backgroundColor: colors.background,

              valueColor: AlwaysStoppedAnimation(
                colors.primary,
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
    final colors = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 52,
              color: colors.secondary,
            ),

            const SizedBox(height: 18),

            Text(
              '現在受注中の依頼はありません',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '新しい依頼が届くまで、\n酒場で少し休憩しましょう。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMuted,
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