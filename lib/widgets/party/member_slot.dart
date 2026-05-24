// lib/widgets/party/member_slot.dart

import 'package:flutter/material.dart';
import '../../providers/party_provider.dart';

class MemberSlot extends StatelessWidget {
  final PartyMember? member;

  const MemberSlot({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = member == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isEmpty
            ? const Color(0xFF241B14)
            : const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEmpty
              ? const Color(0xFF4A3728)
              : member!.isReady
                  ? const Color(0xFF57D6C9)
                  : const Color(0xFFC8A97A),
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
                  ? const Color(0xFF1C1610)
                  : const Color(0xFF3D2B1F),
              border: Border.all(
                color: isEmpty
                    ? const Color(0xFF4A3728)
                    : member!.isReady
                        ? const Color(0xFF57D6C9)
                        : const Color(0xFFC8A97A),
                width: 1.2,
              ),
            ),
            child: Icon(
              isEmpty ? Icons.add : Icons.person,
              color: isEmpty
                  ? const Color(0xFF5C4033)
                  : const Color(0xFFC8A97A),
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
                  ? const Color(0xFF5C4033)
                  : const Color(0xFFF5EDD8),
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
                    ? const Color(0xFF2D5A3D)
                    : const Color(0xFF4A3728),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                member!.isReady ? 'READY' : '接続中',
                style: TextStyle(
                  color: member!.isReady
                      ? const Color(0xFF57D6C9)
                      : const Color(0xFFC8A97A),
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
            const Text(
              'HOST',
              style: TextStyle(
                color: Color(0xFFB8860B),
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