// lib/pages/settings/account_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_sizes.dart';
import '../../widgets/common/custom_header.dart';
import '../../widgets/settings/settings_tile.dart';
import '../../widgets/settings/settings_section.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),
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
                      titleColor: const Color(0xFFC8A97A),
                      onTap: () => _showLogoutConfirmDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'アカウント削除',
                      subtitle: 'アカウントと関連するデータをすべて完全に削除します。',
                      titleColor: const Color(0xFF8B3A1F),
                      onTap: () => _showDeleteAccountConfirmDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.cleaning_services_outlined,
                      title: 'すべてのローカルデータを消去',
                      subtitle: '端末に保存されている冒険ログや設定値を初期化します。',
                      titleColor: const Color(0xFF8B3A1F),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF4A3728), width: 1.5),
        ),
        title: Text(
          actionName,
          style: const TextStyle(color: Color(0xFFF5EDD8), fontWeight: FontWeight.bold),
        ),
        content: Text(
          '後ほど Firebase Auth 実装へ切り替え可能です。\n（$actionName のデモ処理）',
          style: const TextStyle(color: Color(0xFF8B7355), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '閉じる',
              style: TextStyle(color: Color(0xFFC8A97A), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF4A3728), width: 1.5),
        ),
        title: const Text('ログアウト', style: TextStyle(color: Color(0xFFF5EDD8), fontWeight: FontWeight.bold)),
        content: const Text('本当にログアウトしますか？', style: TextStyle(color: Color(0xFF8B7355))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ここで擬似ログアウト処理か、あるいはログイン画面などへ遷移
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ログアウトしました（デモ）'), backgroundColor: Color(0xFF4A3728)),
              );
            },
            child: const Text('ログアウトする', style: TextStyle(color: Color(0xFFC8A97A), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF8B3A1F), width: 1.5),
        ),
        title: const Text('アカウントの完全削除', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
        content: const Text(
          'この操作は取り消せません。あなたの冒険手帳、コレクション、実績など、すべてのデータが永遠に失われます。\n本当に削除しますか？',
          style: TextStyle(color: Color(0xFF8B7355), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('アカウントを削除しました（デモ）'), backgroundColor: Color(0xFF8B3A1F)),
              );
            },
            child: const Text('削除する', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2318),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF8B3A1F), width: 1.5),
        ),
        title: const Text('ローカルデータの初期化', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
        content: const Text('端末上のすべての設定値を初期化し、初期状態に戻します。よろしいですか？', style: TextStyle(color: Color(0xFF8B7355))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Color(0xFF7A5C3A))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('データを初期化しました（デモ）'), backgroundColor: Color(0xFF8B3A1F)),
              );
            },
            child: const Text('初期化する', style: TextStyle(color: Color(0xFF8B3A1F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
