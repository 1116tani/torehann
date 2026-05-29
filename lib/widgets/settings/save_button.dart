// lib/widgets/settings/save_button.dart

import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1610), // 背景ダークブラウン
        border: Border(
          top: BorderSide(color: Color(0xFF4A3728), width: 1.0),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60, // 大きめ
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC8A97A), // 金色
            foregroundColor: const Color(0xFF1C1610),
            disabledBackgroundColor: const Color(0xFF2C2318),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF4A3728), width: 0.5),
            ),
            elevation: 4,
          ),
          onPressed: isSaving ? null : onPressed,
          child: isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF1C1610),
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
