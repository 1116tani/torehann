// lib/widgets/party/partner_status_board.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../providers/party_provider.dart';
import 'member_slot.dart';

class PartnerStatusBoard extends StatelessWidget {
  final List<PartyMember> members;

  const PartnerStatusBoard({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // 最大5人固定
    final slots = List<PartyMember?>.generate(
      5,
      (index) {
        if (index < members.length) {
          return members[index];
        }
        return null;
      },
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── タイトル ──
          Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: colors.primary,
                size: 20,
              ),

              const SizedBox(width: 8),

              Text(
                '冒険パーティ',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                '${members.length} / 5',
                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '仲間が集まるのを待っています...',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 18),

          // ── メンバー一覧 ──
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: slots.map((member) {
              return MemberSlot(member: member);
            }).toList(),
          ),

          const SizedBox(height: 18),

          // ── 接続状態 ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: colors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.border,
                width: 1,
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,

                  decoration: BoxDecoration(
                    color: members.isNotEmpty
                        ? AppColors.success
                        : colors.textMuted,
                    shape: BoxShape.circle,
                    boxShadow: members.isNotEmpty
                        ? [
                            BoxShadow(
                              color: AppColors.success
                                  .withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  members.isNotEmpty
                      ? 'ルーム接続中'
                      : '接続待機中',
                  style: TextStyle(
                    color: members.isNotEmpty
                        ? AppColors.success
                        : colors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.wifi_rounded,
                  color: colors.secondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}