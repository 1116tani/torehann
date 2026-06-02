// lib/pages/settings/account_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../widgets/common/custom_header.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../widgets/settings/settings_section.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'アカウント管理',
              subtitle: 'ACCOUNT MANAGEMENT',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsSection(title: '認証設定'),
                    SettingsTile(
                      icon: Icons.person_add_alt_1_outlined,
                      title: '新規登録',
                      subtitle: '新しい冒険者アカウントを作成します。',
                      onTap: () => _showMockActionDialog(context, '新規登録'),
                    ),
                    SettingsTile(
                      icon: Icons.login_outlined,
                      title: 'ログイン',
                      subtitle: '登録済みのアカウントに切り替えます。',
                      onTap: () => _showMockActionDialog(context, 'ログイン'),
                    ),
                    const SettingsSection(title: 'アカウント情報変更'),
                    SettingsTile(
                      icon: Icons.mail_outline,
                      title: 'メールアドレス変更',
                      subtitle: 'ログイン用のメールアドレスを変更します。',
                      onTap: () => _showMockActionDialog(context, 'メールアドレス変更'),
                    ),
                    SettingsTile(
                      icon: Icons.lock_open_outlined,
                      title: 'パスワード変更',
                      subtitle: 'セキュリティ用のパスワードを再設定します。',
                      onTap: () => _showMockActionDialog(context, 'パスワード変更'),
                    ),
                    const SettingsSection(title: 'データ & 退会'),
                    SettingsTile(
                      icon: Icons.logout_outlined,
                      title: 'ログアウト',
                      subtitle: '現在のアカウントからサインアウトします。',
                      titleColor: colors.primary,
                      onTap: () => _showLogoutConfirmDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'アカウント削除',
                      subtitle: 'アカウントと関連するデータをすべて完全に削除します。',
                      titleColor: AppColors.error,
                      onTap: () => _showDeleteAccountConfirmDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.cleaning_services_outlined,
                      title: 'すべてのローカルデータを消去',
                      subtitle: '端末に保存されている冒険ログや設定値を初期化します。',
                      titleColor: AppColors.error,
                      onTap: () => _showClearDataConfirmDialog(context),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMockActionDialog(BuildContext context, String actionName) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border, width: 1.5),
        ),
        title: Text(
          actionName,
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '後ほど Firebase Auth 実装へ切り替え可能です。\n（$actionName のデモ処理）',
          style: TextStyle(color: colors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '閉じる',
              style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border, width: 1.5),
        ),
        title: Text('ログアウト', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text('本当にログアウトしますか？', style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル', style: TextStyle(color: colors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ここで擬似ログアウト処理か、あるいはログイン画面などへ遷移
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('ログアウトしました（デモ）'), backgroundColor: colors.surfaceLight),
              );
            },
            child: Text('ログアウトする', style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmDialog(BuildContext context) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.error, width: 1.5),
        ),
        title: Text('アカウントの完全削除', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        content: Text(
          'この操作は取り消せません。あなたの冒険手帳、コレクション、実績など、すべてのデータが永遠に失われます。\n本当に削除しますか？',
          style: TextStyle(color: colors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル', style: TextStyle(color: colors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('アカウントを削除しました（デモ）'), backgroundColor: colors.surfaceLight),
              );
            },
            child: Text('削除する', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmDialog(BuildContext context) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.error, width: 1.5),
        ),
        title: Text('ローカルデータの初期化', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        content: Text('端末上のすべての設定値を初期化し、初期状態に戻します。よろしいですか？', style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル', style: TextStyle(color: colors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('データを初期化しました（デモ）'), backgroundColor: colors.surfaceLight),
              );
            },
            child: Text('初期化する', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
