// lib/widgets/home/home_draggable_menu.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/route_names.dart';
import '../../utils/colors.dart';
import 'adventure_start_button.dart';

import '../common/torenyan.dart';

class HomeDraggableMenu extends StatelessWidget {
  const HomeDraggableMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      // 💡 透明エリアを作った分、シート全体のサイズを底上げしているよ！
      initialChildSize: 0.42,
      minChildSize: 0.35,
      maxChildSize: 0.74,
      builder: (context, scrollController) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 💡 背景を Column で包んで、上にトレにゃん用の「透明な空間」を作るよ！
            Column(
              children: [
                // 当たり判定を広げるための透明エリア（170px分）
                const SizedBox(height: 170),

                // ここから下が、暗いメニュー背景！
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D150F).withValues(alpha: 0.97),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.textMuted,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const AdventureStartButton(),

                        const SizedBox(height: 32),
                        const Text(
                          "冒険のログ",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.emoji_events,
                              "実績",
                              AppRoutes.achievement,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.auto_stories,
                              "街の断片",
                              AppRoutes.collection,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.history,
                              "履歴",
                              AppRoutes.history,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.settings,
                              "設定",
                              AppRoutes.settings,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "ギルド拡張（準備中）",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.people,
                              "フレンド",
                              AppRoutes.friends,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.favorite,
                              "健康管理",
                              AppRoutes.health,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.flag,
                              "ミッション",
                              AppRoutes.mission,
                            ),
                            _buildMenuItem(
                              context,
                              theme,
                              Icons.group,
                              "パーティ",
                              AppRoutes.party,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 🐱 トレにゃんは透明エリアの最上部（top: 0）に配置するよ！
            const Positioned(
              top: 10,
              left: 15,
              child: Torenyan(
                size: 200,
                state: TorenyanState.idle,
                enableTap: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String label,
    String? route, {
    bool isLocked = false,
  }) {
    return InkWell(
      onTap: isLocked || route == null ? null : () => context.push(route),
      child: Opacity(
        opacity: isLocked ? 0.35 : 1.0,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.border.withValues(alpha: 0.5)
                    : theme.colorScheme.primary.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked
                      ? Colors.transparent
                      : theme.colorScheme.primary.withValues(alpha: 0.45),
                  width: 1.2,
                ),
              ),
              child: Icon(
                icon,
                color: isLocked
                    ? AppColors.textMuted
                    : theme.colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
