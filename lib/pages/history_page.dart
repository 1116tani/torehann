// lib/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../providers/history_provider.dart';
import '../providers/result_provider.dart';
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

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,

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
                            ref.read(resultProvider.notifier).setResult(history.toResult());
                            context.push(
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
    final colors = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.border,
                ),
              ),
              child: const Center(
                child: Text(
                  '📜',
                  style: TextStyle(
                    fontSize: 52,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'まだ冒険の記録がありません',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              '地図はまだ白紙です。\n最初の冒険へ出発しましょう。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.go(
                  AppRoutes.adventureSetting,
                );
              },
              icon: const Icon(
                Icons.explore_rounded,
                size: 22,
              ),
              label: const Text(
                '冒険に出発する',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textDark
                    : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
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
