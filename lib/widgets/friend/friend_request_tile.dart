// lib/widgets/friend/friend_request_tile.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/friend_model.dart';

class FriendRequestTile extends StatelessWidget {
  final FriendModel friend;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestTile({
    super.key,
    required this.friend,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border,
          width: 0.8,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          children: [
            // ── アバター ──
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceLight,
                border: Border.all(
                  color: colors.secondary,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.person,
                color: colors.secondary,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            // ── 情報 ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '一緒に冒険したいみたい。',
                    style: TextStyle(
                      color: colors.secondary,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.route,
                        size: 13,
                        color: colors.textMuted,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          friend.favoriteAreas.isEmpty
                              ? '未知エリア探索中'
                              : friend.favoriteAreas.join(' / '),

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── ボタン群 ──
            Column(
              children: [
                // 承認
                GestureDetector(
                  onTap: onAccept,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      '承認',
                      style: TextStyle(
                        color: colors.background,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 拒否
                GestureDetector(
                  onTap: onReject,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: colors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.border,
                        width: 0.5,
                      ),
                    ),

                    child: Text(
                      '見送る',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}