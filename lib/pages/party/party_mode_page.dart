// lib/pages/party/party_mode_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../router/route_names.dart';
import '../../widgets/party/party_action_button.dart';
import '../../widgets/common/custom_header.dart';

class PartyModePage extends StatelessWidget {
  const PartyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,

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
                    Icon(
                      Icons.groups_rounded,
                      size: 64,
                      color: colors.primary,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'パーティ冒険',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '仲間と一緒に、\n物語の続きを歩こう。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

              // ── ルーム作成 ──
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.border,
                    width: 1,
                  ),
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 40,
                      color: colors.primary,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      '新しくパーティを作る',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'ルームIDを発行して\n仲間を招待できるよ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textMuted,
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.border,
                    width: 1,
                  ),
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.travel_explore_rounded,
                      size: 40,
                      color: colors.secondary,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      '友達のパーティに参加',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'ルームIDやQRコードから\n冒険へ合流できるよ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textMuted,
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
Text(
                      '2〜5人で一緒に冒険できます',
                      style: TextStyle(
                        color: colors.textMuted,
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