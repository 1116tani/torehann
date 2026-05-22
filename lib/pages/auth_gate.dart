// lib/pages/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'title_page.dart';
import 'home_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ログイン状態をリアルタイムで監視するよ
    final authState = ref.watch(authStateProvider);

    return authState.when(
      // 💡 データの状態によって画面を出し分けるよ！
      data: (user) {
        if (user != null) {
          // ログイン済み → ホームへ
          return const HomeScreen();
        } else {
          // 未ログイン → タイトルへ
          return const TitlePage();
        }
      },
      // ⏳ 読み込み中のぐるぐる画面
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF1C1610),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
          ),
        ),
      ),
      // ⚠️ 万が一のエラー画面
      error: (e, trace) => Scaffold(
        backgroundColor: const Color(0xFF1C1610),
        body: Center(
          child: Text(
            '精霊の導きが途絶えてしまいました…\n$e',
            style: const TextStyle(color: Color(0xFFC8A97A)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
