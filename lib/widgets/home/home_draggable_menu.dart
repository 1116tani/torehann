// lib/widgets/home/home_draggable_menu.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/route_names.dart';
import '../../utils/colors.dart';
import 'adventure_start_button.dart';

class HomeDraggableMenu extends StatelessWidget {
  const HomeDraggableMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.15,
      maxChildSize: 0.54,
      builder: (context, scrollController) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.background.withValues(alpha: 0.97), // 深セピア背景
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.35), // 金枠
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
                        color: colors.textMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const AdventureStartButton(),

                  const SizedBox(height: 32),
                  Text(
                    "冒険のログ",
                    style: TextStyle(
                      color: colors.primary, // ゴールド
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🌟 ログメニュー：1行目
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.emoji_events,
                        "実績",
                        AppRoutes.achievement,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.auto_stories,
                        "街の断片",
                        AppRoutes.collection,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.history,
                        "履歴",
                        AppRoutes.history,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.settings,
                        "設定",
                        AppRoutes.settings,
                      ),
                    ],
                  ),

                  // 💡 1行目と2行目の間の隙間を、Apple Map風にさらに広々と（36）したよ！
                  const SizedBox(height: 36),

                  // 🌟 ログメニュー：2行目
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.people,
                        "フレンド",
                        AppRoutes.friends,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.favorite,
                        "健康管理",
                        AppRoutes.health,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.flag,
                        "ミッション",
                        AppRoutes.mission,
                      ),
                      _buildMenuItem(
                        context,
                        Icons.group,
                        "パーティ",
                        AppRoutes.party,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    String? route, {
    bool isLocked = false,
  }) {
    final colors = AppColors.of(context);
    return Opacity(
      opacity: isLocked ? 0.35 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 💡 Apple Map風の完全な「正円」ボタンを作るコンテナ
          Container(
            width: 80, // 💡 横幅60固定！
            height: 80, // 💡 高さ60固定！
            decoration: BoxDecoration(
              color: isLocked
                  ? colors.border.withValues(alpha: 0.5)
                  : colors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle, // 💡 完全な丸型に指定
              border: Border.all(
                color: isLocked
                    ? Colors.transparent
                    : colors.primary.withValues(alpha: 0.45),
                width: 1.5, // 💡 枠線も少しだけクッキリに
              ),
            ),
            // 💡 丸い枠線の中だけでタップエフェクトが綺麗に起きるように設定
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLocked || route == null
                    ? null
                    : () => context.push(route),
                customBorder: const CircleBorder(), // 💡 タップの波紋も100%丸！
                child: Center(
                  child: Icon(
                    icon,
                    color: isLocked ? colors.textMuted : colors.primary,
                    size: 32, // 💡 30 → 32 (さらに大きく、枠いっぱいに！)
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // 💡 ボタンと文字の間も少しだけ広げて見やすく
          Text(
            label,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 18, // 💡 14 → 14.5 (実機でパッと読める大きさに！)
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
