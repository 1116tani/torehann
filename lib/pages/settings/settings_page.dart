// lib/pages/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_sizes.dart';
import '../../models/settings_model.dart';
import '../../providers/settings_provider.dart';
import '../../router/route_names.dart';
import '../../widgets/common/custom_header.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../widgets/settings/profile_modal.dart';
import '../../widgets/settings/location_pin_modal.dart';
import '../../widgets/settings/place_tag_modal.dart';
import '../../widgets/settings/appearance_modal.dart';
import '../../widgets/settings/notification_modal.dart';
import '../../widgets/settings/privacy_modal.dart';
import '../../widgets/settings/save_button.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  SettingsState? _initialState;

  @override
  void initState() {
    super.initState();
    // 初期状態をキャプチャ (非同期ロード完了後に合わせるため、現在のstateを一旦保持)
    _initialState = ref.read(settingsProvider);
  }

  // 戻る際のアクション確認
  Future<void> _handleBackPress() async {
    final settings = ref.read(settingsProvider);
    final hasChanges = settings != _initialState;

    if (hasChanges) {
      final result = await _showDiscardConfirmDialog(context);
      if (result == 'save') {
        await ref.read(settingsProvider.notifier).saveSettings();
        if (mounted) {
          _initialState = ref.read(settingsProvider);
          context.pop();
        }
      } else if (result == 'discard') {
        // 保存せずに破棄し、以前の設定をロードし直す
        await ref.read(settingsProvider.notifier).loadSettings();
        if (mounted) {
          context.pop();
        }
      }
    } else {
      context.pop();
    }
  }

  // 保存処理
  void _onSave() async {
    await ref.read(settingsProvider.notifier).saveSettings();
    setState(() {
      _initialState = ref.read(settingsProvider);
    });
    _showSaveSuccessOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final hasChanges = settings != _initialState;

    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1610), // 渋くてカッコいいダークブラウン
        body: SafeArea(
          child: Column(
            children: [
              CustomHeader(
                title: '設定',
                subtitle: 'SETTINGS',
                onBack: _handleBackPress,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 冒険者プロフィール ──
                      const SettingsSection(title: '冒険者プロフィール'),
                      SettingsTile(
                        icon: Icons.person_outline,
                        title: '冒険者名 / 年齢 / 距離目標',
                        subtitle: '名: ${settings.userName.isEmpty ? '未設定' : settings.userName} / ${settings.age}歳 / 目標: ${settings.dailyGoalKm.toStringAsFixed(1)}km',
                        valueText: settings.userName.isEmpty ? '未設定' : settings.userName,
                        onTap: () => _showModal(context, const ProfileModal()),
                      ),

                      // ── 保存地点 ──
                      const SettingsSection(title: '保存地点'),
                      SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: '場所ピンの設定',
                        subtitle: '自宅: ${settings.homeLocation.isEmpty ? '未設定' : settings.homeLocation} / 他',
                        valueText: settings.homeLocation.isEmpty ? '未設定' : '設定済み',
                        onTap: () => _showModal(context, const LocationPinModal()),
                      ),

                      // ── 好きな場所タグ ──
                      const SettingsSection(title: '好きな場所タグ'),
                      SettingsTile(
                        icon: Icons.favorite_border,
                        title: '好きな場所タグ (AIルート生成に連携)',
                        subtitle: settings.favoriteTags.isEmpty 
                            ? '未選択 (カフェ・神社など)' 
                            : settings.favoriteTags.join('・'),
                        valueText: '${settings.favoriteTags.length}個',
                        onTap: () => _showModal(context, const PlaceTagModal()),
                      ),

                      // ── アプリの見た目・マップ ──
                      const SettingsSection(title: 'アプリの見た目・マップ'),
                      SettingsTile(
                        icon: Icons.palette_outlined,
                        title: 'マップスタイル・文字・テーマ',
                        subtitle: 'マップ: ${settings.mapStyle == 'game' ? 'ゲーム風' : settings.mapStyle == 'satellite' ? '航空写真' : '地形'} / テーマ: ${settings.themeMode}',
                        onTap: () => _showModal(context, const AppearanceModal()),
                      ),

                      // ── 通知 ──
                      const SettingsSection(title: '通知'),
                      SettingsTile(
                        icon: Icons.notifications_active_outlined,
                        title: '通知の管理',
                        subtitle: '毎日のリマインド: ${settings.reminderEnabled ? 'ON' : 'OFF'} / BG通知: ${settings.backgroundNotificationEnabled ? 'ON' : 'OFF'}',
                        onTap: () => _showModal(context, const NotificationModal()),
                      ),

                      // ── プライバシー ──
                      const SettingsSection(title: 'プライバシー'),
                      SettingsTile(
                        icon: Icons.security_outlined,
                        title: 'プライバシー誠実設計',
                        subtitle: '写真位置情報: ${settings.photoPermission ? '除去する' : '除去しない'} / 位置情報権限',
                        onTap: () => _showModal(context, const PrivacyModal()),
                      ),

                      // ── アカウント管理 ──
                      const SettingsSection(title: 'アカウント管理'),
                      SettingsTile(
                        icon: Icons.manage_accounts_outlined,
                        title: 'ログイン設定 & 退会',
                        subtitle: 'ログイン、パスワード変更、アカウント削除など',
                        onTap: () {
                          context.push(AppRoutes.account);
                        },
                      ),

                      // ── サポート ──
                      const SettingsSection(title: 'サポート'),
                      SettingsTile(
                        icon: Icons.help_outline,
                        title: 'チュートリアル & ヘルプ',
                        subtitle: 'チュートリアル再生、利用規約、フィードバック送信',
                        onTap: () => _showSupportActions(context),
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
              SaveButton(
                isSaving: settings.isSaving,
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, Widget modal) {
    showDialog(
      context: context,
      builder: (context) => modal,
    ).then((_) {
      // モーダルが閉じられたら状態の変化を検知するため再描画
      setState(() {});
    });
  }

  void _showSupportActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2318),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🧭 サポートメニュー',
              style: TextStyle(color: Color(0xFFF5EDD8), fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Color(0xFF4A3728), height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1610),
                foregroundColor: const Color(0xFFC8A97A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('チュートリアルを再生します（デモ）'), backgroundColor: Color(0xFF4A3728)),
                );
              },
              child: const Text('チュートリアルをもう一度見る', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1610),
                foregroundColor: const Color(0xFFC8A97A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('フィードバック送信フォームを開きます（デモ）'), backgroundColor: Color(0xFF4A3728)),
                );
              },
              child: const Text('フィードバックを送信する', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1610),
                foregroundColor: const Color(0xFF8B7355),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('利用規約 & プライバシーポリシー', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 離脱確認ダイアログ
  Future<String?> _showDiscardConfirmDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFC8A97A), width: 1.5),
        ),
        title: const Text(
          '未保存の変更があります',
          style: TextStyle(color: Color(0xFFF5EDD8), fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '変更内容を保存してから戻りますか？',
          style: TextStyle(color: Color(0xFF8B7355), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text('保存せずに戻る', style: TextStyle(color: Color(0xFF8B3A1F))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8A97A),
              foregroundColor: const Color(0xFF1C1610),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('保存して戻る', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 中央ふわっとフェード保存完了通知
  void _showSaveSuccessOverlay() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (context.mounted) Navigator.of(context).pop();
        });

        return Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.8 + 0.2 * value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2318),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC8A97A), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFC8A97A),
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      '設定を保存しました',
                      style: TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
