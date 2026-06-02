// lib/widgets/party/member_slot.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../providers/party_provider.dart';

class MemberSlot extends StatelessWidget {
  final PartyMember? member;

  const MemberSlot({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isEmpty = member == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isEmpty
            ? colors.background
            : colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEmpty
              ? colors.border
              : member!.isReady
                  ? AppColors.success
                  : colors.secondary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── アバター ──
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEmpty
                  ? colors.background
                  : colors.surfaceLight,
              border: Border.all(
                color: isEmpty
                    ? colors.border
                    : member!.isReady
                        ? AppColors.success
                        : colors.secondary,
                width: 1.2,
              ),
            ),
            child: Icon(
              isEmpty ? Icons.add : Icons.person,
              color: isEmpty
                  ? colors.textMuted
                  : colors.secondary,
              size: 24,
            ),
          ),

          const SizedBox(height: 10),

          // ── 名前 ──
          Text(
            isEmpty ? '募集中...' : member!.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isEmpty
                  ? colors.textMuted
                  : colors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // ── 状態表示 ──
          if (!isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: member!.isReady
                    ? colors.surfaceLight
                    : colors.border,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                member!.isReady ? 'READY' : '接続中',
                style: TextStyle(
                  color: member!.isReady
                      ? AppColors.success
                      : colors.secondary,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            )
          else
            const SizedBox(height: 20),

          // ── HOST表示 ──
          if (!isEmpty && member!.isHost) ...[
            const SizedBox(height: 6),
            Text(
              'HOST',
              style: TextStyle(
                color: colors.primary,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}