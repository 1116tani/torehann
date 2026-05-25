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

    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9), // メニュー背景
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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

              const SizedBox(height: 30),
              const Text(
                "冒険のログ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuItem(context, theme, Icons.emoji_events, "実績", AppRoutes.achievement),
                  _buildMenuItem(context, theme, Icons.auto_stories, "街の断片", AppRoutes.collection),
                  _buildMenuItem(context, theme, Icons.history, "履歴", AppRoutes.history),
                  _buildMenuItem(context, theme, Icons.settings, "設定", AppRoutes.settings),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "ギルド拡張（準備中）",
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
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
        opacity: isLocked ? 0.3 : 1.0,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.border.withValues(alpha: 0.5)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLocked
                      ? Colors.transparent
                      : theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isLocked ? AppColors.textMuted : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
