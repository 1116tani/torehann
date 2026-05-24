// lib/widgets/party/partner_status_board.dart

import 'package:flutter/material.dart';
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
        color: const Color(0xFF241B14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF4A3728),
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
              const Icon(
                Icons.groups_rounded,
                color: Color(0xFFB8860B),
                size: 20,
              ),

              const SizedBox(width: 8),

              const Text(
                '冒険パーティ',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                '${members.length} / 5',
                style: const TextStyle(
                  color: Color(0xFFC8A97A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            '仲間が集まるのを待っています...',
            style: TextStyle(
              color: Color(0xFF7A5C3A),
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
              color: const Color(0xFF1C1610),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF3D2B1F),
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
                        ? const Color(0xFF57D6C9)
                        : const Color(0xFF7A5C3A),
                    shape: BoxShape.circle,
                    boxShadow: members.isNotEmpty
                        ? [
                            BoxShadow(
                              color: const Color(0xFF57D6C9)
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
                        ? const Color(0xFF57D6C9)
                        : const Color(0xFF7A5C3A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.wifi_rounded,
                  color: Color(0xFFC8A97A),
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