//lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_routes.dart';
import 'home_routes.dart';
import 'adventure_routes.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  // 最初に表示を試みる場所を認証画面に設定しているね、これはこのままで大丈夫！
  initialLocation: AppRoutes.auth,

  redirect: (context, state) {
    // 現在のユーザーのログイン状態を取得するよ
    final user = FirebaseAuth.instance.currentUser;
    // 💡 開発中はダミーユーザーを使用しているため、常にログイン済み（true）として扱います。
    // 本番環境で本物のFirebase認証を使用する際は `user != null` に戻してください。
    final isLoggedIn = user != null ;

    final isGoingToAuth = state.matchedLocation == AppRoutes.auth;

    // 1. 未ログインの場合の挙動
    // ignore: dead_code
    if (!isLoggedIn && !isGoingToAuth) {
      return AppRoutes.auth;
    }

    // 2. ログイン済みの場合の挙動
    if (isLoggedIn && isGoingToAuth) {
      return AppRoutes.home;
    }

    return null;
  },

  routes: [
    ...authRoutes,
    ...homeRoutes,
    ...adventureRoutes,
  ],

  errorBuilder: (context, state) {
    return const Scaffold(
      body: Center(
        child: Text('ページが見つかりません'),
      ),
    );
  },
);