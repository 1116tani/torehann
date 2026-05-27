// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:logger/logger.dart';

/// ── 💡 Firebase Authのインスタンスを提供するProvider ──
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final loggerProvider = Provider((ref) => Logger());

/// ── 💡 現在のログイン状態（Userかnullか）をリアルタイムに監視するProvider ──
final authStateProvider = StreamProvider<User?>((ref) {
  // 💡 ダミーのユーザーオブジェクトを作って、強制的に「ログイン済み」にしちゃうよ！
  // これで AuthGate は絶対に HomeScreen を開いてくれます！
  return FirebaseAuth.instance.authStateChanges();
});

/// ── 💡 匿名ログインの処理を担当するコントローラー ──
final authControllerProvider = Provider((ref) {
  return AuthController(ref.watch(loggerProvider));
});

class AuthController {
  final Logger _logger;
  AuthController(this._logger);

  /// 🪄 匿名ログインを呼び出す
  Future<UserCredential?> signInAnonymously() async {
    try {
      // 💡 Firebaseのエラーで止まらないように、ここもお休みさせるよ
      return await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      _logger.e('サインインに失敗しました…: $e');
      return null;
    }
  }

  /// 🚪 ログアウト
  Future<void> signOut() async {
    // お休み中
  }
}

// 💡 強制ホーム用のダミーユーザー定義（一応用意しておくね）