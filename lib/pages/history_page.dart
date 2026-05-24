// lib/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/history_provider.dart';
import '../router/app_router.dart';

import '../widgets/history/history_card.dart';
import '../widgets/history/history_filter_bar.dart';
import '../widgets/history/history_summary.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state =
        ref.watch(historyProvider);

    final notifier =
        ref.read(
      historyProvider.notifier,
    );

    final filtered =
        state.filteredHistories;

    return Scaffold(
      backgroundColor:
          const Color(0xFF1C1610),

      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────
            // ヘッダー
            // ─────────────────────

            _buildHeader(context),

            // ─────────────────────
            // サマリー
            // ─────────────────────

            HistorySummary(
              totalCount:
                  state.totalCount,

              totalDistanceKm:
                  state.totalDistanceKm,
            ),

            // ─────────────────────
            // フィルター
            // ─────────────────────

            HistoryFilterBar(
              activeFilters:
                  state.activeFilters,

              onToggle:
                  notifier.toggleFilter,
            ),

            // ─────────────────────
            // 履歴リスト
            // ─────────────────────

            Expanded(
              child: filtered.isEmpty
                  ? _buildEmpty(
                      context,
                    )
                  : ListView.builder(
                      physics:
                          const BouncingScrollPhysics(),

                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        24,
                      ),

                      itemCount:
                          filtered.length,

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final history =
                            filtered[
                                index];

                        return HistoryCard(
                          history:
                              history,

                          onTap: () {
                            context.go(
                              AppRoutes
                                  .result,
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

  // ─────────────────────────────
  // ヘッダー
  // ─────────────────────────────

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFF2C2318,
        ),

        border: Border(
          bottom: BorderSide(
            color:
                const Color(
              0xFFC8A97A,
            ).withValues(alpha: 0.25),

            width: 0.6,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.18),

            blurRadius: 8,

            offset:
                const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: Stack(
        alignment:
            Alignment.center,

        children: [
          // 戻るボタン
          Positioned(
            left: 0,

            child: GestureDetector(
              onTap: () =>
                  context.pop(),

              child: Container(
                width: 38,
                height: 38,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF3D2B1F,
                  ),

                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color:
                        const Color(
                      0xFF5C4033,
                    ),
                    width: 0.6,
                  ),
                ),

                child: const Icon(
                  Icons
                      .arrow_back_ios_new_rounded,

                  size: 16,

                  color: Color(
                    0xFFC8A97A,
                  ),
                ),
              ),
            ),
          ),

          // タイトル
          const Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Text(
                '冒険履歴',

                style: TextStyle(
                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,

                  color: Color(
                    0xFFF5EDD8,
                  ),

                  letterSpacing:
                      1.2,
                ),
              ),

              SizedBox(height: 4),

              Text(
                'ADVENTURE LOG',

                style: TextStyle(
                  fontSize: 11,

                  color: Color(
                    0xFFC8A97A,
                  ),

                  letterSpacing:
                      3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────
  // 空状態
  // ─────────────────────────────

  Widget _buildEmpty(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF2C2318,
                ),

                shape:
                    BoxShape.circle,

                border:
                    Border.all(
                  color:
                      const Color(
                    0xFF5C4033,
                  ),
                ),
              ),

              child: const Center(
                child: Text(
                  '📜',

                  style:
                      TextStyle(
                    fontSize:
                        42,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              'まだ冒険の記録がありません',

              style: TextStyle(
                color: Color(
                  0xFFF5EDD8,
                ),

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              '地図はまだ白紙です。\n最初の冒険へ出発しましょう。',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color: Color(
                  0xFF7A5C3A,
                ),

                fontSize: 13,

                height: 1.7,
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            ElevatedButton.icon(
              onPressed: () {
                context.go(
                  AppRoutes
                      .adventureSetting,
                );
              },

              icon: const Icon(
                Icons.explore_rounded,
              ),

              label: const Text(
                '冒険に出発する',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFB8860B,
                ),

                foregroundColor:
                    Colors.white,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}