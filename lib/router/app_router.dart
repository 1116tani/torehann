// lib/router/app_router.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adventure_routes.dart';
import 'auth_routes.dart';
import 'home_routes.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.auth,
  refreshListenable: GoRouterRefreshStream(
    _authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = _currentUser() != null;
    final isGoingToAuth = state.matchedLocation == AppRoutes.auth;
    final isGoingToTitle = state.matchedLocation == AppRoutes.title;
    final isGoingToLoginArea = isGoingToAuth || isGoingToTitle;

    if (!isLoggedIn && !isGoingToLoginArea) {
      return AppRoutes.auth;
    }

    if (isLoggedIn && isGoingToLoginArea) {
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

User? _currentUser() {
  try {
    return FirebaseAuth.instance.currentUser;
  } on FirebaseException {
    return null;
  }
}

Stream<User?> _authStateChanges() {
  try {
    return FirebaseAuth.instance.authStateChanges();
  } on FirebaseException {
    return const Stream<User?>.empty();
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
