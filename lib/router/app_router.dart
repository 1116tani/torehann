import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

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

    // 匿名ログインも含めて、ユーザーがログインしているかどうかの判定
    final isLoggedIn = user != null;
    
    // 現在向かおうとしている先が「認証画面（ログイン画面）」かどうかを判定する形に変えたよ
    final isGoingToAuth = state.matchedLocation == AppRoutes.auth;

    // 1. 未ログインの場合の挙動
    // ログインしていなくて、かつ、まだ認証画面に向かっていないなら、強制的に認証画面へ行かせる
    if (!isLoggedIn && !isGoingToAuth) {
      return AppRoutes.auth;
    }

    // 2. ログイン済みの場合の挙動
    // もうログインしているのに、また認証画面（ログイン画面）を開こうとしたら、ホーム画面へ
    if (isLoggedIn && isGoingToAuth) {
      return AppRoutes.home;
    }

    // どちらの条件にも当てはまらないなら、そのまま進んでよし！
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