// lib/pages/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

import '../constants/app_colors.dart';

import '../widgets/common/loading_view.dart';
import '../widgets/common/error_view.dart';

import 'title_page.dart';
import 'home_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final authState = ref.watch(authStateProvider);

    return authState.when(
      // ─────────────────────────────
      // 👤 ログイン済み / 未ログイン
      // ─────────────────────────────
      data: (user) {
        if (user != null) {
          return const HomeScreen();
        }

        return const TitlePage();
      },

      // ─────────────────────────────
      // ⏳ Loading
      // ─────────────────────────────
      loading: () {
        return Scaffold(
          backgroundColor: colors.background,
          body: const LoadingView(message: 'ギルド認証を確認しています...'),
        );
      },

      // ─────────────────────────────
      // ⚠ Error
      // ─────────────────────────────
      error: (error, stackTrace) {
        return Scaffold(
          backgroundColor: colors.background,
          body: ErrorView(
            title: '接続に失敗しました',
            message: '認証情報を取得できませんでした。',
            onRetry: () {
              ref.invalidate(authStateProvider);
            },
          ),
        );
      },
    );
  }
}
