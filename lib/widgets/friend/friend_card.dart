// lib/widgets/friend/friend_card.dart

import 'package:flutter/material.dart';

import '../../models/friend_model.dart';

class FriendCard extends StatelessWidget {
  final FriendModel friend;
  final VoidCallback onInvite;

  const FriendCard({
    super.key,
    required this.friend,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: _borderColor(friend.status),
          width: 0.8,
        ),

        boxShadow: friend.isOnline
            ? [
                BoxShadow(
                  color: _shadowColor(friend.status),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ]
            : [],
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── アバター ──
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3D2B1F),

                    border: Border.all(
                      color: _borderColor(friend.status),
                      width: 1.2,
                    ),
                  ),

                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFC8A97A),
                    size: 28,
                  ),
                ),

                Positioned(
                  right: 2,
                  bottom: 2,

                  child: Container(
                    width: 12,
                    height: 12,

                    decoration: BoxDecoration(
                      color: _statusDotColor(friend.status),
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: const Color(0xFF2C2318),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // ── 情報 ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名前 & 状態
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          friend.name,
                          style: const TextStyle(
                            color: Color(0xFFF5EDD8),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _StatusBadge(
                        status: friend.status,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // エリア
                  Text(
                    friend.favoriteAreas.isEmpty
                        ? '未知のエリアを探索中'
                        : 'よく行く: ${friend.favoriteAreas.join(' / ')}',

                    style: const TextStyle(
                      color: Color(0xFFC8A97A),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 歩数
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_walk,
                        size: 14,
                        color: Color(0xFFB8860B),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '最近 ${friend.recentSteps.toString()}歩',
                        style: const TextStyle(
                          color: Color(0xFF7A5C3A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── 招待ボタン ──
            GestureDetector(
              onTap: onInvite,

              child: Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: const Color(0xFF3D2B1F),
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: const Color(0xFFB8860B),
                    width: 0.8,
                  ),
                ),

                child: const Icon(
                  Icons.add,
                  color: Color(0xFFB8860B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 色系 ─────────────────────────────

  Color _borderColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return const Color(0xFF4A3728);

      case FriendStatus.exploring:
        return const Color(0xFF57D6C9);

      case FriendStatus.inParty:
        return const Color(0xFFB8860B);
    }
  }

  Color _shadowColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return Colors.transparent;

      case FriendStatus.exploring:
        return const Color(0xFF57D6C9).withValues(alpha: 0.15);

      case FriendStatus.inParty:
        return const Color(0xFFB8860B).withValues(alpha: 0.18);
    }
  }

  Color _statusDotColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return const Color(0xFF777777);

      case FriendStatus.exploring:
        return const Color(0xFF57D6C9);

      case FriendStatus.inParty:
        return const Color(0xFFB8860B);
    }
  }
}

// ── 状態バッジ ──────────────────────────

class _StatusBadge extends StatelessWidget {
  final FriendStatus status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: _backgroundColor(status),
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: _textColor(status),
          width: 0.5,
        ),
      ),

      child: Text(
        _label(status),

        style: TextStyle(
          color: _textColor(status),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _label(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return '休息中';

      case FriendStatus.exploring:
        return '冒険中';

      case FriendStatus.inParty:
        return 'パーティ';
    }
  }

  Color _backgroundColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return const Color(0xFF4A3728).withValues(alpha: 0.25);

      case FriendStatus.exploring:
        return const Color(0xFF57D6C9).withValues(alpha: 0.15);

      case FriendStatus.inParty:
        return const Color(0xFFB8860B).withValues(alpha: 0.15);
    }
  }

  Color _textColor(FriendStatus status) {
    switch (status) {
      case FriendStatus.offline:
        return const Color(0xFF999999);

      case FriendStatus.exploring:
        return const Color(0xFF57D6C9);

      case FriendStatus.inParty:
        return const Color(0xFFB8860B);
    }
  }
}