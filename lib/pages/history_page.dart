// lib/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/history_provider.dart';
import '../router/route_names.dart';

import '../widgets/history/history_card.dart';
import '../widgets/history/history_filter_bar.dart';
import '../widgets/history/history_summary.dart';
import '../widgets/common/custom_header.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state =
        ref.watch(historyProvider);

    final filtered =
        state.filteredHistories;

    return Scaffold(
      backgroundColor:
          const Color(0xFF1C1610),

      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: '冒険履歴',
              subtitle: 'ADVENTURE LOG',
            ),

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

            HistoryFilterBar(),

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
                              AppRoutes.result,
                              extra: {'isFromHistory': true},
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