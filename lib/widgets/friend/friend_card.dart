// lib/widgets/friend/friend_card.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
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
    final colors = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor(friend.status, colors),
          width: 0.8,
        ),
        boxShadow: friend.isOnline
            ? [
                BoxShadow(
                  color: _shadowColor(friend.status, colors),
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
                    color: colors.surfaceLight,
                    border: Border.all(
                      color: _borderColor(friend.status, colors),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: colors.secondary,
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
                      color: _statusDotColor(friend.status, colors),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.surface,
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
                          style: TextStyle(
                            color: colors.textPrimary,
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
                    style: TextStyle(
                      color: colors.secondary,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 歩数
                  Row(
                    children: [
                      Icon(
                        Icons.directions_walk,
                        size: 14,
                        color: colors.primary,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '最近 ${friend.recentSteps.toString()}歩',
                        style: TextStyle(
                          color: colors.textMuted,
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
                  color: colors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary,
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 色系 ─────────────────────────────

  Color _borderColor(FriendStatus status, AppColors colors) {
    switch (status) {
      case FriendStatus.offline:
        return colors.border;
      case FriendStatus.exploring:
        return AppColors.success;
      case FriendStatus.inParty:
        return AppColors.warning;
    }
  }

  Color _shadowColor(FriendStatus status, AppColors colors) {
    switch (status) {
      case FriendStatus.offline:
        return Colors.transparent;
      case FriendStatus.exploring:
        return AppColors.success.withValues(alpha: 0.15);
      case FriendStatus.inParty:
        return AppColors.warning.withValues(alpha: 0.18);
    }
  }

  Color _statusDotColor(FriendStatus status, AppColors colors) {
    switch (status) {
      case FriendStatus.offline:
        return colors.textDisabled;
      case FriendStatus.exploring:
        return AppColors.success;
      case FriendStatus.inParty:
        return AppColors.warning;
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
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: _backgroundColor(status, colors),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _textColor(status, colors),
          width: 0.5,
        ),
      ),

      child: Text(
        _label(status),
        style: TextStyle(
          color: _textColor(status, colors),
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

  Color _backgroundColor(FriendStatus status, AppColors colors) {
    switch (status) {
      case FriendStatus.offline:
        return colors.textDisabled.withValues(alpha: 0.25);
      case FriendStatus.exploring:
        return AppColors.success.withValues(alpha: 0.15);
      case FriendStatus.inParty:
        return AppColors.warning.withValues(alpha: 0.15);
    }
  }

  Color _textColor(FriendStatus status, AppColors colors) {
    switch (status) {
      case FriendStatus.offline:
        return colors.textMuted;
      case FriendStatus.exploring:
        return AppColors.success;
      case FriendStatus.inParty:
        return AppColors.warning;
    }
  }
}