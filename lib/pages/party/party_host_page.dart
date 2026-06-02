// lib/pages/party/party_host_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../providers/party_provider.dart';
import '../../widgets/party/partner_status_board.dart';
import '../../widgets/party/party_action_button.dart';
import '../../widgets/party/qr_invite_card.dart';
import '../../widgets/party/room_id_badge.dart';
import '../../widgets/common/custom_header.dart';

class PartyHostPage extends ConsumerWidget {
  const PartyHostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final state = ref.watch(partyProvider);
    final notifier = ref.read(partyProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.roomId.isEmpty) {
        notifier.createRoom();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: 'パーティルーム',
              subtitle: 'PARTY ROOM',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RoomIdBadge(
                      roomId: state.roomId,
                    ),
                    const SizedBox(height: 20),
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
                    PartnerStatusBoard(
                      members: state.members,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        notifier.addMockMember();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colors.border,
                        ),
                        foregroundColor: colors.secondary,
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
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
