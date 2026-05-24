// lib/pages/party/party_join_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/party_provider.dart';
import '../../widgets/party/party_action_button.dart';

class PartyJoinPage extends ConsumerStatefulWidget {
  const PartyJoinPage({super.key});

  @override
  ConsumerState<PartyJoinPage> createState() => _PartyJoinPageState();
}

class _PartyJoinPageState extends ConsumerState<PartyJoinPage> {
  final TextEditingController _roomIdController = TextEditingController();

  bool _isConnecting = false;

  Future<void> _joinRoom() async {
    final roomId = _roomIdController.text.trim();

    if (roomId.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('5桁のルームIDを入力してね'),
        ),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    ref.read(partyProvider.notifier).joinRoom(roomId);

    if (!mounted) return;

    setState(() {
      _isConnecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ルーム $roomId に参加したよ'),
      ),
    );

    // TODO:
    // context.go('/party/host');
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1610),
        elevation: 0,

        title: const Text(
          'パーティに参加',
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
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              const Text(
                '仲間から受け取った\nルームコードを入力してね',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFC8A97A),
                  fontSize: 14,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 28),

              // ── ルームID入力 ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF2C2318),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF5C4033),
                  ),
                ),

                child: TextField(
                  controller: _roomIdController,

                  keyboardType: TextInputType.number,

                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],

                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),

                  textAlign: TextAlign.center,

                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '00000',

                    hintStyle: TextStyle(
                      color: Color(0xFF5C4033),
                      letterSpacing: 8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '5桁の数字を入力',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7A5C3A),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 32),

              // ── QR参加 ──
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('QRカメラを起動するよ'),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2318),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF4A3728),
                    ),
                  ),

                  child: const Column(
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 34,
                        color: Color(0xFFC8A97A),
                      ),

                      SizedBox(height: 10),

                      Text(
                        'QRコードで参加',
                        style: TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'カメラで読み取ってすぐ接続',
                        style: TextStyle(
                          color: Color(0xFF7A5C3A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ── 接続中演出 ──
              if (_isConnecting) ...[
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFB8860B),
                      ),

                      SizedBox(height: 14),

                      Text(
                        '仲間たちの世界へ接続中...',
                        style: TextStyle(
                          color: Color(0xFFC8A97A),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],

              // ── 参加ボタン ──
              PartyActionButton(
                text: 'パーティに参加する',
                icon: Icons.login_rounded,
                isEnabled: !_isConnecting,
                onTap: _joinRoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}