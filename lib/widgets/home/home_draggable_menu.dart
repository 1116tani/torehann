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
      initialChildSize: 0.22,
      minChildSize: 0.15,
      maxChildSize: 0.54,
      builder: (context, scrollController) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1D150F).withValues(alpha: 0.97), // 💡 より暗い深セピア背景で視認性を強化
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35), // 💡 金枠を少し明るくクッキリ
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  color: AppColors.primary, // 💡 文字をゴールドに明るく
                  fontSize: 14, // 💡 12 → 14 (大きく)
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuItem(context, theme, Icons.emoji_events, "実績", AppRoutes.achievement),
                  _buildMenuItem(context, theme, Icons.auto_stories, "街の断片", AppRoutes.collection),
                  _buildMenuItem(context, theme, Icons.history, "履歴", AppRoutes.history),
                  _buildMenuItem(context, theme, Icons.settings, "設定", AppRoutes.settings),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "ギルド拡張（準備中）",
                style: TextStyle(
                  color: AppColors.textSecondary, // 💡 textMuted → textSecondary (明るく)
                  fontSize: 14, // 💡 12 → 14 (大きく)
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuItem(context, theme, Icons.people, "フレンド", AppRoutes.friends),
                  _buildMenuItem(context, theme, Icons.favorite, "健康管理", AppRoutes.health),
                  _buildMenuItem(context, theme, Icons.flag, "ミッション", AppRoutes.mission),
                  _buildMenuItem(context, theme, Icons.group, "パーティ", AppRoutes.party),
                ],
              ),
            ],
          ),
        ),
        
        // 🐱 ボトムシートの上に乗るトレにゃん（左側に大きく配置し、フチを掴んでいるように）
        const Positioned(
          top: -136, // 吹き出し + 猫本体がボトムシートのフチにかぶる高さ
          left: 24,
          child: Torenyan(
            size: 125, // 大きさを125に変更
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
              padding: const EdgeInsets.all(14), // 💡 12 → 14 (アイコン枠を大きく)
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.border.withValues(alpha: 0.5)
                    : theme.colorScheme.primary.withValues(alpha: 0.18), // 💡 枠内を少し明るく
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked
                      ? Colors.transparent
                      : theme.colorScheme.primary.withValues(alpha: 0.45), // 💡 枠線を明るく
                  width: 1.2,
                ),
              ),
              child: Icon(
                icon,
                color: isLocked ? AppColors.textMuted : theme.colorScheme.primary,
                size: 26, // 💡 アイコンサイズを大きく (24 → 26)
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary, // 💡 textSecondary → textPrimary (明るい羊皮紙色)
                fontSize: 12.5, // 💡 11 → 12.5 (文字を大きく)
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
