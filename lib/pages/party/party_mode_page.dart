// lib/pages/party/party_mode_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';
import '../../widgets/party/party_action_button.dart';
import '../../widgets/common/custom_header.dart';

class PartyModePage extends StatelessWidget {
  const PartyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              title: 'パーティ冒険',
              subtitle: 'PARTY ADVENTURE',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // ── タイトル ──
                    const Icon(
                      Icons.groups_rounded,
                      size: 64,
                      color: Color(0xFFC8A97A),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'パーティ冒険',
                      style: TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '仲間と一緒に、\n物語の続きを歩こう。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFC8A97A),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

              // ── ルーム作成 ──
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFF2C2318),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF4A3728),
                    width: 1,
                  ),
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 40,
                      color: Color(0xFFB8860B),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      '新しくパーティを作る',
                      style: TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'ルームIDを発行して\n仲間を招待できるよ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7A5C3A),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    PartyActionButton(
                      text: 'ルームを作成',
                      icon: Icons.add_rounded,
                      onTap: () {
                        context.push(AppRoutes.partyHost);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── ルーム参加 ──
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFF2C2318),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF4A3728),
                    width: 1,
                  ),
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.travel_explore_rounded,
                      size: 40,
                      color: Color(0xFF57D6C9),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      '友達のパーティに参加',
                      style: TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'ルームIDやQRコードから\n冒険へ合流できるよ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7A5C3A),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    PartyActionButton(
                      text: 'パーティに参加',
                      icon: Icons.login_rounded,
                      onTap: () {
                        context.push(AppRoutes.partyJoin);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── フッター ──
              const Text(
                '2〜5人で一緒に冒険できます',
                style: TextStyle(
                  color: Color(0xFF5C4033),
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),
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