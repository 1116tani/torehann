// lib/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../constants/app_sizes.dart';
import '../widgets/settings/hobby_tag_selector.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318),
      body: SafeArea(
        child: Column(
          children: [
            // ── ヘッダー ──
            _buildHeader(context),

            // ── スクロールエリア ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── アカウント ──
                    _SectionTitle(label: 'アカウント', icon: Icons.person),
                    const SizedBox(height: AppSizes.p8),
                    _buildAccountSection(),
                    const SizedBox(height: AppSizes.p24),

                    // ── ユーザー情報 ──
                    _SectionTitle(label: 'ユーザー情報', icon: Icons.edit),
                    const SizedBox(height: AppSizes.p8),
                    _buildUserInfoSection(state, notifier),
                    const SizedBox(height: AppSizes.p24),

                    // ── 趣味タグ ──
                    _SectionTitle(label: '趣味タグ', icon: Icons.tag),
                    const SizedBox(height: AppSizes.p4),
                    _buildTagNote(),
                    const SizedBox(height: AppSizes.p8),
                    HobbyTagSelector(
                      selectedTags: state.hobbyTags,
                      onToggle: notifier.toggleHobbyTag,
                    ),
                    const SizedBox(height: AppSizes.p24),

                    // ── 目標設定 ──
                    _SectionTitle(label: '目標設定', icon: Icons.flag),
                    const SizedBox(height: AppSizes.p8),
                    _buildGoalSection(state, notifier),
                    const SizedBox(height: AppSizes.p24),

                    // ── 通知設定 ──
                    _SectionTitle(label: '通知設定', icon: Icons.notifications),
                    const SizedBox(height: AppSizes.p8),
                    _buildNotificationSection(state, notifier),
                    const SizedBox(height: AppSizes.p24),

                    // ── マップの見た目 ──
                    _SectionTitle(label: 'マップの見た目', icon: Icons.map),
                    const SizedBox(height: AppSizes.p8),
                    _buildMapStyleSection(state, notifier),
                    const SizedBox(height: AppSizes.p32),
                  ],
                ),
              ),
            ),

            // ── 保存ボタン ──
            _buildSaveButton(context, state, notifier),
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
                '設定',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5EDD8),
                ),
              ),
              Text(
                'SETTINGS',
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  // ── アカウント ────────────────────────────
  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.email_outlined,
            label: 'メールアドレス',
            value: 'user@example.com',
            onTap: () {}, // TODO: Firebase Auth連携
          ),
          const _RowDivider(),
          _SettingsRow(
            icon: Icons.lock_outline,
            label: 'パスワードの再設定',
            onTap: () {}, // TODO: Firebase Auth連携
          ),
          const _RowDivider(),
          _SettingsRow(
            icon: Icons.logout,
            label: 'ログアウト',
            isDestructive: true,
            onTap: () {}, // TODO: Firebase Auth連携
          ),
        ],
      ),
    );
  }

  // ── ユーザー情報 ──────────────────────────
  Widget _buildUserInfoSection(UserState state, UserNotifier notifier) {
    return Column(
      children: [
        _InputField(
          label: 'ユーザー名',
          hint: '冒険者の名前',
          value: state.name,
          onChanged: notifier.setName,
        ),
        const SizedBox(height: AppSizes.p8),
        _InputField(
          label: '年齢',
          hint: '例：21',
          value: state.age,
          keyboardType: TextInputType.number,
          onChanged: notifier.setAge,
        ),
        const SizedBox(height: AppSizes.p8),
        // 職業セレクト
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF3D2B1F),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
          ),
          child: Row(
            children: [
              const Text(
                '職業',
                style: TextStyle(color: Color(0xFF7A5C3A), fontSize: 12),
              ),
              const SizedBox(width: AppSizes.p12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: state.occupation,
                    dropdownColor: const Color(0xFF3D2B1F),
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 14,
                    ),
                    items: ['学生', '社会人', 'フリーランス', 'その他']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) notifier.setOccupation(v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.p8),
        _InputField(
          label: '自宅・活動エリア',
          hint: '例：名古屋市中区',
          value: state.homeLocation,
          onChanged: notifier.setHomeLocation,
        ),
      ],
    );
  }

  // ── 趣味タグの説明文 ──────────────────────
  Widget _buildTagNote() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(color: const Color(0xFFB8860B), width: 0.5),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, size: 13, color: Color(0xFFB8860B)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'ここで選んだタグがAIのルート生成に使われるよ！',
              style: TextStyle(color: Color(0xFFB8860B), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ── 目標設定 ──────────────────────────────
  Widget _buildGoalSection(UserState state, UserNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Column(
        children: [
          // 歩数目標
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.directions_walk,
                    size: 16,
                    color: Color(0xFFC8A97A),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '1日の歩数目標',
                    style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 13),
                  ),
                ],
              ),
              Text(
                '${state.dailyStepGoal}歩',
                style: const TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: state.dailyStepGoal.toDouble(),
            min: 1000,
            max: 20000,
            divisions: 19,
            activeColor: const Color(0xFFB8860B),
            inactiveColor: const Color(0xFF4A3728),
            onChanged: (v) => notifier.setDailyStepGoal(v.toInt()),
          ),
          const SizedBox(height: AppSizes.p8),

          // 距離目標
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.route, size: 16, color: Color(0xFFC8A97A)),
                  SizedBox(width: 6),
                  Text(
                    '1日の距離目標',
                    style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 13),
                  ),
                ],
              ),
              Text(
                '${state.dailyDistanceGoal.toStringAsFixed(1)}km',
                style: const TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: state.dailyDistanceGoal,
            min: 0.5,
            max: 15.0,
            divisions: 29,
            activeColor: const Color(0xFFB8860B),
            inactiveColor: const Color(0xFF4A3728),
            onChanged: notifier.setDailyDistanceGoal,
          ),
        ],
      ),
    );
  }

  // ── 通知設定 ──────────────────────────────
  Widget _buildNotificationSection(UserState state, UserNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 18,
                  color: Color(0xFFC8A97A),
                ),
                SizedBox(width: 8),
                Text(
                  '毎日のリマインド通知',
                  style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 13),
                ),
              ],
            ),
            Switch(
              value: state.notificationEnabled,
              activeColor: const Color(0xFFB8860B),
              onChanged: notifier.setNotification,
            ),
          ],
        ),
      ),
    );
  }

  // ── マップスタイル ────────────────────────
  Widget _buildMapStyleSection(UserState state, UserNotifier notifier) {
    final styles = [
      ('game', '🗺️', 'ゲーム風'),
      ('white', '☀️', 'ホワイト'),
      ('black', '🌙', 'ブラック'),
    ];

    return Row(
      children: styles.map((style) {
        final isSelected = state.mapStyle == style.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => notifier.setMapStyle(style.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
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
                  Text(style.$2, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    style.$3,
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
          ),
        );
      }).toList(),
    );
  }

  // ── 保存ボタン ────────────────────────────
  Widget _buildSaveButton(
    BuildContext context,
    UserState state,
    UserNotifier notifier,
  ) {
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
            backgroundColor: const Color(0xFFB8860B),
            padding: const EdgeInsets.all(AppSizes.p16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          onPressed: state.isSaving
              ? null
              : () async {
                  await notifier.saveSettings();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ 設定を保存しました！'),
                        backgroundColor: Color(0xFF2D5A3D),
                      ),
                    );
                  }
                },
          child: state.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  '変更を保存する',
                  style: TextStyle(
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

// ── 共通パーツ ────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionTitle({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFC8A97A)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC8A97A),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFF5EDD8)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 12),
        hintStyle: const TextStyle(color: Color(0xFF4A3728)),
        filled: true,
        fillColor: const Color(0xFF3D2B1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: Color(0xFFB8860B), width: 1.5),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDestructive
                  ? const Color(0xFF8B3A1F)
                  : const Color(0xFFC8A97A),
            ),
            const SizedBox(width: AppSizes.p12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDestructive
                      ? const Color(0xFF8B3A1F)
                      : const Color(0xFFF5EDD8),
                  fontSize: 13,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 12),
              ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: isDestructive
                  ? const Color(0xFF8B3A1F)
                  : const Color(0xFF7A5C3A),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color(0xFF4A3728),
      height: 1,
      indent: AppSizes.p16,
    );
  }
}
