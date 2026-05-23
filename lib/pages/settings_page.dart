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
      backgroundColor: const Color(0xFF1C1610),
      body: SafeArea(
        child: Column(
          children: [
            // ── ヘッダー ──
            _buildHeader(context),

            // ── スッキリ整理されたメニュー一覧 ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('PROFILE'),
                    _buildMenuTile(
                      icon: Icons.badge_outlined,
                      title: '冒険者プロファイル',
                      subtitle: state.name.isEmpty
                          ? '未設定'
                          : '${state.name} / ${state.age.isEmpty ? '年齢未設定' : '${state.age}歳'} / ${state.partnerName.isEmpty ? '相棒未設定' : state.partnerName}',
                      onTap: () => _showUserInfoModal(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    _buildSectionTitle('AI CUSTOMIZE'),
                    _buildMenuTile(
                      icon: Icons.tag,
                      title: '趣味タグ',
                      subtitle: state.hobbyTags.isEmpty
                          ? '未選択'
                          : '${state.hobbyTags.length}個のタグを選択中',
                      onTap: () => _showTagsModal(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    _buildSectionTitle('GOALS'),
                    _buildMenuTile(
                      icon: Icons.flag_outlined,
                      title: '目標設定',
                      subtitle:
                          '${state.dailyGoal}歩 / 空き時間 ${state.defaultFreeTimeMinutes}分',
                      onTap: () => _showGoalsModal(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    _buildSectionTitle('SYSTEM'),
                    _buildMenuTile(
                      icon: Icons.settings_outlined,
                      title: 'アプリ設定',
                      subtitle: '通知とマップの見た目',
                      onTap: () => _showSystemModal(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    _buildSectionTitle('ACCOUNT'),
                    _buildMenuTile(
                      icon: Icons.person_outline,
                      title: 'アカウント管理',
                      subtitle: 'メールアドレス・ログアウト',
                      onTap: () => _showAccountModal(context),
                    ),
                  ],
                ),
              ),
            ),

            // ── 保存ボタン（一番下でどっしり待機！） ──
            _buildSaveButton(context, state, notifier),
          ],
        ),
      ),
    );
  }

  // ── 🛠️ 共通パーツ：セクション見出し ──
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF7A5C3A),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // ── 🛠️ 共通パーツ：押しやすいリッチなタイル ──
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFF5C4033), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1610),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4A3728)),
          ),
          child: Icon(icon, color: const Color(0xFFB8860B), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF5EDD8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(color: Color(0xFFC8A97A), fontSize: 11),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF7A5C3A)),
        onTap: onTap,
      ),
    );
  }

  // ==========================================
  // 🪄 ボトムシート（モーダル）たち！
  // ==========================================

  // 👤 1. 冒険者プロファイル用モーダル
  void _showUserInfoModal(BuildContext context) {
    String newArea = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(userProvider);
          final notifier = ref.read(userProvider.notifier);

          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: AppSizes.p24,
                  right: AppSizes.p24,
                  top: AppSizes.p24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '👤 冒険者プロファイル',
                        style: TextStyle(
                          color: Color(0xFFF5EDD8),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p16),
                      _InputField(
                        label: 'ユーザー名',
                        hint: '冒険者の名前',
                        value: state.name,
                        onChanged: notifier.setName,
                      ),
                      const SizedBox(height: AppSizes.p12),
                      _InputField(
                        label: '年齢',
                        hint: '例：21',
                        value: state.age,
                        keyboardType: TextInputType.number,
                        onChanged: notifier.setAge,
                      ),
                      const SizedBox(height: AppSizes.p12),
                      _InputField(
                        label: '相棒の名前',
                        hint: '仲間の名前',
                        value: state.partnerName,
                        onChanged: notifier.setPartnerName,
                      ),
                      const SizedBox(height: AppSizes.p12),
                      const Text(
                        'よく歩くエリア',
                        style: TextStyle(
                          color: Color(0xFFC8A97A),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.walkAreas
                            .map(
                              (area) => Chip(
                                label: Text(area),
                                backgroundColor: const Color(0xFF3D2B1F),
                                labelStyle: const TextStyle(
                                  color: Color(0xFFF5EDD8),
                                ),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Color(0xFFC8A97A),
                                ),
                                onDeleted: () => notifier.removeWalkArea(area),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSizes.p12),
                      Row(
                        children: [
                          Expanded(
                            child: _InputField(
                              label: 'エリアを追加',
                              hint: '例：栄、名古屋城',
                              value: newArea,
                              onChanged: (value) => setState(() {
                                newArea = value;
                              }),
                            ),
                          ),
                          const SizedBox(width: AppSizes.p12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8860B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.p16,
                                vertical: AppSizes.p12,
                              ),
                            ),
                            onPressed: newArea.trim().isEmpty
                                ? null
                                : () {
                                    notifier.addWalkArea(newArea.trim());
                                    setState(() {
                                      newArea = '';
                                    });
                                  },
                            child: const Text('追加'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.p32),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✨ 2. 趣味タグ用モーダル
  void _showTagsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(userProvider);
          final notifier = ref.read(userProvider.notifier);

          return Padding(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✨ 趣味タグ',
                  style: TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.p8),
                const Text(
                  'ここで選んだタグがAIのルート生成に使われるよ！',
                  style: TextStyle(color: Color(0xFFB8860B), fontSize: 12),
                ),
                const SizedBox(height: AppSizes.p16),
                HobbyTagSelector(
                  selectedTags: state.hobbyTags,
                  onToggle: notifier.toggleHobbyTag,
                ),
                const SizedBox(height: AppSizes.p32),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🎯 3. 目標設定用モーダル
  void _showGoalsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(userProvider);
          final notifier = ref.read(userProvider.notifier);

          return Padding(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎯 目標設定',
                  style: TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.p24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '👣 1日の歩数目標',
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                    ),
                    Text(
                      '${state.dailyGoal}歩',
                      style: const TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: state.dailyGoal.toDouble(),
                  min: 1000,
                  max: 20000,
                  divisions: 19,
                  activeColor: const Color(0xFFB8860B),
                  inactiveColor: const Color(0xFF4A3728),
                  onChanged: (v) => notifier.setDailyGoal(v.toInt()),
                ),
                const SizedBox(height: AppSizes.p16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '⏱️ 空き時間（分）',
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                    ),
                    Text(
                      '${state.defaultFreeTimeMinutes}分',
                      style: const TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: state.defaultFreeTimeMinutes.toDouble(),
                  min: 10,
                  max: 180,
                  divisions: 17,
                  activeColor: const Color(0xFFB8860B),
                  inactiveColor: const Color(0xFF4A3728),
                  onChanged: (v) => notifier.setDefaultFreeTime(v.toInt()),
                ),
                const SizedBox(height: AppSizes.p32),
              ],
            ),
          );
        },
      ),
    );
  }

  // ⚙️ 4. アプリ設定（システム）モーダル
  void _showSystemModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(userProvider);
          final notifier = ref.read(userProvider.notifier);

          final styles = [
            {'key': 'game', 'icon': '🗺️', 'label': 'ゲーム風'},
            {'key': 'white', 'icon': '☀️', 'label': 'ホワイト'},
            {'key': 'black', 'icon': '🌙', 'label': 'ブラック'},
          ];
          final fontSizes = [
            {'key': 'small', 'label': '小'},
            {'key': 'medium', 'label': '中'},
            {'key': 'large', 'label': '大'},
          ];

          return Padding(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚙️ アプリ設定',
                  style: TextStyle(
                    color: Color(0xFFF5EDD8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.p24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🔔 毎日のリマインド通知',
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                    ),
                    Switch(
                      value: state.reminderEnabled,
                      activeThumbColor: const Color(0xFFB8860B),
                      onChanged: notifier.setReminderEnabled,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p16),
                _InputField(
                  label: 'リマインド時刻',
                  hint: '18:00',
                  value: state.reminderTime,
                  keyboardType: TextInputType.datetime,
                  onChanged: notifier.setReminderTime,
                ),
                const SizedBox(height: AppSizes.p24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🔔 バックグラウンド通知',
                      style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                    ),
                    Switch(
                      value: state.bgNotification,
                      activeThumbColor: const Color(0xFFB8860B),
                      onChanged: notifier.setBgNotification,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p24),
                const Text(
                  '🎨 マップの見た目',
                  style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                ),
                const SizedBox(height: AppSizes.p12),
                Row(
                  children: styles.map((style) {
                    final key = style['key'] as String;
                    final isSelected = state.mapStyle == key;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.setMapStyle(key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.p12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFB8860B)
                                : const Color(0xFF3D2B1F),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFB8860B)
                                  : const Color(0xFFC8A97A),
                              width: isSelected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                style['icon'] as String,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                style['label'] as String,
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
                ),
                const SizedBox(height: AppSizes.p24),
                const Text(
                  '🔤 フォントサイズ',
                  style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14),
                ),
                const SizedBox(height: AppSizes.p12),
                Row(
                  children: fontSizes.map((size) {
                    final key = size['key'] as String;
                    final isSelected = state.fontSize == key;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.setFontSize(key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.p12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFB8860B)
                                : const Color(0xFF3D2B1F),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFB8860B)
                                  : const Color(0xFFC8A97A),
                              width: isSelected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Text(
                            size['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFC8A97A),
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSizes.p32),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔑 5. アカウント管理モーダル
  void _showAccountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔑 アカウント管理',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            _SettingsRow(
              icon: Icons.email_outlined,
              label: 'メールアドレス',
              value: 'user@example.com',
              onTap: () {},
            ),
            const Divider(color: Color(0xFF4A3728), height: 1),
            _SettingsRow(
              icon: Icons.lock_outline,
              label: 'パスワードの再設定',
              onTap: () {},
            ),
            const Divider(color: Color(0xFF4A3728), height: 1),
            _SettingsRow(
              icon: Icons.logout,
              label: 'ログアウト',
              isDestructive: true,
              onTap: () {},
            ),
            const SizedBox(height: AppSizes.p32),
          ],
        ),
      ),
    );
  }

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

// ── 共通パーツ ──

// 💡 カーソルが飛ばない StatefulWidget の入力欄
class _InputField extends StatefulWidget {
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
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 最初にコントローラーを準備
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // もし外部から値が変わったら、カーソルが飛ばないように更新する
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      style: const TextStyle(color: Color(0xFFF5EDD8)),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
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
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
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
                  fontSize: 14,
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
              size: 18,
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
