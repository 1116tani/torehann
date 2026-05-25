// lib/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/result_provider.dart';

import '../widgets/result/adventure_title_card.dart';
import '../widgets/result/ai_story_scroll.dart';
import '../widgets/result/friend_party_strip.dart';
import '../widgets/result/photo_timeline.dart';
import '../widgets/result/result_footer_actions.dart';
import '../widgets/result/result_map_preview.dart';
import '../widgets/result/reward_popup.dart';
import '../widgets/result/stat_panel.dart';

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  bool _showRewardPopup = true;

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(resultProvider);
    final result = resultState.result;

    if (resultState.isLoading || result == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1C1610),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFB8860B),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ── ヘッダー ─────────────────
                _buildHeader(context),

                // ── スクロール ─────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── タイトルカード ─────
                        AdventureTitleCard(result: result),

                        const SizedBox(height: 26),

                        // ── マップ ───────────
                        ResultMapPreview(
                          imageUrl: result.routeMapImageUrl,
                          distanceKm: result.distanceKm,
                          durationMinutes: result.durationMinutes,
                        ),

                        const SizedBox(height: 30),

                        // ── AIレポート ───────
                        AIStoryScroll(story: result.aiStory),

                        const SizedBox(height: 30),

                        // ── フレンド ─────────
                        FriendPartyStrip(
                          friendNames: result.friends.map((f) => f.name).toList(),
                        ),

                        const SizedBox(height: 30),

                        // ── 写真タイムライン ──
                        PhotoTimeline(photos: result.photos),

                        const SizedBox(height: 30),

                        // ── 統計 ────────────
                        StatPanel(result: result),

                        const SizedBox(height: 32),

                        // ── フッターアクション ─
                        ResultFooterActions(
                          onSave: () {
                            ref.read(resultProvider.notifier).saveMemory();
                            _showSnackBar('冒険の記録を保存しました');
                          },
                          onShare: () {
                            ref.read(resultProvider.notifier).shareResult();
                            _showSnackBar('シェア機能は準備中です');
                          },
                          onBackHome: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 報酬ポップアップ ───────────
          if (_showRewardPopup)
            RewardPopup(
              exp: result.expGained,
              fragments: result.fragmentCount,
              onFinished: () {
                ref.read(resultProvider.notifier).claimReward();
                setState(() {
                  _showRewardPopup = false;
                });
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // Header
  // ─────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFC8A97A),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              const Text(
                'RESULT',
                style: TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 52,
                height: 1,
                color: const Color(0xFF5C4033),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // SnackBar
  // ─────────────────────────────────────

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2C2318),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
          ),
        ),
      ),
    );
  }
}
