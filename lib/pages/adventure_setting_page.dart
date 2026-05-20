// lib/pages/adventure_setting_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/adventure_provider.dart';
import '../providers/route_provider.dart';
import '../router/app_router.dart';
import '../constants/app_sizes.dart';

class AdventureSettingPage extends ConsumerWidget {
  const AdventureSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adventureSettingProvider);
    final notifier = ref.read(adventureSettingProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318), // セピア調ダーク
      body: SafeArea(
        child: Column(
          children: [
            // ── ヘッダー ──
            _buildHeader(context),

            // ── スクロールエリア ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 自動入力エリア（日付・天気・現在地）
                    _buildAutoInfoCard(),
                    const SizedBox(height: AppSizes.p16),

                    // 目的地入力
                    _buildDestinationSection(state, notifier),
                    const SizedBox(height: AppSizes.p24),

                    // 気分選択
                    _buildMoodSection(state, notifier),
                    const SizedBox(height: AppSizes.p24),

                    // モード選択
                    _buildModeSection(state, notifier),
                    const SizedBox(height: AppSizes.p32),
                  ],
                ),
              ),
            ),

            // ── 下部：ルート生成ボタン ──
            _buildGenerateButton(context, ref, state),
          ],
        ),
      ),
    );
  }

  // ── ヘッダー ──────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF4A3728),
        border: Border(
          bottom: BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Column(
            children: [
              Text(
                '冒険セッティング',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5EDD8),
                ),
              ),
              Text(
                'ADVENTURE SETUP',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFC8A97A),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFC8A97A)),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  // ── 自動入力カード（日付・天気・現在地） ──
  Widget _buildAutoInfoCard() {
    final now = DateTime.now();
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[now.weekday - 1];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 日付
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Color(0xFFC8A97A),
              ),
              const SizedBox(width: 6),
              Text(
                '${now.year}年${now.month}月${now.day}日（$weekday）',
                style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 12),
              ),
            ],
          ),
          // 天気（APIまで仮表示）
          const Row(
            children: [
              Icon(Icons.wb_sunny, size: 14, color: Color(0xFFC8A97A)),
              SizedBox(width: 4),
              Text(
                '晴れ',
                style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 12),
              ),
            ],
          ),
          // 現在地（APIまで仮表示）
          const Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Color(0xFFC8A97A)),
              SizedBox(width: 4),
              Text(
                '現在地',
                style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 目的地入力 ──────────────────────────────
  Widget _buildDestinationSection(
    AdventureSettingState state,
    AdventureSettingNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.place, label: '目的地'),
        const SizedBox(height: AppSizes.p8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: notifier.setDestination,
                style: const TextStyle(color: Color(0xFFF5EDD8)),
                decoration: InputDecoration(
                  hintText: '行きたい場所を入力...',
                  hintStyle: const TextStyle(color: Color(0xFF7A5C3A)),
                  filled: true,
                  fillColor: const Color(0xFF3D2B1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(
                      color: Color(0xFFC8A97A),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(
                      color: Color(0xFFC8A97A),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    borderSide: const BorderSide(
                      color: Color(0xFFB8860B),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p8),
            // おまかせボタン
            GestureDetector(
              onTap: notifier.setRandom,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p12,
                ),
                decoration: BoxDecoration(
                  color: state.isRandom
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF3D2B1F),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: const Color(0xFFC8A97A),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'おまかせ',
                  style: TextStyle(
                    color: state.isRandom
                        ? Colors.white
                        : const Color(0xFFC8A97A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 気分選択 ──────────────────────────────
  Widget _buildMoodSection(
    AdventureSettingState state,
    AdventureSettingNotifier notifier,
  ) {
    final moods = [
      ('のんびり', '🌸'),
      ('わくわく', '✨'),
      ('ガッツリ', '🔥'),
      ('きまぐれ', '🎲'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.mood, label: '今の気分'),
        const SizedBox(height: AppSizes.p8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: moods.map((mood) {
            final isSelected = state.mood == mood.$1;
            return GestureDetector(
              onTap: () => notifier.setMood(mood.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p16,
                  vertical: AppSizes.p12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF3D2B1F),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFB8860B)
                        : const Color(0xFFC8A97A),
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(mood.$2, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      mood.$1,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFC8A97A),
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── モード選択 ──────────────────────────────
  Widget _buildModeSection(
    AdventureSettingState state,
    AdventureSettingNotifier notifier,
  ) {
    final modes = [
      ('お散歩', '1-3km、ゆったりペース'),
      ('探索', '3-6km、見どころ多め'),
      ('冒険', '6km以上、がっつり歩く'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.directions_walk, label: '難易度'),
        const SizedBox(height: AppSizes.p8),
        ...modes.map((mode) {
          final isSelected = state.mode == mode.$1;
          return GestureDetector(
            onTap: () => notifier.setMode(mode.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSizes.p8),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB8860B)
                    : const Color(0xFF3D2B1F),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : const Color(0xFFC8A97A),
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mode.$1,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFF5EDD8),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    mode.$2,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white70
                          : const Color(0xFF7A5C3A),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── ルート生成ボタン ──────────────────────────
  Widget _buildGenerateButton(
    BuildContext context,
    WidgetRef ref,
    AdventureSettingState state,
  ) {
    final canGenerate = state.isRandom || state.destination.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),
        border: Border(top: BorderSide(color: Color(0xFFC8A97A), width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canGenerate
                ? const Color(0xFFB8860B)
                : const Color(0xFF7A5C3A),
            padding: const EdgeInsets.all(AppSizes.p16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          onPressed: canGenerate
              ? () {
                  ref.read(routeSelectProvider.notifier).generateRoutes();
                  context.go(AppRoutes.routeSelect);
                }
              : null,
          child: Text(
            canGenerate ? 'ルートを生成する ✨' : '目的地を入力するか、おまかせを選択',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── 共通：セクションラベル ────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconS, color: const Color(0xFFC8A97A)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
