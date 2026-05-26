//lib/router/app_router.dart
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
  const isLoggedIn = true;

  final isGoingToAuth =
      state.fullPath == AppRoutes.auth;

  if (!isLoggedIn && !isGoingToAuth) {
    return AppRoutes.auth;
  }

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