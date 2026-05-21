// lib/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';
import '../router/app_router.dart';
import '../constants/app_sizes.dart';
import '../widgets/result/adventure_title_card.dart';
import '../widgets/result/stat_panel.dart';
import '../widgets/result/share_button.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    final route = navState.currentRoute;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318),
      body: SafeArea(
        child: Column(
          children: [
            // ── ヘッダー ──
            _buildHeader(context, ref),

            // ── スクロールエリア（メインコンテンツ） ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.p8),

                    // ── AIタイトルカード ──
                    AdventureTitleCard(
                      // TODO: Gemini連携後に差し替え
                      title: route?.themeName ?? '名もなき冒険の記録',
                      themeName: route?.themeName ?? '—',
                      adventureDate: navState.adventureStartTime,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── AI冒険日誌 ──
                    _buildAiReport(),
                    const SizedBox(height: AppSizes.p16),

                    // ── 統計パネル ──
                    StatPanel(
                      distanceKm: route?.totalDistance ?? 0.0,
                      durationMinutes: route?.estimatedTime ?? 0,
                      spotCount: navState.visitedSpotIds.length,
                      // steps は Tier A実装後に渡す
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── シェアボタン ──
                    ShareButton(
                      adventureTitle: route?.themeName ?? '名もなき冒険',
                      distanceKm: route?.totalDistance ?? 0.0,
                      durationMinutes: route?.estimatedTime ?? 0,
                      spotCount: navState.visitedSpotIds.length,
                    ),
                    const SizedBox(height: AppSizes.p32),
                  ],
                ),
              ),
            ),

            // ── 下部固定：ホームへ戻るボタン ──
            _buildHomeButton(context, ref),
          ],
        ),
      ),
    );
  }

  // ── ヘッダー ──────────────────────────────
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF4A3728),
        border: Border(
          bottom: BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
      ),
      child: const Column(
        children: [
          Text(
            '冒険完了',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5EDD8),
            ),
          ),
          Text(
            'ADVENTURE RESULT',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFC8A97A),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ── AI冒険日誌 ────────────────────────────
  Widget _buildAiReport() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDD8),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ラベル
          Row(
            children: [
              const Text('✍️', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              const Text(
                'AI冒険日誌',
                style: TextStyle(
                  color: Color(0xFF4A2A00),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8860B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB8860B),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  'Gemini生成',
                  style: TextStyle(
                    color: Color(0xFFB8860B),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFC8A97A), height: 1),
          const SizedBox(height: 12),

          // 本文（TODO: Gemini連携後に差し替え）
          const Text(
            'あなたは今日、見慣れた街の中に隠された小さな物語を見つけました。風の広場を抜け、路地の奥で新しい発見に出会う冒険でした。街の断片がひとつひとつ積み重なり、やがて大きな物語になっていく。',
            style: TextStyle(
              color: Color(0xFF4A2A00),
              fontSize: 14,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // ── ホームへ戻るボタン ─────────────────────
  Widget _buildHomeButton(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),
        border: Border(top: BorderSide(color: Color(0xFFC8A97A), width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB8860B),
            padding: const EdgeInsets.all(AppSizes.p16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          onPressed: () {
            // 冒険状態をリセットしてホームへ
            ref.read(navigationProvider.notifier).finishAdventure();
            context.go(AppRoutes.home);
          },
          child: const Text(
            '拠点（ホーム）に戻る',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
