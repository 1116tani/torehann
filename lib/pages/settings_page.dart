// lib/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_sizes.dart';
import '../widgets/settings/hobby_tag_selector.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610), // 渋くてカッコいいダークブラウン
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── 冒険者プロフィール ──
                    _buildSectionTitle('冒険者プロフィール'),
                    _buildMenuTile(
                      icon: Icons.person_outline,
                      title: '冒険者名 / 年齢 / 職業 / 自宅エリア',
                      subtitle: "名: ${state.name.isEmpty ? '未設定' : state.name} / ${state.age.isEmpty ? '年齢未設定' : '${state.age}歳'} / 職業: ${state.occupation.isEmpty ? '未設定' : state.occupation} / 自宅: ${state.homeLocation.isEmpty ? '未設定' : state.homeLocation}",
                      onTap: () => _showProfileDialog(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── 趣味・好みタグ ──
                    _buildSectionTitle('趣味・好みタグ — AIルート生成のコア設定'),
                    _buildMenuTile(
                      icon: Icons.favorite_border,
                      title: '好きな場所タグ (AIに連携)',
                      subtitle: state.hobbyTags.isEmpty ? '未選択 (カフェ・神社など)' : state.hobbyTags.join('・'),
                      onTap: () => _showHobbyTagsDialog(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── 冒険のデフォルト設定 ──
                    _buildSectionTitle('冒険のデフォルト設定'),
                    _buildMenuTile(
                      icon: Icons.access_time,
                      title: '1日の歩数目標',
                      subtitle: '目標: ${state.dailyStepGoal}歩',
                      onTap: () => _showDailyGoalDialog(context),
                    ),
                    _buildMenuTile(
                      icon: Icons.timeline,
                      title: '1日の距離目標',
                      subtitle: '目標: ${state.dailyDistanceGoal.toStringAsFixed(1)} km',
                      onTap: () => _showDistanceGoalDialog(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── アプリの見た目・マップ ──
                    _buildSectionTitle('アプリの見た目・マップ'),
                    _buildMenuTile(
                      icon: Icons.palette_outlined,
                      title: 'マップスタイル',
                      subtitle: "現在のスタイル: ${state.mapStyle == 'game' ? 'ゲーム風' : state.mapStyle == 'white' ? 'ホワイト' : 'ブラック'}",
                      onTap: () => _showMapStyleDialog(context),
                    ),
                    _buildMenuTile(
                      icon: Icons.format_size,
                      title: '文字サイズ',
                      subtitle: '現在のサイズ: ${state.fontSize == 'small' ? '小' : state.fontSize == 'medium' ? '標準' : '大'}',
                      onTap: () => _showFontSizeDialog(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── 通知 ──
                    _buildSectionTitle('通知'),
                    _buildSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: '毎日のリマインド',
                      subtitle: '「今日も歩こう」通知を受け取る',
                      value: state.reminderEnabled,
                      onChanged: notifier.setReminderEnabled,
                    ),
                    _buildMenuTile(
                      icon: Icons.schedule,
                      title: '「今日も歩こう」通知の時刻設定',
                      subtitle: '現在: ${state.reminderTime}',
                      onTap: () => _showReminderTimeDialog(context),
                    ),
                    _buildSwitchTile(
                      icon: Icons.message_outlined,
                      title: 'バックグラウンド通知',
                      subtitle: '冒険中の相棒メッセージなど',
                      value: state.bgNotification,
                      onChanged: notifier.setBgNotification,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── プライバシー誠実設計 ──
                    _buildSectionTitle('プライバシー誠実設計'),
                    _buildSwitchTile(
                      icon: Icons.photo_camera_outlined,
                      title: '写真シェア時の位置情報',
                      subtitle: 'SNSシェア時にGPS座標を除去する（デフォルト: ON）',
                      value: state.removeGpsOnShare,
                      onChanged: notifier.setRemoveGpsOnShare,
                    ),
                    _buildMenuTile(
                      icon: Icons.location_on_outlined,
                      title: '位置情報の利用',
                      subtitle: 'アプリのGPS使用許可を確認・変更',
                      onTap: () => _showLocationPermissionDialog(context),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── アカウント管理 ──
                    _buildSectionTitle('アカウント管理'),
                    _buildMenuTile(
                      icon: Icons.mail_outline,
                      title: 'メールアドレスの登録・変更',
                      subtitle: 'ログイン用のメールアドレスを管理します',
                      onTap: () {},
                    ),
                    _buildMenuTile(
                      icon: Icons.lock_outline,
                      title: 'パスワード変更',
                      subtitle: 'セキュリティを高めるために定期的な変更を推奨',
                      onTap: () {},
                    ),
                    _buildMenuTile(
                      icon: Icons.auto_awesome,
                      title: '匿名アカウントを正式登録に移行',
                      subtitle: 'アプリを消してもデータが消えないようにします',
                      titleColor: const Color(0xFFC8A97A),
                      onTap: () => _showAnonymousWarningDialog(context),
                    ),
                    _buildMenuTile(
                      icon: Icons.logout,
                      title: 'ログアウト',
                      subtitle: 'アカウントからサインアウトします',
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                    _buildMenuTile(
                      icon: Icons.delete_forever,
                      title: 'アカウント削除・データ消去',
                      subtitle: 'すべての冒険記録・コレクションが削除されます',
                      titleColor: const Color(0xFF8B3A1F),
                      onTap: () => _showDeleteAccountDialog(context, notifier),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // ── サポート・情報 ──
                    _buildSectionTitle('サポート・情報'),
                    _buildMenuTile(
                      icon: Icons.menu_book_outlined,
                      title: 'チュートリアルをもう一度見る',
                      subtitle: '使い方を忘れたときにいつでも確認できます',
                      onTap: () {},
                    ),
                    _buildMenuTile(
                      icon: Icons.rate_review_outlined,
                      title: 'フィードバックを送る',
                      subtitle: '技育博・展に向けた改善に活用させていただきます！',
                      onTap: () {},
                    ),
                    _buildMenuTile(
                      icon: Icons.gavel_outlined,
                      title: '利用規約 / プライバシーポリシー',
                      subtitle: '法的な確認事項はこちらから',
                      onTap: () {},
                    ),
                    const SizedBox(height: AppSizes.p24),
                    const Center(
                      child: Text(
                        'アプリのバージョン v1.0.0',
                        style: TextStyle(color: Color(0xFF5C4033), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p32),
                  ],
                ),
              ),
            ),
            _buildSaveButton(context, state, notifier),
          ],
        ),
      ),
    );
  }

  // ── UI生成パーツ ──
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color titleColor = const Color(0xFFF5EDD8),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A3728)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFC8A97A), size: 20),
        title: Text(title, style: TextStyle(color: titleColor, fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 11)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A3728), size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A3728)),
      ),
      child: SwitchListTile(
        activeThumbColor: const Color(0xFFC8A97A),
        activeTrackColor: const Color(0xFF5C4033),
        inactiveThumbColor: const Color(0xFF7A5C3A),
        inactiveTrackColor: const Color(0xFF1C1610),
        secondary: Icon(icon, color: const Color(0xFFC8A97A), size: 20),
        title: Text(title, style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 11)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),
        border: Border(bottom: BorderSide(color: Color(0xFF4A3728), width: 1)),
      ),
      child: const Center(
        child: Text('設定', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF5EDD8), letterSpacing: 1.0)),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, UserState state, UserNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      color: const Color(0xFF2C2318),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC8A97A),
            foregroundColor: const Color(0xFF1C1610),
            padding: const EdgeInsets.all(AppSizes.p16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: state.isSaving ? null : () async {
            await notifier.saveSettings();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('設定を保存しました！'), backgroundColor: Color(0xFF4A3728)),
              );
            }
          },
          child: state.isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF1C1610), strokeWidth: 2))
              : const Text('変更を保存する', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ),
    );
  }

  // ==========================================
  // 🪄 下からじゃなくて、画面のど真ん中に出るダイアログたち！
  // ==========================================

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '👤 冒険者プロフィール',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return Column(
              children: [
                _InputField(label: '冒険者名', hint: 'アプリ内で表示される名前', value: state.name, onChanged: notifier.setName),
                const SizedBox(height: 12),
                _InputField(label: '年齢', hint: '例：21 (AIルート生成に使用)', value: state.age, keyboardType: TextInputType.number, onChanged: notifier.setAge),
                const SizedBox(height: 12),
                _InputField(label: '職業', hint: '例：学生・社会人', value: state.occupation, onChanged: notifier.setOccupation),
                const SizedBox(height: 12),
                _InputField(label: '自宅エリア', hint: '例：渋谷・目黒', value: state.homeLocation, onChanged: notifier.setHomeLocation),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showHobbyTagsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '🎒 好きな場所タグ (AI連携)',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return HobbyTagSelector(
              selectedTags: state.hobbyTags,
              onToggle: notifier.toggleHobbyTag,
            );
          },
        ),
      ),
    );
  }

  void _showDistanceGoalDialog(BuildContext context) {
    final distances = [1.0, 2.0, 3.0, 5.0, 10.0];
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '📏 1日の距離目標',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return RadioGroup<double>(
              groupValue: state.dailyDistanceGoal,
              onChanged: (value) {
                if (value != null) notifier.setDailyDistanceGoal(value);
              },
              child: Column(
                children: distances.map((distance) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${distance.toStringAsFixed(1)} km', style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 14)),
                    leading: Radio<double>(
                      value: distance,
                      activeColor: const Color(0xFFC8A97A),
                    ),
                    onTap: () => notifier.setDailyDistanceGoal(distance),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDailyGoalDialog(BuildContext context) {
    String textInput = '';
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '🎯 1日の目標 (歩数)',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            
            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: _InputField(
                            label: '',
                            hint: '${state.dailyStepGoal}',
                            value: textInput.isEmpty ? state.dailyStepGoal.toString() : textInput,
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              setState(() => textInput = v);
                              final parsed = int.tryParse(v);
                              if (parsed != null && parsed >= 1000 && parsed <= 30000) {
                                notifier.setDailyStepGoal(parsed);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('歩', style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: state.dailyStepGoal.clamp(1000, 30000).toDouble(),
                      min: 1000,
                      max: 30000,
                      divisions: 29,
                      activeColor: const Color(0xFFC8A97A),
                      inactiveColor: const Color(0xFF4A3728),
                      onChanged: (v) {
                        setState(() => textInput = v.toInt().toString());
                        notifier.setDailyStepGoal(v.toInt());
                      },
                    ),
                    const Text('スライダーか直接入力で設定してね！(1000〜30000歩)', style: TextStyle(color: Color(0xFF7A5C3A), fontSize: 10)),
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }

  void _showMapStyleDialog(BuildContext context) {
    final styles = [
      {'key': 'game', 'icon': '🗺️', 'label': 'ゲーム風'},
      {'key': 'white', 'icon': '☀️', 'label': 'ホワイト'},
      {'key': 'black', 'icon': '🌙', 'label': 'ブラック'},
    ];
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '🗺️ マップスタイル',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return Row(
              children: styles.map((s) {
                final isSelected = state.mapStyle == s['key'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => notifier.setMapStyle(s['key'] as String),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF3D2B1F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(s['icon'] as String, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(s['label'] as String, style: TextStyle(color: isSelected ? const Color(0xFF1C1610) : const Color(0xFFF5EDD8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    final options = [
      {'key': 'small', 'label': '小'},
      {'key': 'medium', 'label': '標準'},
      {'key': 'large', 'label': '大'},
    ];
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '🔤 文字サイズ',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return Row(
              children: options.map((opt) {
                final isSelected = state.fontSize == opt['key'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => notifier.setFontSize(opt['key'] as String),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF3D2B1F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(opt['label'] as String, style: TextStyle(color: isSelected ? const Color(0xFF1C1610) : const Color(0xFFF5EDD8), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _showReminderTimeDialog(BuildContext context) {
    final times = ['08:00', '12:00', '18:00', '20:00', '21:00'];
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '⏰ リマインド時刻設定',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return RadioGroup<String>(
              groupValue: state.reminderTime,
              onChanged: (value) {
                if (value != null) notifier.setReminderTime(value);
              },
              child: Column(
                children: times.map((time) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(time, style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 14)),
                    leading: Radio<String>(
                      value: time,
                      activeColor: const Color(0xFFC8A97A),
                    ),
                    onTap: () => notifier.setReminderTime(time),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLocationPermissionDialog(BuildContext context) {
    final options = [
      {'key': 'always', 'label': '常に許可 (推奨)'},
      {'key': 'whenInUse', 'label': 'アプリ使用中のみ'},
      {'key': 'denied', 'label': '許可しない'},
    ];
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '📡 位置情報の利用',
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(userProvider);
            final notifier = ref.read(userProvider.notifier);
            return RadioGroup<String>(
              groupValue: state.locationPermission,
              onChanged: (value) {
                if (value != null) notifier.setLocationPermission(value);
              },
              child: Column(
                children: options.map((option) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option['label'] as String, style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 14)),
                    leading: Radio<String>(
                      value: option['key'] as String,
                      activeColor: const Color(0xFFC8A97A),
                    ),
                    onTap: () => notifier.setLocationPermission(option['key'] as String),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAnonymousWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _BaseDialog(
        title: '⚠️ アカウントの正式登録',
        child: Column(
          children: [
            const Text(
              '現在は「匿名アカウント」でのログイン状態になっています。\n\nこのままだと、アプリを誤って削除したり、スマホを機種変更した時に、これまでのすべての冒険記録・コレクションデータが完全に消えてしまい、復旧できなくなります！',
              style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC8A97A), foregroundColor: const Color(0xFF1C1610)),
              onPressed: () => Navigator.pop(context),
              child: const Text('メールアドレスで正式登録する', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        title: const Text('ログアウト', style: TextStyle(color: Color(0xFFF5EDD8))),
        content: const Text('本当にログアウトしますか？', style: TextStyle(color: Color(0xFFC8A97A))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A)))),
          TextButton(
            onPressed: () async {
              await ref.read(authControllerProvider).signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('ログアウト', style: TextStyle(color: Color(0xFF8B3A1F))),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, UserNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        title: const Text('アカウントの削除', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
        content: const Text('すべてのアカウントデータ、冒険の記録、コレクションが完全に消去されます。この操作は取り消せません。\n\n本当に削除しますか？', style: TextStyle(color: Color(0xFFC8A97A))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A)))),
          TextButton(
            onPressed: () async {
              await notifier.deleteAccount();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('削除する', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// 🪄 中央配置のためのベースダイアログウィジェット
class _BaseDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const _BaseDialog({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2C2318),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSizes.p24),
        child: SingleChildScrollView( // 💡 これで中身が増えてもスクロールできて安心！
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF7A5C3A), size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const Divider(color: Color(0xFF4A3728), height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

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
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusM), borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusM), borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusM), borderSide: const BorderSide(color: Color(0xFFB8860B), width: 1.5)),
      ),
    );
  }
}