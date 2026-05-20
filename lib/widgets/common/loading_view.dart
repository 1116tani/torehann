// lib/widgets/common/loading_view.dart
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = '世界を再構築中...', // 冒険にぴったりなデフォルトメッセージ
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withOpacity(0.75), // 画面全体を薄暗くして集中させる
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ネオンカラーで綺麗に光るぐるぐるインジケーター
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              strokeWidth: 4.0,
            ),
            const SizedBox(height: 24),
            // ローディング中のメッセージ
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
