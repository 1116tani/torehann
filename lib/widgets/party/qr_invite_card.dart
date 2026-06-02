// lib/widgets/party/qr_invite_card.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class QrInviteCard extends StatelessWidget {
  final String roomId;
  final VoidCallback? onShare;

  const QrInviteCard({
    super.key,
    required this.roomId,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            '仲間を招待する',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'QRコードを読み取って参加',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 20),

          // ── QRコード風表示 ──
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Stack(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 144,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 12,
                  ),
                  itemBuilder: (context, index) {
                    final isDark =
                        (index % 3 == 0) ||
                        (index % 7 == 0) ||
                        (index % 11 == 0);

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  },
                ),

                // 角マーカー
                _buildCornerMarker(top: 0, left: 0),
                _buildCornerMarker(top: 0, right: 0),
                _buildCornerMarker(bottom: 0, left: 0),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── ルームID ──
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.border,
                width: 1,
              ),
            ),

            child: Text(
              'ROOM : $roomId',
              style: TextStyle(
                color: colors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ── シェアボタン ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onShare,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.surfaceLight,
                foregroundColor: colors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: colors.border),
                ),
              ),
              icon: Icon(Icons.share, color: colors.primary),
              label: Text(
                '招待をシェア',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerMarker({
    double? top,
    double? left,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
