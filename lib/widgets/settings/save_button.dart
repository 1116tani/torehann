// lib/widgets/settings/save_button.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class SaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback? onPressed;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: 1.0),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60, // 大きめ
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: AppColors.textDark,
            disabledBackgroundColor: colors.surfaceLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.border, width: 0.5),
            ),
            elevation: 4,
          ),
          onPressed: isSaving ? null : onPressed,
          child: isSaving
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.textDark,
                  ),
                )
              : const Text(
                  '変更を保存する',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}
