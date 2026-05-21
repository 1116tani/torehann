// lib/pages/adventure_setting_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/adventure_provider.dart';
import '../router/app_router.dart';
import '../constants/app_sizes.dart';

class AdventureSettingPage extends ConsumerWidget {
  const AdventureSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adventureSettingProvider);
    final notifier = ref.read(adventureSettingProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318),
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFC8A97A)),
                    SizedBox(height: 16),
                    Text(
                      "AIが冒険ルートを編集中...",
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 16),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        AppSizes.p24,
                      ), // 💡 パディングを大きく
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAutoInfoCard(ref), // 💡 refを渡す
                          const SizedBox(height: AppSizes.p24), // 💡 余白を大きく

                          _buildDestinationSection(state, notifier),
                          const SizedBox(height: AppSizes.p32), // 💡 余白を大きく

                          _buildMoodSection(state, notifier),
                          const SizedBox(height: AppSizes.p32), // 💡 余白を大きく

                          _buildModeSection(state, notifier),
                          const SizedBox(height: AppSizes.p40), // 💡 余白を大きく
                        ],
                      ),
                    ),
                  ),
                  _buildGenerateButton(
                    context,
                    ref,
                    state,
                    notifier,
                  ), // 💡 notifierを渡す
                ],
              ),
      ),
    );
  }

  // ── ヘッダー ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ), // 💡 大きく
      decoration: const BoxDecoration(
        color: Color(0xFF4A3728),
        border: Border(
          bottom: BorderSide(color: Color(0xFFC8A97A), width: 1.0),
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
                  fontSize: 24, // 💡 20 -> 24
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5EDD8),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'ADVENTURE SETUP',
                style: TextStyle(
                  fontSize: 12, // 💡 10 -> 12
                  color: Color(0xFFC8A97A),
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              iconSize: 32, // 💡 アイコンを大きく
              icon: const Icon(Icons.close, color: Color(0xFFC8A97A)),
              onPressed: () => context.go(AppRoutes.home), // 💡 強制的にホームのURLにジャンプさせる！
            ),
          ),
        ],
      ),
    );
  }

  // ── 自動入力カード ──
  Widget _buildAutoInfoCard(WidgetRef ref) {
    final now = DateTime.now();
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[now.weekday - 1];

    // 📍 現在地APIの呼び出し
    final addressAsync = ref.watch(currentAddressProvider);

    return Container(
      padding: const EdgeInsets.all(AppSizes.p16), // 💡 大きく
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: Color(0xFFC8A97A),
              ), // 💡 大きく
              const SizedBox(width: 8),
              Text(
                '${now.year}/${now.month}/${now.day}($weekday)',
                style: const TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 14,
                ), // 💡 12 -> 14
              ),
            ],
          ),
          const Row(
            children: [
              Icon(
                Icons.wb_sunny,
                size: 18,
                color: Color(0xFFC8A97A),
              ), // 💡 大きく
              SizedBox(width: 6),
              Text(
                '晴れ',
                style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 14),
              ), // 💡 12 -> 14
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
                color: Color(0xFFC8A97A),
              ), // 💡 大きく
              const SizedBox(width: 6),
              // 📍 APIの状態に応じて表示を切り替え
              addressAsync.when(
                data: (address) => Text(
                  address,
                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 14,
                  ),
                ),
                loading: () => const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stackTrace) => const Text(
                  '取得失敗',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 目的地入力 ──
  Widget _buildDestinationSection(
    AdventureSettingState state,
    AdventureSettingNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(icon: Icons.place, label: '目的地'),
        const SizedBox(height: AppSizes.p12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56, // 💡 テキストフィールドを高く
                child: TextField(
                  controller: TextEditingController(text: state.destination)
                    ..selection = TextSelection.collapsed(
                      offset: state.destination.length,
                    ),
                  onChanged: notifier.setDestination,
                  style: const TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 16,
                  ), // 💡 大きく
                  decoration: InputDecoration(
                    hintText: '行きたい場所を入力...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF7A5C3A),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF3D2B1F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      borderSide: const BorderSide(
                        color: Color(0xFFC8A97A),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      borderSide: const BorderSide(
                        color: Color(0xFFC8A97A),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      borderSide: const BorderSide(
                        color: Color(0xFFB8860B),
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p12),
            GestureDetector(
              onTap: notifier.setRandom,
              child: Container(
                height: 56, // 💡 ボタンを高く
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p20,
                ), // 💡 幅も広く
                decoration: BoxDecoration(
                  color: state.isRandom
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF3D2B1F),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: const Color(0xFFC8A97A),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'おまかせ',
                  style: TextStyle(
                    color: state.isRandom
                        ? Colors.white
                        : const Color(0xFFC8A97A),
                    fontSize: 16, // 💡 12 -> 16
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

  // ── 気分選択 ──
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
        const SizedBox(height: AppSizes.p12),
        Wrap(
          // 💡 RowからWrapに変更して柔軟に配置
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          children: moods.map((mood) {
            final isSelected = state.mood == mood.$1;
            return GestureDetector(
              onTap: () => notifier.setMood(mood.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80, // 💡 固定幅でタップしやすく
                padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : const Color(0xFF3D2B1F),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFB8860B)
                        : const Color(0xFFC8A97A),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFB8860B,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Text(
                      mood.$2,
                      style: const TextStyle(fontSize: 28),
                    ), // 💡 20 -> 28
                    const SizedBox(height: 8),
                    Text(
                      mood.$1,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFC8A97A),
                        fontSize: 14, // 💡 11 -> 14
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

  // ── モード選択 ──
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
        const SizedBox(height: AppSizes.p12),
        ...modes.map((mode) {
          final isSelected = state.mode == mode.$1;
          return GestureDetector(
            onTap: () => notifier.setMode(mode.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSizes.p12), // 💡 8 -> 12
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p20,
                vertical: AppSizes.p16,
              ), // 💡 大きく
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB8860B)
                    : const Color(0xFF3D2B1F),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB8860B)
                      : const Color(0xFFC8A97A),
                  width: isSelected ? 2.0 : 1.0,
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
                      fontSize: 18, // 💡 15 -> 18
                    ),
                  ),
                  Text(
                    mode.$2,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white70
                          : const Color(0xFF7A5C3A),
                      fontSize: 14, // 💡 11 -> 14
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

  // ── ルート生成ボタン ──
  Widget _buildGenerateButton(
    BuildContext context,
    WidgetRef ref,
    AdventureSettingState state,
    AdventureSettingNotifier notifier,
  ) {
    final canGenerate = state.isRandom || state.destination.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p24,
        vertical: AppSizes.p20,
      ), // 💡 大きく
      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),
        border: Border(top: BorderSide(color: Color(0xFFC8A97A), width: 1.0)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60, // 💡 ボタンを高く
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canGenerate
                ? const Color(0xFFB8860B)
                : const Color(0xFF7A5C3A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
            ),
            elevation: canGenerate ? 4 : 0,
          ),
          onPressed: canGenerate
              ? () async {
                  // 🚀 APIを叩く！
                  final success = await notifier.generateRoutes();
                  if (success && context.mounted) {
                    // 成功したら次の画面へ
                    context.go(AppRoutes.routeSelect);
                  }
                }
              : null,
          child: Text(
            canGenerate ? 'ルートを生成する ✨' : '目的地を入力するか、おまかせを選択',
            style: const TextStyle(
              fontSize: 18, // 💡 16 -> 18
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── 共通：セクションラベル ──
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFFC8A97A)), // 💡 大きく
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
            fontSize: 18, // 💡 14 -> 18
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
