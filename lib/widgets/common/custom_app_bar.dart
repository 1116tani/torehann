// lib/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent, // 背景を透明にして世界観を壊さないようにする
      elevation: 0,
      leading: showBackButton && context.canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => context.pop(), // GoRouterでの安全な画面戻り
            )
          : null,
      actions: actions,
    );
  }

  // AppBarの標準的な高さを指定する
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
