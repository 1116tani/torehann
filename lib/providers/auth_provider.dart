// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ── 💡 Firebase Authのインスタンスを提供するProvider ──
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// ── 💡 現在のログイン状態（Userかnullか）をリアルタイムに監視するProvider ──
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// ── 💡 匿名ログインの処理を担当するコントローラー ──
final authControllerProvider = Provider((ref) {
  return AuthController(ref.watch(firebaseAuthProvider));
});

class AuthController {
  final FirebaseAuth _auth;
  AuthController(this._auth);

  /// 🪄 匿名ログインを呼び出す
  Future<UserCredential?> signInAnonymously() async {
    try {
      // これを呼ぶだけで、裏でパスワードなしの固有UIDが作られるの
      final userCredential = await _auth.signInAnonymously();
      return userCredential;
    } catch (e) {
      print('サインインに失敗しました…: $e');
      return null;
    }
  }

  /// 🚪 ログアウト（データを手放す覚悟がある時用…！）
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
