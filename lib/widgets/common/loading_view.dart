// lib/widgets/common/loading_view.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart'; // 💡 AppColorsをインポート

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = '街の記憶を読み解き中...', // 💡 魔法探索っぽいメッセージに！
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 💡 真っ黒じゃなくて、ダークセピアの闇色で包み込むよ
      color: AppColors.background.withValues(alpha: 0.85),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ), // 💡 ゴールドの光
              strokeWidth: 4.0,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.primaryLight, // 💡 羊皮紙ホワイト
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
