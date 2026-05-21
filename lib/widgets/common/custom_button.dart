// lib/widgets/common/custom_button.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart'; // 💡 AppColorsをインポート

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // 💡 null許容にして無効化できるようにしたよ
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        // 💡 無効時は暗い茶色、有効時はアンティークゴールドのグラデーション
        gradient: LinearGradient(
          colors: isDisabled
              ? [AppColors.border, AppColors.border.withValues(alpha: 0.8)]
              : [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isDisabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.background,
                  ), // 💡 くるくるをセピア色に
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isDisabled
                          ? AppColors.textMuted
                          : AppColors.background,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // 💡 ボタンの上の文字は、背景と同じ色でくり抜くとかっこいい！
                      color: isDisabled
                          ? AppColors.textMuted
                          : AppColors.background,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
