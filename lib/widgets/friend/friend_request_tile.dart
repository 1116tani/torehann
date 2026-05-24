// lib/widgets/friend/friend_request_tile.dart

import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF5C4033),
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
                color: const Color(0xFF3D2B1F),

                border: Border.all(
                  color: const Color(0xFFC8A97A),
                  width: 1,
                ),
              ),

              child: const Icon(
                Icons.person,
                color: Color(0xFFC8A97A),
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
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    '一緒に冒険したいみたい。',
                    style: TextStyle(
                      color: Color(0xFFC8A97A),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.route,
                        size: 13,
                        color: Color(0xFF7A5C3A),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          friend.favoriteAreas.isEmpty
                              ? '未知エリア探索中'
                              : friend.favoriteAreas.join(' / '),

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Color(0xFF7A5C3A),
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
                      color: const Color(0xFFB8860B),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Text(
                      '承認',
                      style: TextStyle(
                        color: Colors.white,
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
                      color: const Color(0xFF4A2A2A),
                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: const Color(0xFF7A3A3A),
                        width: 0.5,
                      ),
                    ),

                    child: const Text(
                      '見送る',
                      style: TextStyle(
                        color: Color(0xFFD59A9A),
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