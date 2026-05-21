// lib/pages/navigation_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';
import '../providers/location_provider.dart'; // 💡 GPS監視のために追加
import '../router/app_router.dart';
import '../constants/app_sizes.dart';

class NavigationPage extends ConsumerWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    // 🛰️ 魔法の一行：GPSが動くたびに、ナビ状態の距離計算を自動で走らせるよ！
    ref.listen(locationProvider, (previous, next) {
      final position = next.value;
      if (position != null) {
        ref.read(navigationProvider.notifier).updateLocation(position);
      }
    });

    // ── 冒険が始まっていない時のセーフガード ──
    if (!navState.isAdventureStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C2318),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '謎の霧に包まれている...\n（冒険が開始されていません）',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 16),
              ),
              const SizedBox(height: AppSizes.p24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8A97A),
                  foregroundColor: const Color(0xFF2C2318),
                ),
                child: const Text('拠点（ホーム）に戻る'),
              ),
            ],
          ),
        ),
      );
    }

    final isCompleted = navState.nextSpot == null;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318), // ダークセピア
      appBar: AppBar(
        title: Text(
          navState.currentRoute?.themeName ?? '未知の探索路',
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF3D2B1F),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFF5EDD8)),
          onPressed: () {
            // 途中リタイアの確認ダイアログを入れても可愛いね♡
            navNotifier.finishAdventure();
            context.go(AppRoutes.home);
          },
        ),
      ),
      body: Stack(
        children: [
          // 💡 ここにあとで `FogEffectOverlay`（霧エフェクト）や背景マップを敷くと超エモいよ！
          Column(
            children: [
              // ── 進行度プログレスバー ──
              LinearProgressIndicator(
                value: navState.progress,
                backgroundColor: const Color(0xFF3D2B1F),
                color: const Color(0xFFC8A97A), // セピアゴールド
                minHeight: 6,
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p24,
                      vertical: AppSizes.p32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSizes.p16),

                        // ── 羅針盤・コンパスの仮配置エリア ──
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF3D2B1F),
                            border: Border.all(
                              color: const Color(0xFFC8A97A),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons
                                .explore, // widgets/navigation/compass_widget.dart に差し替え可能
                            size: 80,
                            color: Color(0xFFC8A97A),
                          ),
                        ),

                        const SizedBox(height: AppSizes.p32),

                        // ── ナビゲーションメインカード ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSizes.p24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D2B1F).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),
                            border: Border.all(
                              color: const Color(0xFF4A3728),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              if (!isCompleted) ...[
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFFC8A97A),
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '現在の調査対象',
                                      style: TextStyle(
                                        color: Color(0xFF7A5C3A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.p12),
                                Text(
                                  navState.nextSpot!.aiStoryName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFF5EDD8),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.p16),
                                const Divider(
                                  color: Color(0xFF4A3728),
                                  thickness: 1,
                                ),
                                const SizedBox(height: AppSizes.p16),
                                const Text(
                                  '目的地までの残り距離',
                                  style: TextStyle(
                                    color: Color(0xFF7A5C3A),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  navState.distanceToNextSpot != null
                                      ? '${navState.distanceToNextSpot!.toStringAsFixed(0)} m'
                                      : '探知中...',
                                  style: const TextStyle(
                                    color: Color(0xFFC8A97A),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace', // 数字の幅を統一
                                  ),
                                ),
                                const SizedBox(height: AppSizes.p8),
                                Text(
                                  '※20m以内に近づくと自動でチェックインされるよ！',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFF5EDD8,
                                    ).withValues(alpha: 0.5),
                                    fontSize: 11,
                                  ),
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.auto_awesome,
                                  size: 48,
                                  color: Color(0xFFC8A97A),
                                ),
                                const SizedBox(height: AppSizes.p16),
                                const Text(
                                  '調査任務コンプリート！',
                                  style: TextStyle(
                                    color: Color(0xFFF5EDD8),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.p12),
                                const Text(
                                  'この地のすべての断片（テール）を記録しました。拠点へ戻って成果を確認しましょう！',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF7A5C3A),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSizes.p24),

                        // 📸 カメラ起動ボタンの仮配置（widgets/navigation/camera_button.dart）
                        if (!isCompleted)
                          IconButton(
                            icon: const Icon(Icons.photo_camera, size: 36),
                            color: const Color(0xFFF5EDD8).withValues(alpha: 0.7),
                            onPressed: () {
                              // ハッカソン用のカメラモック処理
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('📷 パシャリ！街の断片を写真に収めた！'),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 最下部固定：冒険完了ボタン ──
              Padding(
                padding: const EdgeInsets.all(AppSizes.p24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    // 💡 すべて巡り終えた時だけボタンが押せるように制御！
                    onPressed: isCompleted
                        ? () {
                            // 完了データを残したまま結果画面へ！（finishはリザルト側か、ここで遷移後に呼ぶのが吉）
                            context.go(AppRoutes.result);
                          }
                        : null, // 条件を満たさない時は自動でグレーアウトされるよ♡
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC8A97A),
                      foregroundColor: const Color(0xFF2C2318),
                      disabledBackgroundColor: const Color(0xFF3D2B1F), // 無効時の色
                      disabledForegroundColor: const Color(0xFF7A5C3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        side: BorderSide(
                          color: isCompleted
                              ? Colors.transparent
                              : const Color(0xFF4A3728),
                        ),
                      ),
                      elevation: isCompleted ? 4 : 0,
                    ),
                    child: Text(
                      isCompleted ? '冒険の記録を報告する' : 'すべてのスポットを調査してください',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
