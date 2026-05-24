// lib/pages/party/party_host_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/party_provider.dart';
import '../../widgets/party/partner_status_board.dart';
import '../../widgets/party/party_action_button.dart';
import '../../widgets/party/qr_invite_card.dart';
import '../../widgets/party/room_id_badge.dart';

class PartyHostPage extends ConsumerWidget {
  const PartyHostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(partyProvider);
    final notifier = ref.read(partyProvider.notifier);

    // モック用：
    // 初回表示時にルームが無かったら生成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.roomId.isEmpty) {
        notifier.createRoom();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1610),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'パーティルーム',
          style: TextStyle(
            color: Color(0xFFF5EDD8),
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Color(0xFFC8A97A),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── ルームコード ──
              RoomIdBadge(
                roomId: state.roomId,
              ),

              const SizedBox(height: 20),

              // ── QR招待 ──
              QrInviteCard(
                roomId: state.roomId,
                onShare: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('招待リンクを共有したよ'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ── メンバー一覧 ──
              PartnerStatusBoard(
                members: state.members,
              ),

              const SizedBox(height: 16),

              // ── モック追加ボタン ──
              OutlinedButton.icon(
                onPressed: () {
                  notifier.addMockMember();
                },

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF5C4033),
                  ),

                  foregroundColor: const Color(0xFFC8A97A),

                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                icon: const Icon(Icons.person_add_alt_1),

                label: const Text(
                  'モックメンバー追加',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── 冒険開始 ──
              PartyActionButton(
                text: 'このメンバーで冒険開始！',
                icon: Icons.explore_rounded,

                isEnabled: state.members.length >= 2,

                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('冒険を開始します！'),
                    ),
                  );

                  // TODO:
                  // context.go('/navigation');
                },
              ),

              const SizedBox(height: 12),

              Text(
                state.members.length < 2
                    ? '2人以上集まると冒険を開始できるよ'
                    : '仲間たちの準備が整ったよ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7A5C3A),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}