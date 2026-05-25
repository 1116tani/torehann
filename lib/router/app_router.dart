import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'auth_routes.dart';
import 'home_routes.dart';
import 'adventure_routes.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.auth,

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final isLoggedIn = user != null;
    final isGoingToTitle =
        state.matchedLocation == AppRoutes.title;

    // 未ログイン
    if (!isLoggedIn && !isGoingToTitle) {
      return AppRoutes.title;
    }

    // ログイン済み
    if (isLoggedIn && isGoingToTitle) {
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
    return Scaffold(
      body: const Center(
        child: Text('ページが見つかりません'),
      ),
    );
  },
);