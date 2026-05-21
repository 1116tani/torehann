// lib/pages/history/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';
import '../../widgets/history/history_card.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerのストリームを常に監視（watch）するよ
    final historyAsyncValue = ref.watch(adventureHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610), // アプリ全体のダークな世界観の背景色
      appBar: AppBar(
        title: const Text(
          '✦ 冒険の軌跡 ✦',
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
      body: historyAsyncValue.when(
        // ── 💡 データが正常に届いたとき ──
        data: (snapshot) {
          final docs = snapshot;

          // まだ一回も冒険に出ていないとき（空っぽの時）
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📖', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  const Text(
                    'まだ刻まれた記憶がありません。',
                    style: TextStyle(color: Color(0xFF7A5C3A), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '新しい冒険の物語を作りに行こう？',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFC8A97A).withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }

          // 履歴リストの表示
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              return HistoryCard(historyData: data);
            },
          );
        },

        // ── 💡 ローディング中のとき ──
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFB8860B)),
              SizedBox(height: 16),
              Text(
                '過去の記憶の断片をあつめています...',
                style: TextStyle(color: Color(0xFFC8A97A), fontSize: 12),
              ),
            ],
          ),
        ),

        // ── 💡 エラーが発生しちゃったとき ──
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 12),
                Text(
                  '記憶の呼び出しに失敗しちゃったみたい…\n$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFC8A97A),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
