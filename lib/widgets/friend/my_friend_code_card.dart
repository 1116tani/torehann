// lib/widgets/friend/my_friend_code_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';

class MyFriendCodeCard extends StatelessWidget {
  final String friendCode;

  const MyFriendCodeCard({
    super.key,
    required this.friendCode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.primary,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.background.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                color: colors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'マイフレンドコード',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // コード表示
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.border,
                  width: 0.6,
                ),
              ),

              child: Text(
                friendCode,
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 説明
          Center(
            child: Text(
              'このコードを友達に共有すると\n一緒に冒険できるようになります',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ボタン
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.copy_rounded,
                  label: 'コピー',
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: friendCode),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'フレンドコードをコピーしました',
                            style: TextStyle(color: colors.textPrimary),
                          ),
                          backgroundColor: colors.surface,
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _ActionButton(
                  icon: Icons.qr_code_rounded,
                  label: 'QR表示',
                  onTap: () {
                    // TODO:
                    // QRコード表示モーダル
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── ボタン ───────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.border,
            width: 0.6,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFFC8A97A),
              size: 18,
            ),

            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: colors.secondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}