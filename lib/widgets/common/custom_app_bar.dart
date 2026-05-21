// lib/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/colors.dart'; // 💡 AppColorsをインポート

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.textPrimary, // 💡 セピアホワイトに変更
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton && context.canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary, // 💡 アイコンも統一
                size: 20,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
