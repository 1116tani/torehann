// lib/widgets/party/room_id_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';

class RoomIdBadge extends StatelessWidget {
  final String roomId;

  const RoomIdBadge({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.primary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.15),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ROOM ID',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // ── ルームコード ──
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: roomId),
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('ルームIDをコピーしたよ'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: colors.surface,
                  ),
                );
              }
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.border,
                  width: 1,
                ),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    roomId,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Icon(
                    Icons.copy_rounded,
                    color: colors.secondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'タップでコピー',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
