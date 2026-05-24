// lib/widgets/friend/my_friend_code_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFriendCodeCard extends StatelessWidget {
  final String friendCode;

  const MyFriendCodeCard({
    super.key,
    required this.friendCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFC8A97A),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
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
              const Icon(
                Icons.badge_outlined,
                color: Color(0xFFB8860B),
                size: 20,
              ),

              const SizedBox(width: 8),

              const Text(
                'マイフレンドコード',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
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
                color: const Color(0xFF1C1610),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF5C4033),
                  width: 0.6,
                ),
              ),

              child: Text(
                friendCode,
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 説明
          const Center(
            child: Text(
              'このコードを友達に共有すると\n一緒に冒険できるようになります',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7A5C3A),
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
                        const SnackBar(
                          content: Text('フレンドコードをコピーしました'),
                          backgroundColor: Color(0xFF2C2318),
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
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2B1F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5C4033),
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
              style: const TextStyle(
                color: Color(0xFFC8A97A),
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